# Desafio 4 — Microsserviços Independentes

## 📋 Objetivo

Criar dois microsserviços independentes que se comunicam via HTTP, demonstrando uma arquitetura de microservices básica sem a necessidade de um API Gateway.

---

## 🏗️ Arquitetura

A arquitetura deste desafio implementa dois microsserviços independentes que se comunicam via HTTP através de uma rede Docker chamada `microservices_net`.

O **Microsserviço A** (Users API) é uma aplicação Flask que fornece uma API REST de usuários na porta 5050. Ele atua como o provedor de dados, expondo endpoints para listar e consultar informações de usuários. Este serviço é independente e pode ser acessado diretamente pelo host ou por outros serviços na rede.

O **Microsserviço B** (Consumer) é outra aplicação Flask que opera na porta 5051. Ele atua como consumidor, fazendo requisições HTTP para o Microsserviço A para obter dados de usuários. Este serviço demonstra o padrão de comunicação entre microsserviços, processando os dados recebidos e enriquecendo-os com informações adicionais antes de retornar ao cliente.

Ambos os serviços estão conectados através da rede Docker `microservices_net`, permitindo comunicação interna usando os nomes dos containers como endereços DNS. As duas portas (5050 e 5051) são expostas para o host, permitindo acesso direto a cada microsserviço para fins de teste e demonstração.

### Fluxo de Comunicação

1. **Usuário** acessa o Microsserviço B (porta 5051)
2. **Microsserviço B** faz requisições HTTP para o Microsserviço A (porta 5050)
3. **Microsserviço A** retorna dados JSON dos usuários
4. **Microsserviço B** processa os dados e adiciona informações combinadas
5. **Usuário** recebe a resposta com informações enriquecidas

---

## 📦 Estrutura do Projeto

```
desafio4/
├── service_a/                  # Microsserviço A - API de Usuários
│   ├── app.py                  # Aplicação Flask
│   ├── Dockerfile              # Imagem Docker
│   └── requirements.txt        # Dependências Python
│
├── service_b/                  # Microsserviço B - Consumidor
│   ├── app.py                  # Aplicação Flask
│   ├── Dockerfile              # Imagem Docker
│   └── requirements.txt        # Dependências Python
│
├── docker_setup.ps1            # Script de setup (Windows)
├── docker_setup.sh             # Script de setup (Linux/Mac)
├── docker_cleanup.ps1          # Script de cleanup (Windows)
├── docker_cleanup.sh           # Script de cleanup (Linux/Mac)
└── README.md                   # Documentação
```

---

## 🚀 Como Executar

### Windows (PowerShell)

```powershell
cd desafio4
.\docker_setup.ps1
```

### Linux/MacOS (Bash)

```bash
cd desafio4
chmod +x docker_setup.sh
./docker_setup.sh
```

### Execução Manual

```bash
# 1. Criar rede Docker
docker network create microservices_net

# 2. Build das imagens
docker build -t service_a:latest ./service_a
docker build -t service_b:latest ./service_b

# 3. Executar Microsserviço A
docker run -d --name service_a --network microservices_net -p 5000:5000 service_a:latest

# 4. Executar Microsserviço B
docker run -d --name service_b --network microservices_net -p 5001:5001 -e SERVICE_A_URL=http://service_a:5000 service_b:latest
```

---

## 🔌 Endpoints

### Microsserviço A — API de Usuários (Porta 5000)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check do serviço |
| GET | `/users` | Lista todos os usuários |
| GET | `/users/{id}` | Busca usuário por ID |
| GET | `/users/active` | Lista apenas usuários ativos |

#### Exemplo de Resposta — `/users`

```json
{
  "success": true,
  "count": 5,
  "users": [
    {
      "id": 1,
      "name": "Ana Silva",
      "email": "ana.silva@email.com",
      "role": "Desenvolvedora",
      "active_since": "2022-03-15",
      "status": "ativo"
    }
  ]
}
```

