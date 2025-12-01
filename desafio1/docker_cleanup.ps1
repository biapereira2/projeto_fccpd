# Script de Limpeza - Desafio 1: Containers em Rede
# Execute: .\docker_cleanup.ps1

$NET_NAME = "desafio1-net"
$SERVER_NAME = "server"
$CLIENT_NAME = "client"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Limpeza - Desafio 1" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Parar e remover containers
Write-Host "[1/3] Parando e removendo containers..." -ForegroundColor Yellow
docker rm -f $SERVER_NAME 2>$null
docker rm -f $CLIENT_NAME 2>$null
Write-Host "      Containers removidos!" -ForegroundColor Green

# Remover rede
Write-Host "[2/3] Removendo rede Docker..." -ForegroundColor Yellow
docker network rm $NET_NAME 2>$null
Write-Host "      Rede removida!" -ForegroundColor Green

# Perguntar se deseja remover imagens
Write-Host ""
$removeImages = Read-Host "Deseja remover as imagens tambem? (s/N)"
if ($removeImages -eq "s" -or $removeImages -eq "S") {
    Write-Host "[3/3] Removendo imagens..." -ForegroundColor Yellow
    docker rmi desafio1-server 2>$null
    docker rmi desafio1-client 2>$null
    Write-Host "      Imagens removidas!" -ForegroundColor Green
} else {
    Write-Host "[3/3] Imagens mantidas." -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Limpeza concluida!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
