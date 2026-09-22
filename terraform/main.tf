terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuramos o provider para bater na mesma região dos nossos testes
provider "aws" {
  region = "us-east-1"

  # Boas práticas: Adicionando tags globais para todos os recursos que criarmos
  default_tags {
    tags = {
      Project     = "Game-Backlog-Tracker"
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}

# ======== Modulos ========

# S3
module "s3_backlog" {
  source      = "./modules/s3"
  bucket_name = "game-backlog-thiago-2026"

}

# Lambda

# module "lambda_backlog_api" {
#   source        = "./modules/lambda"
#   function_name = "game-backlog-api-handler"

#   # Com Java se aponta para o .jar compliado
#   source_file   = "../backend/target/game-backlog-1.0-SNAPSHOT-jar-with-dependencies.jar"

#   # handler padrão java
#   handler = "com.thiago.backlog.GameBacklogHandler::handleRequest"

#   runtime = "java21"

#   environment_variables = {
#     BACKLOG_BUCKET_NAME = module.s3_backlog.bucket_name
#   }
# }

data "archive_file" "python_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../backend-python"
  output_path = "${path.root}/function.zip" # Salva o zip na raiz do terraform
}

# ======== Módulo Lambda (Python - Busca HLTB) ========
module "lambda_python_search" {
  source        = "./modules/lambda"
  function_name = "game-backlog-search-api"
  
  source_file   = data.archive_file.python_zip.output_path 
  
  handler       = "data_orchestrator.lambda_handler"
  runtime       = "python3.13"

  # Variáveis de ambiente (se precisar)
  environment_variables = {}
}

## ======== API GATEWAY (HTTP API) =======
# Cria a porta para o frontend Next ou angular chamar a lambda
resource "aws_apigatewayv2_api" "http_api" {
  name = "game-backlog-http-api"
  protocol_type = "HTTP"

  # CORS direto no API GATEWAY
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Content-Type", "Authorization"]
  }
}
# # Integra a API com a Lambda JAVA
# resource "aws_apigatewayv2_integration" "lambda_integration" {
#   api_id         = aws_apigatewayv2_api.http_api.id
#   integration_type = "AWS_PROXY"

#   integration_method = "POST"
#   integration_uri = module.lambda_backlog_api.function_invoke_arn
#   payload_format_version = "2.0"
# }

# Integração do API Gateway com a Lambda Python
resource "aws_apigatewayv2_integration" "python_search_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  
  integration_method     = "POST" # Sempre POST para a Lambda internamente
  integration_uri        = module.lambda_python_search.function_invoke_arn
  payload_format_version = "2.0"
}


# # Cria uma rota que o Frontend vai chamar (Ex: POST /games)
# resource "aws_apigatewayv2_route" "api_route" {
#   api_id = aws_apigatewayv2_api.http_api.id
#   route_key = "ANY / {proxy}" # Encaminha qualquer rota/método para a Lambda (ela roteia internamente)
#   target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
# }

# Rota ESPECÍFICA para a busca (GET /search)
resource "aws_apigatewayv2_route" "search_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /search" 
  target    = "integrations/${aws_apigatewayv2_integration.python_search_integration.id}"
}

# Cria o Stage (ambiente)
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.http_api.id
  name = "$default"
  auto_deploy = true
}



# ========= Permissões =========

# # Permite que o API Gateway invoque a sua Lambda
# resource "aws_lambda_permission" "allow_apigw_to_invoke_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = module.lambda_backlog_api.function_name
#   principal     = "apigateway.amazonaws.com"

#   # Garante que só o API GATEWAY específico pode disparar a função
#   source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
# }

# Permite que o API Gateway invoque a Lambda Python
resource "aws_lambda_permission" "allow_apigw_to_invoke_python" {
  statement_id  = "AllowExecutionFromAPIGatewayToPython"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_python_search.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*/search"
}


output "api_url" {
  value = aws_apigatewayv2_stage.default_stage.invoke_url
  description = "URL base para configurar no frontend"
}
