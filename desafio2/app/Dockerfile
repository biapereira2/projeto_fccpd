# Dockerfile para Desafio 2 - Volumes e Persistência
# Imagem base Python Alpine para menor tamanho

FROM python:3.11-alpine

# Metadados
LABEL maintainer="Desafio Docker"
LABEL description="Aplicação SQLite para demonstrar persistência com volumes"

# Criar diretório de trabalho
WORKDIR /app

# Criar diretório para dados (será montado via volume)
RUN mkdir -p /data

# Copiar aplicação
COPY database_app.py .

# Variáveis de ambiente padrão
ENV DATABASE_PATH=/data/database.db
ENV APP_MODE=write

# Comando padrão
CMD ["python", "database_app.py"]
