# Imagem base Python slim
FROM python:3.11-slim

# Diretório de trabalho
WORKDIR /app

# Copiar requirements primeiro (aproveitar cache de camadas)
COPY requirements.txt .

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY app.py .

# Expor porta da aplicação
EXPOSE 5000

# Comando para iniciar a aplicação
CMD ["python", "app.py"]
