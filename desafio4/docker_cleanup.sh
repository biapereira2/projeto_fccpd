#!/bin/bash
# Script de Cleanup - Desafio 4: Microsserviços Independentes
# Bash Script para Linux/MacOS

echo "========================================"
echo "  Cleanup - Desafio 4"
echo "========================================"
echo ""

# Parar e remover containers
echo "[1/3] Parando e removendo containers..."

echo "      Removendo container service_b..."
docker stop service_b 2>/dev/null
docker rm service_b 2>/dev/null

echo "      Removendo container service_a..."
docker stop service_a 2>/dev/null
docker rm service_a 2>/dev/null

echo "      Containers removidos!"
echo ""

# Remover imagens
echo "[2/3] Removendo imagens Docker..."
docker rmi service_a:latest 2>/dev/null
docker rmi service_b:latest 2>/dev/null
echo "      Imagens removidas!"
echo ""

# Remover rede
echo "[3/3] Removendo rede Docker..."
docker network rm microservices_net 2>/dev/null
echo "      Rede removida!"
echo ""

echo "========================================"
echo "  Cleanup concluído com sucesso!"
echo "========================================"
echo ""
