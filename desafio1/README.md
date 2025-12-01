# Desafio 1 — Containers em Rede

## Objetivo
Criar dois containers Docker que se comunicam através de uma rede customizada.

## Arquitetura

A arquitetura deste desafio consiste em dois containers Docker que se comunicam através de uma rede customizada chamada `desafio1-net`.

O **Server** é um container que executa uma aplicação Flask, expondo a porta 8080. Ele atua como um servidor web que responde requisições HTTP com mensagens JSON contendo informações sobre a requisição recebida, incluindo o IP do cliente e o timestamp.

O **Client** é um container baseado em Alpine Linux que executa um script de loop infinito usando curl. A cada 5 segundos, ele faz uma requisição HTTP para o servidor, demonstrando a comunicação entre containers na mesma rede Docker.

A **rede Docker** (`desafio1-net`) é do tipo bridge e permite que os containers se comuniquem usando seus nomes como endereços DNS. O servidor também tem sua porta 8080 exposta para a máquina host, permitindo acesso externo à aplicação.

## Estrutura do Projeto

```
desafio1/
├── README.md              # Este arquivo
├── docker_setup.sh        # Script de execução (Linux/Mac)
├── docker_setup.ps1       # Script de execução (Windows PowerShell)
├── docker_cleanup.ps1     # Script de limpeza (Windows PowerShell)
├── docker_cleanup.sh      # Script de limpeza (Linux/Mac)
├── server/
│   ├── Dockerfile         # Imagem do servidor Flask
│   ├── app.py             # Aplicação Flask
│   └── requirements.txt   # Dependências
└── client/
    ├── Dockerfile         # Imagem do cliente
    └── loop.sh            # Script de requisições periódicas
```

## Componentes

### 1. Servidor (Flask)
- **Imagem base**: `python:3.12-slim`
- **Porta**: 8080
- **Função**: Servidor web que responde requisições HTTP com uma mensagem JSON contendo:
  - Mensagem de boas-vindas
  - IP do cliente que fez a requisição
  - Timestamp da requisição

### 2. Cliente (curl)
- **Imagem base**: `alpine:3.18`
- **Função**: Realiza requisições HTTP periódicas (a cada 5 segundos) para o servidor
- **Ferramenta**: `curl` em loop infinito

### 3. Rede Docker
- **Nome**: `desafio1-net`
- **Tipo**: Bridge (padrão)
- **Função**: Permite comunicação entre containers pelo nome do container (DNS interno do Docker)

## Como Executar

### Windows (PowerShell)

```powershell
# Navegar até a pasta do projeto
cd \Projeto2_DesafioDocker\desafio1

# Executar o setup
.\docker_setup.ps1
```

### Linux/Mac (Bash)

```bash
# Navegar até a pasta do projeto
cd desafio1

# Dar permissão de execução
chmod +x docker_setup.sh

# Executar o setup
./docker_setup.sh
```

## Verificar a Comunicação

### Ver logs do servidor (requisições recebidas)
```powershell
docker logs -f server
```

### Ver logs do cliente (respostas recebidas)
```powershell
docker logs -f client
```

### Ver ambos os logs simultaneamente
```powershell
# Em terminais separados, execute:
# Terminal 1:
docker logs -f server

# Terminal 2:
docker logs -f client
```

## Exemplo de Saída

### Logs do Cliente
```
--- Sun Nov 30 12:00:00 UTC 2025 ---
{"client_ip":"172.18.0.3","msg":"Hello from server","timestamp":"2025-11-30T12:00:00"}
--- Sun Nov 30 12:00:05 UTC 2025 ---
{"client_ip":"172.18.0.3","msg":"Hello from server","timestamp":"2025-11-30T12:00:05"}
```

### Logs do Servidor
```
 * Running on http://0.0.0.0:8080
172.18.0.3 - - [30/Nov/2025 12:00:00] "GET / HTTP/1.1" 200 -
172.18.0.3 - - [30/Nov/2025 12:00:05] "GET / HTTP/1.1" 200 -
```

## Como Parar e Limpar

### Windows (PowerShell)
```powershell
.\docker_cleanup.ps1
```

### Linux/Mac (Bash)
```bash
./docker_cleanup.sh
```

### Manualmente
```bash
# Parar e remover containers
docker rm -f server client

# Remover a rede
docker network rm desafio1-net

# (Opcional) Remover imagens
docker rmi desafio1-server desafio1-client
```

## Verificar Configuração da Rede

```bash
# Listar redes Docker
docker network ls

# Inspecionar a rede criada
docker network inspect desafio1-net

# Verificar containers conectados
docker network inspect desafio1-net --format '{{range .Containers}}{{.Name}} {{end}}'
```

## Testar Comunicação Manualmente

```bash
# Acessar o servidor via host (porta exposta)
curl http://localhost:8080

# Entrar no container client e testar
docker exec -it client sh
curl http://server:8080/
```

## Explicação Técnica

### Por que usar uma rede Docker customizada?
1. **Isolamento**: Containers na mesma rede customizada podem se comunicar, mas ficam isolados de outros containers
2. **DNS automático**: O Docker fornece resolução de nomes automática - o container `client` pode acessar o `server` pelo nome
3. **Segurança**: Sem necessidade de expor portas entre containers

### Como funciona a comunicação?
1. O Docker cria uma rede bridge chamada `desafio1-net`
2. Ambos containers são conectados a esta rede
3. O Docker configura DNS interno para resolver `server` → IP do container server
4. O client usa `curl http://server:8080/` para acessar o servidor
5. A resposta é recebida e exibida nos logs

## Requisitos Atendidos

| Requisito | Status | Descrição |
|-----------|--------|-----------|
| Servidor web na porta 8080 | ✅ | Flask rodando em `0.0.0.0:8080` |
| Cliente com requisições periódicas | ✅ | curl em loop a cada 5 segundos |
| Rede Docker nomeada | ✅ | `desafio1-net` (bridge) |
| Comunicação funcional | ✅ | Cliente acessa servidor pelo nome |
| Logs da comunicação | ✅ | Visíveis via `docker logs` |
