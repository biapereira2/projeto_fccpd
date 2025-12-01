# Desafio 5 — Microsserviços com API Gateway

## 📋 Objetivo

Criar uma arquitetura de microsserviços com um **API Gateway** centralizando o acesso a dois serviços independentes: um de **usuários** e outro de **pedidos**.

---

## 🏗️ Arquitetura

A arquitetura do sistema segue o padrão de **API Gateway**, onde todas as requisições externas passam por um ponto único de entrada antes de serem direcionadas aos microsserviços internos.

O **API Gateway** é o componente central da arquitetura, exposto na porta 5000. Ele recebe todas as requisições dos clientes e atua como intermediário, roteando as chamadas para os serviços apropriados. O gateway é responsável por orquestrar a comunicação, agregar dados de múltiplos serviços quando necessário, e fornecer informações sobre a saúde de todo o sistema.

O **Users Service** (porta 5001) é o microsserviço responsável por fornecer dados de usuários. Ele opera de forma independente e responde apenas às requisições relacionadas a usuários, como listagem e busca por ID.

O **Orders Service** (porta 5002) é o microsserviço responsável por fornecer dados de pedidos. Assim como o serviço de usuários, ele funciona de maneira autônoma e gerencia todas as operações relacionadas a pedidos, incluindo busca por usuário.

Todos os três serviços estão conectados através de uma **rede Docker** isolada chamada `microservices-network`. Essa rede permite que os containers se comuniquem entre si usando seus nomes como endereços DNS, enquanto mantém o isolamento do ambiente externo. Apenas o API Gateway precisa ser acessível externamente, garantindo que os microsserviços internos fiquem protegidos.

### Componentes

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| **API Gateway** | 5000 | Ponto único de entrada, organizada chamadas aos microsserviços |
| **Users Service** | 5001 | Microsserviço que fornece dados de usuários |
| **Orders Service** | 5002 | Microsserviço que fornece dados de pedidos |

---

## 📁 Estrutura de Arquivos

```
desafio5/
├── docker-compose.yml          # Orquestração dos serviços
├── docker_setup.ps1            # Script de setup (Windows)
├── docker_setup.sh             # Script de setup (Linux/Mac)
├── docker_cleanup.ps1          # Script de limpeza (Windows)
├── docker_cleanup.sh           # Script de limpeza (Linux/Mac)
├── README.md                   # Documentação
├── gateway/                    # API Gateway
│   ├── app.py                  # Código do gateway
│   ├── Dockerfile              # Imagem Docker
│   └── requirements.txt        # Dependências
├── users_service/              # Microsserviço de Usuários
│   ├── app.py                  # Código do serviço
│   ├── Dockerfile              # Imagem Docker
│   └── requirements.txt        # Dependências
└── orders_service/             # Microsserviço de Pedidos
    ├── app.py                  # Código do serviço
    ├── Dockerfile              # Imagem Docker
    └── requirements.txt        # Dependências
```

---

## 🚀 Como Executar

### Pré-requisitos

- Docker instalado e em execução
- Docker Compose instalado

### Iniciar os Serviços

**Windows (PowerShell):**
```powershell
cd desafio5
.\docker_setup.ps1
```

**Linux/Mac:**
```bash
cd desafio5
chmod +x docker_setup.sh
./docker_setup.sh
```

**Ou manualmente:**
```bash
cd desafio5
docker-compose up --build -d
```

### Parar e Limpar

**Windows (PowerShell):**
```powershell
.\docker_cleanup.ps1
```

**Linux/Mac:**
```bash
./docker_cleanup.sh
```

**Ou manualmente:**
```bash
docker-compose down
```

---

## 🔌 Endpoints da API

