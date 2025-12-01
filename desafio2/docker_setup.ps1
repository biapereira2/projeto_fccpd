Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  DESAFIO 2 - VOLUMES E PERSISTENCIA DE DADOS" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$VOLUME_NAME = "desafio2-sqlite-data"
$IMAGE_WRITER = "desafio2-writer"
$IMAGE_READER = "desafio2-reader"
$CONTAINER_WRITER = "sqlite-writer"
$CONTAINER_READER = "sqlite-reader"

Write-Host "[PASSO 1] Criando volume Docker para persistencia..." -ForegroundColor Yellow
docker volume create $VOLUME_NAME
Write-Host "[OK] Volume '$VOLUME_NAME' criado!" -ForegroundColor Green
Write-Host ""

Write-Host "[INFO] Detalhes do volume:" -ForegroundColor Cyan
docker volume inspect $VOLUME_NAME
Write-Host ""

Write-Host "[PASSO 2] Construindo imagens Docker..." -ForegroundColor Yellow

Write-Host "  -> Construindo imagem do escritor (writer)..." -ForegroundColor White
docker build -t $IMAGE_WRITER ./app
Write-Host "[OK] Imagem '$IMAGE_WRITER' criada!" -ForegroundColor Green

Write-Host "  -> Construindo imagem do leitor (reader)..." -ForegroundColor White
docker build -t $IMAGE_READER ./reader
Write-Host "[OK] Imagem '$IMAGE_READER' criada!" -ForegroundColor Green
Write-Host ""

Write-Host "[PASSO 3] Executando container ESCRITOR (primeira execucaoo)..." -ForegroundColor Yellow
Write-Host "  -> Este container vai criar registros no banco de dados" -ForegroundColor White
Write-Host ""

docker run --rm --name $CONTAINER_WRITER `
    -v ${VOLUME_NAME}:/data `
    -e APP_MODE=write `
    $IMAGE_WRITER

Write-Host ""
Write-Host "[OK] Container escritor executado e removido automaticamente (--rm)" -ForegroundColor Green
Write-Host ""

Write-Host "[PASSO 4] Verificando que o container foi removido..." -ForegroundColor Yellow
$containers = docker ps -a --filter "name=$CONTAINER_WRITER" --format "{{.Names}}"
if ([string]::IsNullOrEmpty($containers)) {
    Write-Host "[OK] Container '$CONTAINER_WRITER' nao existe mais!" -ForegroundColor Green
} else {
    Write-Host "[INFO] Container ainda existe: $containers" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "[PASSO 5] Verificando que o volume ainda existe com os dados..." -ForegroundColor Yellow
$volumeExists = docker volume ls --filter "name=$VOLUME_NAME" --format "{{.Name}}"
if ($volumeExists -eq $VOLUME_NAME) {
    Write-Host "[OK] Volume '$VOLUME_NAME' ainda existe!" -ForegroundColor Green
} else {
    Write-Host "[ERRO] Volume nao encontrado!" -ForegroundColor Red
}
Write-Host ""

Write-Host "[PASSO 6] Executando container LEITOR para verificar persistencia..." -ForegroundColor Yellow
Write-Host "  -> Este eh um container DIFERENTE que vai ler os mesmos dados" -ForegroundColor White
Write-Host ""

docker run --rm --name $CONTAINER_READER `
    -v ${VOLUME_NAME}:/data `
    -e APP_MODE=read `
    $IMAGE_READER

Write-Host ""
Write-Host "[OK] Container leitor verificou os dados persistidos!" -ForegroundColor Green
Write-Host ""

Write-Host "[PASSO 7] Executando container ESCRITOR novamente..." -ForegroundColor Yellow
Write-Host "  -> Adicionando mais registros para demonstrar persistencia" -ForegroundColor White
Write-Host ""

docker run --rm --name $CONTAINER_WRITER `
    -v ${VOLUME_NAME}:/data `
    -e APP_MODE=write `
    $IMAGE_WRITER

Write-Host ""
Write-Host "[OK] Mais registros adicionados ao banco!" -ForegroundColor Green
Write-Host ""

Write-Host "[PASSO 8] Verificacao final - Lendo TODOS os dados persistidos..." -ForegroundColor Yellow
Write-Host ""

docker run --rm --name $CONTAINER_READER `
    -v ${VOLUME_NAME}:/data `
    -e APP_MODE=read `
    $IMAGE_READER

Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  DEMONSTRACAOO CONCLUIDA COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  O que foi demonstrado:" -ForegroundColor White
Write-Host "  1. Criacao de volume Docker nomeado" -ForegroundColor White
Write-Host "  2. Container escritor adicionou dados ao SQLite" -ForegroundColor White
Write-Host "  3. Container foi removido (--rm)" -ForegroundColor White
Write-Host "  4. Volume persistiu com os dados" -ForegroundColor White
Write-Host "  5. Container leitor (diferente) leu os dados" -ForegroundColor White
Write-Host "  6. Novo container escritor adicionou mais dados" -ForegroundColor White
Write-Host "  7. Todos os dados acumulados foram preservados" -ForegroundColor White
Write-Host ""
Write-Host "  Volume: $VOLUME_NAME" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Para limpar: .\docker_cleanup.ps1" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
