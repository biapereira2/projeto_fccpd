# Script de Cleanup - Desafio 4: Microsserviços Independentes
# PowerShell Script para Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cleanup - Desafio 4" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Parar e remover containers
Write-Host "[1/3] Parando e removendo containers..." -ForegroundColor Yellow

Write-Host "      Removendo container service_b..." -ForegroundColor Cyan
docker stop service_b 2>$null
docker rm service_b 2>$null

Write-Host "      Removendo container service_a..." -ForegroundColor Cyan
docker stop service_a 2>$null
docker rm service_a 2>$null

Write-Host "      Containers removidos!" -ForegroundColor Green
Write-Host ""

# Remover imagens
Write-Host "[2/3] Removendo imagens Docker..." -ForegroundColor Yellow
docker rmi service_a:latest 2>$null
docker rmi service_b:latest 2>$null
Write-Host "      Imagens removidas!" -ForegroundColor Green
Write-Host ""

# Remover rede
Write-Host "[3/3] Removendo rede Docker..." -ForegroundColor Yellow
docker network rm microservices_net 2>$null
Write-Host "      Rede removida!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Cleanup concluido com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
