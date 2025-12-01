# Microsserviço B - Consumidor de Usuários
FROM python:3.11-slim

# Definir diretório de trabalho
WORKDIR /app

# Copiar requirements primeiro (para cache de camadas)
COPY requirements.txt .

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY app.py .

# Expor a porta do serviço
EXPOSE 5051

# Variáveis de ambiente
ENV FLASK_APP=app.py
ENV PYTHONUNBUFFERED=1
ENV SERVICE_A_URL=http://service_a:5050

# Comando para executar a aplicação
CMD ["python", "app.py"]
