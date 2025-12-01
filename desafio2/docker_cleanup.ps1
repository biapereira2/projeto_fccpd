Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  DESAFIO 2 - LIMPEZA DE RECURSOS" -ForegroundColor Cyan
"============================================================" -ForegroundColor Cyan
Write-Host ""

$VOLUME_NAME = "desafio2-sqlite-data"
$IMAGE_WRITER = "desafio2-writer"
$IMAGE_READER = "desafio2-reader"
$CONTAINER_WRITER = "sqlite-writer"
$CONTAINER_READER = "sqlite-reader"

Write-Host "[PASSO 1] Removendo containers..." -ForegroundColor Yellow

$writerExists = docker ps -a --filter "name=$CONTAINER_WRITER" --format "{{.Names}}"
if ($writerExists) {
    docker stop $CONTAINER_WRITER 2>$null
    docker rm $CONTAINER_WRITER 2>$null
    Write-Host "[OK] Container '$CONTAINER_WRITER' removido" -ForegroundColor Green
} else {
    Write-Host "[INFO] Container '$CONTAINER_WRITER' nao existe" -ForegroundColor Gray
}

$readerExists = docker ps -a --filter "name=$CONTAINER_READER" --format "{{.Names}}"
if ($readerExists) {
    docker stop $CONTAINER_READER 2>$null
    docker rm $CONTAINER_READER 2>$null
    Write-Host "[OK] Container '$CONTAINER_READER' removido" -ForegroundColor Green
} else {
    Write-Host "[INFO] Container '$CONTAINER_READER' nao existe" -ForegroundColor Gray
}
Write-Host ""
Write-Host "[PASSO 2] Removendo imagens Docker..." -ForegroundColor Yellow

$writerImage = docker images -q $IMAGE_WRITER
if ($writerImage) {
    docker rmi $IMAGE_WRITER
    Write-Host "[OK] Imagem '$IMAGE_WRITER' removida" -ForegroundColor Green
} else {
    Write-Host "[INFO] Imagem '$IMAGE_WRITER' nao existe" -ForegroundColor Gray
}

$readerImage = docker images -q $IMAGE_READER
if ($readerImage) {
    docker rmi $IMAGE_READER
    Write-Host "[OK] Imagem '$IMAGE_READER' removida" -ForegroundColor Green
} else {
    Write-Host "[INFO] Imagem '$IMAGE_READER' nao existe" -ForegroundColor Gray
}
Write-Host ""

Write-Host "[PASSO 3] Removendo volume Docker..." -ForegroundColor Yellow

$volumeExists = docker volume ls --filter "name=$VOLUME_NAME" --format "{{.Name}}"
if ($volumeExists -eq $VOLUME_NAME) {
    docker volume rm $VOLUME_NAME
    Write-Host "[OK] Volume '$VOLUME_NAME' removido" -ForegroundColor Green
    Write-Host "[NOTA] Os dados do SQLite foram removidos junto com o volume!" -ForegroundColor Yellow
} else {
    Write-Host "[INFO] Volume '$VOLUME_NAME' nao existe" -ForegroundColor Gray
}
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  LIMPEZA CONCLUIDA!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Recursos removidos:" -ForegroundColor White
Write-Host "  - Containers: $CONTAINER_WRITER, $CONTAINER_READER" -ForegroundColor White
Write-Host "  - Imagens: $IMAGE_WRITER, $IMAGE_READER" -ForegroundColor White
Write-Host "  - Volume: $VOLUME_NAME" -ForegroundColor White
Write-Host ""
Write-Host "  Para executar novamente: .\docker_setup.ps1" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