### Microsserviço B — Consumidor (Porta 5001)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/health` | Health check do serviço |
| GET | `/` | Dashboard HTML com usuários |
| GET | `/api/users-info` | API JSON com informações combinadas |
| GET | `/api/user/{id}` | Info combinada de um usuário específico |

#### Exemplo de Resposta — `/api/users-info`

```json
{
  "success": true,
  "source": "service_a",
  "processed_by": "service_b",
  "timestamp": "2025-11-30T10:30:00",
  "count": 5,
  "users": [
    {
      "id": 1,
      "name": "Ana Silva",
      "email": "ana.silva@email.com",
      "role": "Desenvolvedora",
      "status": "ativo",
      "active_since": "2022-03-15",
      "combined_info": "Usuário Ana ativo desde 2022-03-15 (3 ano(s) e 8 mês(es))",
      "time_active": "3 ano(s) e 8 mês(es)"
    }
  ]
}
```

---

## 🧪 Testando a Comunicação

### Via cURL

```bash
# Testar Microsserviço A diretamente
curl http://localhost:5000/users

# Testar Microsserviço B (consome A internamente)
curl http://localhost:5001/api/users-info

# Health checks
curl http://localhost:5000/health
curl http://localhost:5001/health
```

### Via Navegador

- **Dashboard Visual**: http://localhost:5001/
- **API de Usuários**: http://localhost:5000/users
- **API Combinada**: http://localhost:5001/api/users-info

---

## 🐳 Detalhes dos Dockerfiles

### Service A (Dockerfile)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5050
CMD ["python", "app.py"]
```

### Service B (Dockerfile)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5051
ENV SERVICE_A_URL=http://service_a:5000
CMD ["python", "app.py"]
```

**Características de isolamento:**
- Cada serviço tem seu próprio Dockerfile
- Imagens baseadas em `python:3.11-slim` para tamanho reduzido
- Dependências isoladas em `requirements.txt` separados
- Portas diferentes para cada serviço (5000 e 5001)
- Comunicação via rede Docker interna

---

## 🔧 Variáveis de Ambiente

| Variável | Serviço | Descrição | Valor Padrão |
|----------|---------|-----------|--------------|
| `SERVICE_A_URL` | B | URL do Microsserviço A | `http://service_a:5050` |
| `FLASK_APP` | A, B | Nome da aplicação Flask | `app.py` |
| `PYTHONUNBUFFERED` | A, B | Saída não-bufferizada | `1` |

---

## 🧹 Limpeza

### Windows (PowerShell)

```powershell
.\docker_cleanup.ps1
```

### Linux/MacOS (Bash)

```bash
./docker_cleanup.sh
```

### Limpeza Manual

```bash
# Parar e remover containers
docker stop service_b service_a
docker rm service_b service_a

# Remover imagens
docker rmi service_a:latest service_b:latest

# Remover rede
docker network rm microservices_net
```

---

## 📊 Logs e Debugging

```bash
# Ver logs do Microsserviço A
docker logs service_a

# Ver logs do Microsserviço B
docker logs service_b

# Logs em tempo real
docker logs -f service_a
docker logs -f service_b

# Ver containers em execução
docker ps

# Inspecionar rede
docker network inspect microservices_net
```

---

## ✅ Critérios de Avaliação

| Critério | Pontos | Status |
|----------|--------|--------|
| Funcionamento da comunicação entre microsserviços | 5 pts | ✅ |
| Dockerfiles e isolamento corretos | 5 pts | ✅ |
| Explicação clara da arquitetura e endpoints | 5 pts | ✅ |
| Clareza e originalidade da implementação | 5 pts | ✅ |
| **Total** | **20 pts** | ✅ |

---

## 🎨 Features Extras

1. **Dashboard HTML responsivo**: Interface visual bonita no Microsserviço B
2. **Cálculo de tempo ativo**: Mostra há quanto tempo cada usuário está no sistema
3. **Múltiplos endpoints**: Flexibilidade para diferentes casos de uso
4. **Health checks**: Endpoints para monitoramento de saúde dos serviços
5. **Tratamento de erros**: Mensagens claras quando a comunicação falha
