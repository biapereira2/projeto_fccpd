# Dockerfile para o API Gateway
FROM python:3.11-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação
COPY app.py .

# Expõe a porta do gateway
EXPOSE 5000

# Comando para iniciar a aplicação
CMD ["python", "app.py"]
