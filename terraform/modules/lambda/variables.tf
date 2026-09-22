variable "function_name" {
  type = string
  description = "Nome da função Lambda"
}

variable "source_file" {
  type = string
  description = "Caminho para o arquivo .jar compilado"
}

variable "handler" {
  type        = string
  description = "Nome do arquivo e da função principal (ex: generate_upload_url.lambda_handler)"
}

variable "runtime" {
  type    = string
  default = "java21"
  description = "Runtime da Lambda"
}

variable "environment_variables" {
  type    = map(string)
  default = {}
  description = "Variaveais de ambiente"
}

variable "memory_size" {
  type = number
  default = 512
  description = "Memória alocada (Java exige mais que Python)"
}

variable "timeout" {
  type = number
  default = 30
  description = "Tempo limite de execução em segundos"
}
