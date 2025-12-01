# Script de Cleanup - Docker Compose (PowerShell)
# Desafio 5: Microsserviços com API Gateway

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Desafio 5 - Limpeza do Ambiente" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Navegar para o diretório do desafio
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "[1/3] Parando os containers..." -ForegroundColor Yellow
docker-compose down

Write-Host ""
Write-Host "[2/3] Removendo imagens criadas..." -ForegroundColor Yellow
docker rmi desafio5-api-gateway desafio5-users-service desafio5-orders-service 2>$null

Write-Host ""
Write-Host "[3/3] Removendo rede (se existir)..." -ForegroundColor Yellow
docker network rm desafio5-network 2>$null

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Limpeza concluida com sucesso!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Containers restantes:" -ForegroundColor Cyan
docker ps -a --filter "name=users-service" --filter "name=orders-service" --filter "name=api-gateway"
Write-Host ""
