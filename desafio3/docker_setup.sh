echo "============================================"
echo "  Desafio 3 - Docker Compose Setup"
echo "  Servicos: Web + PostgreSQL + Redis"
echo "============================================"
echo ""

cd "$(dirname "$0")"

echo "[1/4] Verificando Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "ERRO: Docker nao esta rodando. Inicie o Docker."
    exit 1
fi
echo "Docker esta funcionando!"
echo ""

echo "[2/4] Parando containers existentes (se houver)..."
docker compose down 2>/dev/null
echo ""

echo "[3/4] Construindo imagens..."
if ! docker compose build --no-cache; then
    echo "ERRO: Falha ao construir imagens."
    exit 1
fi
echo "Imagens construidas com sucesso!"
echo ""

echo "[4/4] Iniciando servicos..."
if ! docker compose up -d; then
    echo "ERRO: Falha ao iniciar servicos."
    exit 1
fi
echo ""

echo "Aguardando servicos ficarem prontos..."
sleep 10

echo ""
echo "============================================"
echo "  Servicos iniciados com sucesso!"
echo "============================================"
echo ""
echo "Status dos containers:"
docker compose ps
echo ""
echo "Endpoints disponiveis:"
echo "  - Web App:      http://localhost:5000"
echo "  - Health:       http://localhost:5000/health"
echo "  - Visita:       http://localhost:5000/visit"
echo "  - Estatisticas: http://localhost:5000/stats"
echo ""
echo "Para ver logs: docker compose logs -f"
echo "Para parar:    ./docker_cleanup.sh"
echo ""
