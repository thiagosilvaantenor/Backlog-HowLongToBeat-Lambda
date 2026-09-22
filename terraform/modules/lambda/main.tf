# Criação da Role de execução da lambda
resource "aws_iam_role" "this" {
  name = "${var.function_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# # Anexa a politica básica da AWS para a lambda gerar logs no Cloudwatch
# resource "aws_iam_role_attachment" "lambda_basic_execution" {
#   role = aws_iam_role.this.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# Definição da função
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role = aws_iam_role.this.arn
  handler = var.handler
  runtime = var.runtime
  memory_size = var.memory_size
  timeout = var.timeout

  # Aponta para o arquivo .jar
  filename      = var.source_file
  
  source_code_hash = filebase64sha256(var.source_file)
  environment {
    variables = var.environment_variables
  }
}

