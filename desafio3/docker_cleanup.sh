echo "============================================"
echo "  Desafio 3 - Docker Compose Cleanup"
echo "============================================"
echo ""

cd "$(dirname "$0")"


echo "[1/3] Parando e removendo containers..."
docker compose down
echo ""

read -p "Deseja remover os volumes de dados? (s/N): " removeVolumes
if [[ "$removeVolumes" == "s" || "$removeVolumes" == "S" ]]; then
    echo "[2/3] Removendo volumes..."
    docker compose down -v
    docker volume rm desafio3_postgres_data 2>/dev/null
    docker volume rm desafio3_redis_data 2>/dev/null
    echo "Volumes removidos!"
else
    echo "[2/3] Volumes mantidos."
fi
echo ""

read -p "Deseja remover as imagens construidas? (s/N): " removeImages
if [[ "$removeImages" == "s" || "$removeImages" == "S" ]]; then
    echo "[3/3] Removendo imagens..."
    docker compose down --rmi local
    echo "Imagens removidas!"
else
    echo "[3/3] Imagens mantidas."
fi
echo ""

docker network rm desafio3_network 2>/dev/null

echo "============================================"
echo "  Cleanup concluido!"
echo "============================================"
echo ""
