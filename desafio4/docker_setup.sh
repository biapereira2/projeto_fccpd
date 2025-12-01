#!/bin/bash
# Script de Setup - Desafio 4: Microsserviços Independentes
# Bash Script para Linux/MacOS

echo "========================================"
echo "  Desafio 4 - Microsserviços Independentes"
echo "========================================"
echo ""

# Criar rede Docker para comunicação entre os microsserviços
echo "[1/4] Criando rede Docker 'microservices_net'..."
docker network create microservices_net 2>/dev/null
if [ $? -eq 0 ]; then
    echo "      Rede criada com sucesso!"
else
    echo "      Rede já existe ou erro ao criar (continuando...)"
fi
echo ""

# Build da imagem do Microsserviço A
echo "[2/4] Construindo imagem do Microsserviço A (Users API)..."
docker build -t service_a:latest ./service_a
if [ $? -ne 0 ]; then
    echo "      Erro ao construir Microsserviço A!"
    exit 1
fi
echo "      Imagem service_a construída com sucesso!"
echo ""

# Build da imagem do Microsserviço B
echo "[3/4] Construindo imagem do Microsserviço B (Consumer)..."
docker build -t service_b:latest ./service_b
if [ $? -ne 0 ]; then
    echo "      Erro ao construir Microsserviço B!"
    exit 1
fi
echo "      Imagem service_b construída com sucesso!"
echo ""

# Executar os containers
echo "[4/4] Iniciando containers..."

# Iniciar Microsserviço A
echo "      Iniciando Microsserviço A na porta 5050..."
docker run -d \
    --name service_a \
    --network microservices_net \
    -p 5050:5050 \
    service_a:latest

if [ $? -ne 0 ]; then
    echo "      Erro ao iniciar Microsserviço A!"
    exit 1
fi

# Aguardar um pouco para o serviço A iniciar
sleep 2

# Iniciar Microsserviço B
echo "      Iniciando Microsserviço B na porta 5051..."
docker run -d \
    --name service_b \
    --network microservices_net \
    -p 5051:5051 \
    -e SERVICE_A_URL=http://service_a:5050 \
    service_b:latest

if [ $? -ne 0 ]; then
    echo "      Erro ao iniciar Microsserviço B!"
    exit 1
fi

echo ""
echo "========================================"
echo "  Setup concluído com sucesso!"
echo "========================================"
echo ""
echo "Endpoints disponíveis:"
echo ""
echo "  Microsserviço A (Users API):"
echo "    - Health Check:    http://localhost:5050/health"
echo "    - Lista usuários:  http://localhost:5050/users"
echo "    - Usuário por ID:  http://localhost:5050/users/{id}"
echo "    - Usuários ativos: http://localhost:5050/users/active"
echo ""
echo "  Microsserviço B (Consumer):"
echo "    - Health Check:    http://localhost:5051/health"
echo "    - Dashboard HTML:  http://localhost:5051/"
echo "    - API combinada:   http://localhost:5051/api/users-info"
echo "    - Usuário por ID:  http://localhost:5051/api/user/{id}"
echo ""
echo "Para verificar os containers:"
echo "  docker ps"
echo ""
echo "Para ver os logs:"
echo "  docker logs service_a"
echo "  docker logs service_b"
echo ""
