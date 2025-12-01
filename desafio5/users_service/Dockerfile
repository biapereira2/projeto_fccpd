# Dockerfile para o Microsserviço de Usuários
FROM python:3.11-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação
COPY app.py .

# Expõe a porta do serviço
EXPOSE 5001

# Comando para iniciar a aplicação
CMD ["python", "app.py"]
