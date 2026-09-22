#!/bin/bash

# Interrompe o script imediatamente se qualquer comando falhar
set -e

echo "🚀 Iniciando o processo de Build e Deploy..."

# # 1. Compila o backend Java (Lambda de Salvar)
# echo "☕ Construindo o Fat JAR com Maven (Java)..."
# cd backend
# mvn clean package
# cd ..

# 2. Empacota o backend Python (Lambda de Busca)
echo "🐍 Preparando o pacote da Lambda Python..."
cd backend-python

# Remove o zip antigo (se existir) para garantir um pacote limpo
rm -f function.zip

# Instala a dependência diretamente na pasta atual. 
# Dica: Se no futuro você tiver mais bibliotecas, substitua a linha abaixo por: pip install -r requirements.txt -t .
pip install howlongtobeatpy -t .

# Compacta todos os arquivos da pasta em function.zip
# O parâmetro -q (quiet) oculta a longa lista de arquivos no terminal
zip -rq function.zip .

cd ..

# 3. Executa o Terraform
echo "☁️ Aplicando infraestrutura na AWS..."
cd terraform

# Inicializa o Terraform caso seja a primeira vez
terraform init

# Aplica as mudanças. O Terraform vai detectar as alterações no .jar e no .zip
terraform apply -auto-approve

echo "✅ Deploy finalizado com sucesso! Acesse a URL gerada pelo API Gateway."