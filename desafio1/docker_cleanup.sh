#!/bin/bash
# Script de Limpeza - Desafio 1: Containers em Rede
# Execute: ./docker_cleanup.sh

NET_NAME="desafio1-net"
SERVER_NAME="server"
CLIENT_NAME="client"

echo "========================================"
echo "  Limpeza - Desafio 1"
echo "========================================"
echo ""

# Parar e remover containers
echo "[1/2] Parando e removendo containers..."
docker rm -f $SERVER_NAME 2>/dev/null
docker rm -f $CLIENT_NAME 2>/dev/null
echo "      Containers removidos!"

# Remover rede
echo "[2/2] Removendo rede Docker..."
docker network rm $NET_NAME 2>/dev/null
echo "      Rede removida!"

echo ""
echo "========================================"
echo "  Limpeza concluida!"
echo "========================================"
echo ""
echo "Para remover as imagens tambem, execute:"
echo "  docker rmi desafio1-server desafio1-client"
