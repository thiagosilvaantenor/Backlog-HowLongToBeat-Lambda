output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "O ARN do bucket S3"
  value = aws_s3_bucket.this.arn
}