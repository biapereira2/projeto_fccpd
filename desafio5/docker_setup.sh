#!/bin/bash
# Script de Setup - Docker Compose (Bash)
# Desafio 5: Microsserviços com API Gateway

echo "============================================"
echo "  Desafio 5 - Microsservicos com API Gateway"
echo "============================================"
echo ""

# Navegar para o diretório do script
cd "$(dirname "$0")"

echo "[1/3] Construindo as imagens Docker..."
docker-compose build --no-cache

if [ $? -ne 0 ]; then
    echo "Erro ao construir as imagens!"
    exit 1
fi

echo ""
echo "[2/3] Iniciando os containers..."
docker-compose up -d

if [ $? -ne 0 ]; then
    echo "Erro ao iniciar os containers!"
    exit 1
fi

echo ""
echo "[3/3] Aguardando os serviços iniciarem..."
sleep 5

echo ""
echo "============================================"
echo "  Setup concluido com sucesso!"
echo "============================================"
echo ""
echo "Containers em execucao:"
docker-compose ps

echo ""
echo "Endpoints disponiveis:"
echo "  API Gateway:     http://localhost:5000"
echo "  Users Service:   http://localhost:5001"
echo "  Orders Service:  http://localhost:5002"
echo ""
echo "Testes rapidos (via Gateway):"
echo "  curl http://localhost:5000/"
echo "  curl http://localhost:5000/health"
echo "  curl http://localhost:5000/users"
echo "  curl http://localhost:5000/orders"
echo "  curl http://localhost:5000/users/1/orders"
echo ""