### API Gateway (porta 5000) - Ponto único de entrada

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/` | Informações da API e lista de endpoints |
| GET | `/health` | Status de saúde do gateway e serviços |
| GET | `/users` | Lista todos os usuários |
| GET | `/users/{id}` | Busca usuário por ID |
| GET | `/orders` | Lista todos os pedidos |
| GET | `/orders/{id}` | Busca pedido por ID |
| GET | `/orders/user/{user_id}` | Busca pedidos de um usuário |
| GET | `/users/{id}/orders` | **Agregação:** usuário com seus pedidos |

### Microsserviço de Usuários (porta 5001)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Status de saúde do serviço |
| GET | `/users` | Lista todos os usuários |
| GET | `/users/{id}` | Busca usuário por ID |

### Microsserviço de Pedidos (porta 5002)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Status de saúde do serviço |
| GET | `/orders` | Lista todos os pedidos |
| GET | `/orders/{id}` | Busca pedido por ID |
| GET | `/orders/user/{user_id}` | Busca pedidos de um usuário |

---

## 🧪 Testes

### Teste 1: Verificar informações da API Gateway

```bash
curl http://localhost:5000/
```

**Resposta esperada:**
```json
{
  "service": "api-gateway",
  "version": "1.0.0",
  "description": "API Gateway - Ponto único de entrada para os microsserviços",
  "endpoints": {
    "/": "Informações da API",
    "/health": "Status de saúde do gateway e serviços",
    "/users": "Lista todos os usuários (proxy para users-service)",
    ...
  }
}
```

### Teste 2: Verificar saúde dos serviços

```bash
curl http://localhost:5000/health
```

**Resposta esperada:**
```json
{
  "service": "api-gateway",
  "status": "healthy",
  "services": {
    "gateway": "healthy",
    "users-service": "healthy",
    "orders-service": "healthy"
  }
}
```

### Teste 3: Listar usuários via Gateway

```bash
curl http://localhost:5000/users
```

**Resposta esperada:**
```json
{
  "service": "users-service",
  "data": [
    {"id": 1, "name": "Maria Silva", "email": "maria.silva@email.com", "role": "admin"},
    {"id": 2, "name": "João Santos", "email": "joao.santos@email.com", "role": "user"},
    ...
  ],
  "total": 5
}
```

### Teste 4: Buscar usuário específico

```bash
curl http://localhost:5000/users/1
```

**Resposta esperada:**
```json
{
  "service": "users-service",
  "data": {
    "id": 1,
    "name": "Maria Silva",
    "email": "maria.silva@email.com",
    "role": "admin"
  }
}
```

### Teste 5: Listar pedidos via Gateway

```bash
curl http://localhost:5000/orders
```

**Resposta esperada:**
```json
{
  "service": "orders-service",
  "data": [
    {"id": 1, "user_id": 1, "product": "Notebook Dell XPS", "quantity": 1, "price": 8500.0, "status": "entregue"},
    {"id": 2, "user_id": 2, "product": "Mouse Logitech MX Master", "quantity": 2, "price": 450.0, "status": "em trânsito"},
    ...
  ],
  "total": 5
}
```

### Teste 6: Buscar pedido específico

```bash
curl http://localhost:5000/orders/1
```

**Resposta esperada:**
```json
{
  "service": "orders-service",
  "data": {
    "id": 1,
    "user_id": 1,
    "product": "Notebook Dell XPS",
    "quantity": 1,
    "price": 8500.0,
    "status": "entregue"
  }
}
```

### Teste 7: Pedidos de um usuário

```bash
curl http://localhost:5000/orders/user/1
```

**Resposta esperada:**
```json
{
  "service": "orders-service",
  "user_id": 1,
  "data": [
    {"id": 1, "user_id": 1, "product": "Notebook Dell XPS", ...},
    {"id": 3, "user_id": 1, "product": "Teclado Mecânico", ...}
  ],
  "total": 2
}
```

### Teste 8: Agregação - Usuário com seus pedidos

```bash
curl http://localhost:5000/users/1/orders
```

**Resposta esperada:**
```json
{
  "service": "api-gateway",
  "aggregation": "user-with-orders",
  "data": {
    "user": {
      "id": 1,
      "name": "Maria Silva",
      "email": "maria.silva@email.com",
      "role": "admin"
    },
    "orders": [
      {"id": 1, "user_id": 1, "product": "Notebook Dell XPS", ...},
      {"id": 3, "user_id": 1, "product": "Teclado Mecânico", ...}
    ],
    "total_orders": 2
  }
}
```

### Teste com PowerShell (Windows)

```powershell
# Usando Invoke-RestMethod
Invoke-RestMethod -Uri http://localhost:5000/users | ConvertTo-Json -Depth 10

# Ou usando curl
curl.exe http://localhost:5000/health
```

---

## 🔧 Verificar Status dos Containers

```bash
docker-compose ps
```

**Saída esperada:**
```
NAME             IMAGE                      STATUS          PORTS
api-gateway      desafio5-api-gateway       Up (healthy)    0.0.0.0:5000->5000/tcp
orders-service   desafio5-orders-service    Up (healthy)    0.0.0.0:5002->5002/tcp
users-service    desafio5-users-service     Up (healthy)    0.0.0.0:5001->5001/tcp
```

### Ver logs dos serviços

```bash
# Todos os serviços
docker-compose logs

# Serviço específico
docker-compose logs api-gateway
docker-compose logs users-service
docker-compose logs orders-service

# Acompanhar logs em tempo real
docker-compose logs -f
```

---

## 💡 Conceitos Demonstrados

### 1. API Gateway como Ponto Único de Entrada
- Todas as requisições externas passam pelo gateway
- Clientes não precisam conhecer os serviços internos
- Simplifica a comunicação e segurança

### 2. Orquestração de Microsserviços
- Gateway faz proxy das requisições para os serviços corretos
- Endpoint de agregação (`/users/{id}/orders`) combina dados de múltiplos serviços
- Tratamento de erros quando serviços estão indisponíveis

### 3. Comunicação via Rede Docker
- Serviços se comunicam usando nomes de containers
- Rede isolada (`microservices-network`)
- Resolução DNS automática do Docker

### 4. Health Checks
- Cada serviço expõe endpoint `/health`
- Gateway verifica status de todos os serviços
- Docker monitora saúde dos containers

---

## 🛠️ Tecnologias Utilizadas

- **Python 3.11** - Linguagem de programação
- **Flask 3.0** - Framework web
- **Requests** - Biblioteca HTTP (no gateway)
- **Docker** - Containerização
- **Docker Compose** - Orquestração de containers

---

## 📝 Notas Adicionais

- Os serviços usam dados simulados em memória (sem banco de dados)
- O gateway implementa timeout de 10 segundos para requisições
- Em caso de falha de um serviço, o gateway retorna erro 503
- Todos os containers reiniciam automaticamente (`restart: unless-stopped`)
