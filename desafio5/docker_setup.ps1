# Script de Setup - Docker Compose (PowerShell)
# Desafio 5: Microsserviços com API Gateway

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Desafio 5 - Microsservicos com API Gateway" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Navegar para o diretório do desafio
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "[1/3] Construindo as imagens Docker..." -ForegroundColor Yellow
docker-compose build --no-cache

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao construir as imagens!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] Iniciando os containers..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao iniciar os containers!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[3/3] Aguardando os serviços iniciarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Setup concluido com sucesso!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Containers em execução:" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "Endpoints disponiveis:" -ForegroundColor Cyan
Write-Host "  API Gateway:     http://localhost:5000" -ForegroundColor White
Write-Host "  Users Service:   http://localhost:5001" -ForegroundColor White
Write-Host "  Orders Service:  http://localhost:5002" -ForegroundColor White
Write-Host ""
Write-Host "Testes rapidos (via Gateway):" -ForegroundColor Cyan
Write-Host "  curl http://localhost:5000/" -ForegroundColor Gray
Write-Host "  curl http://localhost:5000/health" -ForegroundColor Gray
Write-Host "  curl http://localhost:5000/users" -ForegroundColor Gray
Write-Host "  curl http://localhost:5000/orders" -ForegroundColor Gray
Write-Host "  curl http://localhost:5000/users/1/orders" -ForegroundColor Gray
Write-Host ""
