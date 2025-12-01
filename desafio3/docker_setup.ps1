Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Desafio 3 - Docker Compose Setup" -ForegroundColor Cyan
Write-Host "  Servicos: Web + PostgreSQL + Redis" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "[1/4] Verificando Docker..." -ForegroundColor Yellow
$dockerRunning = docker info 2>$null
if (-not $?) {
    Write-Host "ERRO: Docker nao esta rodando. Inicie o Docker Desktop." -ForegroundColor Red
    exit 1
}
Write-Host "Docker esta funcionando!" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] Parando containers existentes (se houver)..." -ForegroundColor Yellow
docker compose down 2>$null
Write-Host ""

Write-Host "[3/4] Construindo imagens..." -ForegroundColor Yellow
docker compose build --no-cache
if (-not $?) {
    Write-Host "ERRO: Falha ao construir imagens." -ForegroundColor Red
    exit 1
}
Write-Host "Imagens construidas com sucesso!" -ForegroundColor Green
Write-Host ""

Write-Host "[4/4] Iniciando servicos..." -ForegroundColor Yellow
docker compose up -d
if (-not $?) {
    Write-Host "ERRO: Falha ao iniciar servicos." -ForegroundColor Red
    exit 1
}
Write-Host ""
Write-Host "Aguardando servicos ficarem prontos..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  Servicos iniciados com sucesso!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Status dos containers:" -ForegroundColor Cyan
docker compose ps
Write-Host ""
Write-Host "Endpoints disponiveis:" -ForegroundColor Cyan
Write-Host "  - Web App:     http://localhost:5000" -ForegroundColor White
Write-Host "  - Health:      http://localhost:5000/health" -ForegroundColor White
Write-Host "  - Visita:      http://localhost:5000/visit" -ForegroundColor White
Write-Host "  - Estatisticas: http://localhost:5000/stats" -ForegroundColor White
Write-Host ""
Write-Host "Para ver logs: docker compose logs -f" -ForegroundColor Yellow
Write-Host "Para parar:    .\docker_cleanup.ps1" -ForegroundColor Yellow
Write-Host ""
