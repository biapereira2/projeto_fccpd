# Script de Setup - Desafio 4: Microsserviços Independentes
# PowerShell Script para Windows

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Desafio 4 - Microsservicos Independentes" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Criar rede Docker para comunicação entre os microsserviços
Write-Host "[1/4] Criando rede Docker 'microservices_net'..." -ForegroundColor Yellow
docker network create microservices_net 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Rede criada com sucesso!" -ForegroundColor Green
} else {
    Write-Host "      Rede ja existe ou erro ao criar (continuando...)" -ForegroundColor Yellow
}
Write-Host ""

# Build da imagem do Microsserviço A
Write-Host "[2/4] Construindo imagem do Microsservico A (Users API)..." -ForegroundColor Yellow
docker build -t service_a:latest ./service_a
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Erro ao construir Microsservico A!" -ForegroundColor Red
    exit 1
}
Write-Host "      Imagem service_a construida com sucesso!" -ForegroundColor Green
Write-Host ""

# Build da imagem do Microsserviço B
Write-Host "[3/4] Construindo imagem do Microsservico B (Consumer)..." -ForegroundColor Yellow
docker build -t service_b:latest ./service_b
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Erro ao construir Microsservico B!" -ForegroundColor Red
    exit 1
}
Write-Host "      Imagem service_b construida com sucesso!" -ForegroundColor Green
Write-Host ""

# Executar os containers
Write-Host "[4/4] Iniciando containers..." -ForegroundColor Yellow

# Iniciar Microsserviço A
Write-Host "      Iniciando Microsservico A na porta 5050..." -ForegroundColor Cyan
docker run -d `
    --name service_a `
    --network microservices_net `
    -p 5050:5050 `
    service_a:latest

if ($LASTEXITCODE -ne 0) {
    Write-Host "      Erro ao iniciar Microsservico A!" -ForegroundColor Red
    exit 1
}

# Aguardar um pouco para o serviço A iniciar
Start-Sleep -Seconds 2

# Iniciar Microsserviço B
Write-Host "      Iniciando Microsservico B na porta 5051..." -ForegroundColor Cyan
docker run -d `
    --name service_b `
    --network microservices_net `
    -p 5051:5051 `
    -e SERVICE_A_URL=http://service_a:5050 `
    service_b:latest

if ($LASTEXITCODE -ne 0) {
    Write-Host "      Erro ao iniciar Microsservico B!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup concluido com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Endpoints disponiveis:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Microsservico A (Users API):" -ForegroundColor Yellow
Write-Host "    - Health Check:    http://localhost:5050/health"
Write-Host "    - Lista usuarios:  http://localhost:5050/users"
Write-Host "    - Usuario por ID:  http://localhost:5050/users/{id}"
Write-Host "    - Usuarios ativos: http://localhost:5050/users/active"
Write-Host ""
Write-Host "  Microsservico B (Consumer):" -ForegroundColor Yellow
Write-Host "    - Health Check:    http://localhost:5051/health"
Write-Host "    - Dashboard HTML:  http://localhost:5051/"
Write-Host "    - API combinada:   http://localhost:5051/api/users-info"
Write-Host "    - Usuario por ID:  http://localhost:5051/api/user/{id}"
Write-Host ""
Write-Host "Para verificar os containers:" -ForegroundColor Cyan
Write-Host "  docker ps"
Write-Host ""
Write-Host "Para ver os logs:" -ForegroundColor Cyan
Write-Host "  docker logs service_a"
Write-Host "  docker logs service_b"
Write-Host ""
