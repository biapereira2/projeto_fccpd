echo ""
echo "============================================================"
echo "  DESAFIO 2 - LIMPEZA DE RECURSOS"
echo "============================================================"
echo ""

VOLUME_NAME="desafio2-sqlite-data"
IMAGE_WRITER="desafio2-writer"
IMAGE_READER="desafio2-reader"
CONTAINER_WRITER="sqlite-writer"
CONTAINER_READER="sqlite-reader"

echo "[PASSO 1] Removendo containers..."

if [ ! -z "$(docker ps -a --filter "name=$CONTAINER_WRITER" --format "{{.Names}}")" ]; then
    docker stop $CONTAINER_WRITER 2>/dev/null
    docker rm $CONTAINER_WRITER 2>/dev/null
    echo "[OK] Container '$CONTAINER_WRITER' removido"
else
    echo "[INFO] Container '$CONTAINER_WRITER' nao existe"
fi

if [ ! -z "$(docker ps -a --filter "name=$CONTAINER_READER" --format "{{.Names}}")" ]; then
    docker stop $CONTAINER_READER 2>/dev/null
    docker rm $CONTAINER_READER 2>/dev/null
    echo "[OK] Container '$CONTAINER_READER' removido"
else
    echo "[INFO] Container '$CONTAINER_READER' nao existe"
fi
echo ""

echo "[PASSO 2] Removendo imagens Docker..."

if [ ! -z "$(docker images -q $IMAGE_WRITER)" ]; then
    docker rmi $IMAGE_WRITER
    echo "[OK] Imagem '$IMAGE_WRITER' removida"
else
    echo "[INFO] Imagem '$IMAGE_WRITER' nao existe"
fi

if [ ! -z "$(docker images -q $IMAGE_READER)" ]; then
    docker rmi $IMAGE_READER
    echo "[OK] Imagem '$IMAGE_READER' removida"
else
    echo "[INFO] Imagem '$IMAGE_READER' nao existe"
fi
echo ""

echo "[PASSO 3] Removendo volume Docker..."

if [ "$(docker volume ls --filter "name=$VOLUME_NAME" --format "{{.Name}}")" == "$VOLUME_NAME" ]; then
    docker volume rm $VOLUME_NAME
    echo "[OK] Volume '$VOLUME_NAME' removido"
    echo "[NOTA] Os dados do SQLite foram removidos junto com o volume!"
else
    echo "[INFO] Volume '$VOLUME_NAME' nao existe"
fi
echo ""

echo "============================================================"
echo "  LIMPEZA CONCLUIDA!"
echo "============================================================"
echo ""
echo "  Recursos removidos:"
echo "  - Containers: $CONTAINER_WRITER, $CONTAINER_READER"
echo "  - Imagens: $IMAGE_WRITER, $IMAGE_READER"
echo "  - Volume: $VOLUME_NAME"
echo ""
echo "  Para executar novamente: ./docker_setup.sh"
echo "============================================================"
echo ""
