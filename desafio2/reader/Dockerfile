# Dockerfile para o container leitor
# Este container apenas lê os dados persistidos no volume

FROM python:3.11-alpine

# Metadados
LABEL maintainer="Desafio Docker"
LABEL description="Container leitor para demonstrar persistência com volumes"

# Criar diretório de trabalho
WORKDIR /app

# Criar diretório para dados (será montado via volume)
RUN mkdir -p /data

# Copiar aplicação
COPY database_app.py .

# Variáveis de ambiente padrão - modo leitura
ENV DATABASE_PATH=/data/database.db
ENV APP_MODE=read

# Comando padrão
CMD ["python", "database_app.py"]
