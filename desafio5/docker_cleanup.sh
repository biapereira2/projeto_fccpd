#!/bin/bash
# Script de Cleanup - Docker Compose (Bash)
# Desafio 5: Microsserviços com API Gateway

echo "============================================"
echo "  Desafio 5 - Limpeza do Ambiente"
echo "============================================"
echo ""

# Navegar para o diretório do script
cd "$(dirname "$0")"

echo "[1/3] Parando os containers..."
docker-compose down

echo ""
echo "[2/3] Removendo imagens criadas..."
docker rmi desafio5-api-gateway desafio5-users-service desafio5-orders-service 2>/dev/null

echo ""
echo "[3/3] Removendo rede (se existir)..."
docker network rm desafio5-network 2>/dev/null

echo ""
echo "============================================"
echo "  Limpeza concluida com sucesso!"
echo "============================================"
echo ""
echo "Containers restantes:"
docker ps -a --filter "name=users-service" --filter "name=orders-service" --filter "name=api-gateway"
echo ""
