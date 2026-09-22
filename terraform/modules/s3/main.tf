resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = true
}

# Bloqueio de acesso publico (Segurança padrao aws)
resource "aws_s3_bucket_public_access_block" "data_project_block" {
  bucket = aws_s3_bucket.this.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# Configuração de CORS para permitir o upload direto do angular via Presigned URL
resource "aws_s3_bucket_cors_configuration" "data_project_cors" {
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"] # Em prod, ficara apenas o dominio do MFE
    expose_headers = []
    max_age_seconds = 3000
  }  
}

# Habilita o versionamento do s3 para evitar perda de dados
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}