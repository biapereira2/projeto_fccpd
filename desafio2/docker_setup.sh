echo ""
echo "============================================================"
echo "  DESAFIO 2 - VOLUMES E PERSISTENCIA DE DADOS"
echo "============================================================"
echo ""

VOLUME_NAME="desafio2-sqlite-data"
IMAGE_WRITER="desafio2-writer"
IMAGE_READER="desafio2-reader"
CONTAINER_WRITER="sqlite-writer"
CONTAINER_READER="sqlite-reader"

echo "[PASSO 1] Criando volume Docker para persistencia..."
docker volume create $VOLUME_NAME
echo "[OK] Volume '$VOLUME_NAME' criado!"
echo ""

echo "[INFO] Detalhes do volume:"
docker volume inspect $VOLUME_NAME
echo ""

echo "[PASSO 2] Construindo imagens Docker..."

echo "  -> Construindo imagem do escritor (writer)..."
docker build -t $IMAGE_WRITER ./app
echo "[OK] Imagem '$IMAGE_WRITER' criada!"

echo "  -> Construindo imagem do leitor (reader)..."
docker build -t $IMAGE_READER ./reader
echo "[OK] Imagem '$IMAGE_READER' criada!"
echo ""

echo "[PASSO 3] Executando container ESCRITOR (primeira execucao)..."
echo "  -> Este container vai criar registros no banco de dados"
echo ""

docker run --rm --name $CONTAINER_WRITER \
    -v ${VOLUME_NAME}:/data \
    -e APP_MODE=write \
    $IMAGE_WRITER

echo ""
echo "[OK] Container escritor executado e removido automaticamente (--rm)"
echo ""

echo "[PASSO 4] Verificando que o container foi removido..."
if [ -z "$(docker ps -a --filter "name=$CONTAINER_WRITER" --format "{{.Names}}")" ]; then
    echo "[OK] Container '$CONTAINER_WRITER' nao existe mais!"
else
    echo "[INFO] Container ainda existe"
fi
echo ""

echo "[PASSO 5] Verificando que o volume ainda existe com os dados..."
if [ "$(docker volume ls --filter "name=$VOLUME_NAME" --format "{{.Name}}")" == "$VOLUME_NAME" ]; then
    echo "[OK] Volume '$VOLUME_NAME' ainda existe!"
else
    echo "[ERRO] Volume nao encontrado!"
fi
echo ""

echo "[PASSO 6] Executando container LEITOR para verificar persistencia..."
echo "  -> Este eh um container DIFERENTE que ira ler os mesmos dados"
echo ""

docker run --rm --name $CONTAINER_READER \
    -v ${VOLUME_NAME}:/data \
    -e APP_MODE=read \
    $IMAGE_READER

echo ""
echo "[OK] Container leitor verificou os dados persistidos!"
echo ""

echo "[PASSO 7] Executando container ESCRITOR novamente..."
echo "  -> Adicionando mais registros para demonstrar persistencia"
echo ""

docker run --rm --name $CONTAINER_WRITER \
    -v ${VOLUME_NAME}:/data \
    -e APP_MODE=write \
    $IMAGE_WRITER

echo ""
echo "[OK] Mais registros adicionados ao banco!"
echo ""

# ============================================================
# PASSO 8: Verificar todos os dados acumulados
# ============================================================
echo "[PASSO 8] Verificacao final - Lendo TODOS os dados persistidos..."
echo ""

docker run --rm --name $CONTAINER_READER \
    -v ${VOLUME_NAME}:/data \
    -e APP_MODE=read \
    $IMAGE_READER

echo ""

# ============================================================
# RESUMO FINAL
# ============================================================
echo "============================================================"
echo "  DEMONSTRACAO CONCLUIDA COM SUCESSO!"
echo "============================================================"
echo ""
echo "  O que foi demonstrado:"
echo "  1. Criacao de volume Docker nomeado"
echo "  2. Container escritor adicionou dados ao SQLite"
echo "  3. Container foi removido (--rm)"
echo "  4. Volume persistiu com os dados"
echo "  5. Container leitor (diferente) leu os dados"
echo "  6. Novo container escritor adicionou mais dados"
echo "  7. Todos os dados acumulados foram preservados"
echo ""
echo "  Volume: $VOLUME_NAME"
echo ""
echo "  Para limpar: ./docker_cleanup.sh"
echo "============================================================"
echo ""
