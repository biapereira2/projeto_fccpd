$NET_NAME = "desafio1-net"
$SERVER_NAME = "server"
$CLIENT_NAME = "client"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Desafio 1 - Containers em Rede" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/5] Limpando containers anteriores..." -ForegroundColor Yellow
docker rm -f $SERVER_NAME 2>$null
docker rm -f $CLIENT_NAME 2>$null

Write-Host "[2/5] Criando rede Docker: $NET_NAME" -ForegroundColor Yellow
docker network create $NET_NAME 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Rede criada com sucesso!" -ForegroundColor Green
} else {
    Write-Host "      Rede ja existe, reutilizando..." -ForegroundColor Gray
}

Write-Host "[3/5] Construindo imagem do servidor..." -ForegroundColor Yellow
docker build -t desafio1-server ./server
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao construir imagem do servidor!" -ForegroundColor Red
    exit 1
}
Write-Host "      Imagem do servidor criada!" -ForegroundColor Green

Write-Host "[4/5] Construindo imagem do cliente..." -ForegroundColor Yellow
docker build -t desafio1-client ./client
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao construir imagem do cliente!" -ForegroundColor Red
    exit 1
}
Write-Host "      Imagem do cliente criada!" -ForegroundColor Green

Write-Host "[5/5] Iniciando containers..." -ForegroundColor Yellow

docker run -d --name $SERVER_NAME --network $NET_NAME -p 8080:8080 desafio1-server
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Servidor iniciado na porta 8080" -ForegroundColor Green
} else {
    Write-Host "ERRO: Falha ao iniciar servidor!" -ForegroundColor Red
    exit 1
}

docker run -d --name $CLIENT_NAME --network $NET_NAME desafio1-client
if ($LASTEXITCODE -eq 0) {
    Write-Host "      Cliente iniciado" -ForegroundColor Green
} else {
    Write-Host "ERRO: Falha ao iniciar cliente!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup concluido com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Containers em execucao:" -ForegroundColor Cyan
docker ps --filter "network=$NET_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Host ""
Write-Host "Rede Docker:" -ForegroundColor Cyan
docker network inspect $NET_NAME --format "Nome: {{.Name}} | Driver: {{.Driver}} | Containers: {{range .Containers}}{{.Name}} {{end}}"

Write-Host ""
Write-Host "Comandos uteis:" -ForegroundColor Magenta
Write-Host "  Ver logs do servidor:  docker logs -f server" -ForegroundColor White
Write-Host "  Ver logs do cliente:   docker logs -f client" -ForegroundColor White
Write-Host "  Testar servidor:       curl http://localhost:8080" -ForegroundColor White
Write-Host "  Parar tudo:            .\docker_cleanup.ps1" -ForegroundColor White
Write-Host ""

Write-Host "Aguardando containers iniciarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Logs do Cliente (ultimas mensagens)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
docker logs client

Write-Host ""
Write-Host "Para ver os logs em tempo real, execute:" -ForegroundColor Yellow
Write-Host "  docker logs -f client" -ForegroundColor White
