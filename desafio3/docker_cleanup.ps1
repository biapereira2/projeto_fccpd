Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Desafio 3 - Docker Compose Cleanup" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "[1/3] Parando e removendo containers..." -ForegroundColor Yellow
docker compose down
Write-Host ""

$removeVolumes = Read-Host "Deseja remover os volumes de dados? (s/N)"
if ($removeVolumes -eq "s" -or $removeVolumes -eq "S") {
    Write-Host "[2/3] Removendo volumes..." -ForegroundColor Yellow
    docker compose down -v
    docker volume rm desafio3_postgres_data 2>$null
    docker volume rm desafio3_redis_data 2>$null
    Write-Host "Volumes removidos!" -ForegroundColor Green
} else {
    Write-Host "[2/3] Volumes mantidos." -ForegroundColor Yellow
}
Write-Host ""

$removeImages = Read-Host "Deseja remover as imagens construidas? (s/N)"
if ($removeImages -eq "s" -or $removeImages -eq "S") {
    Write-Host "[3/3] Removendo imagens..." -ForegroundColor Yellow
    docker compose down --rmi local
    Write-Host "Imagens removidas!" -ForegroundColor Green
} else {
    Write-Host "[3/3] Imagens mantidas." -ForegroundColor Yellow
}
Write-Host ""

docker network rm desafio3_network 2>$null

Write-Host "============================================" -ForegroundColor Green
Write-Host "  Cleanup concluido!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
