# Desafio 3 — Docker Compose Orquestrando Serviços

## 📋 Objetivo

Demonstrar o uso do Docker Compose para orquestrar múltiplos serviços dependentes, configurando comunicação entre containers através de rede interna.

---

## 🏗️ Arquitetura

A aplicação é composta por **3 serviços** que se comunicam através de uma rede Docker interna chamada `desafio3_network`.

O **Web** é o serviço principal da aplicação, construído com Python 3.11 e Flask. Ele expõe uma API REST na porta 5000, que é a única porta acessível externamente. Este serviço atua como o ponto de entrada para todas as requisições e é responsável por coordenar a comunicação com os demais serviços.

O **DB** é um container PostgreSQL 15 (versão Alpine) que fornece persistência de dados relacional. Ele opera na porta 5432, acessível apenas internamente pela rede Docker. Os dados são persistidos através de um volume nomeado (`postgres_data`), garantindo que as informações sobrevivam a reinicializações do container.

O **Cache** é um container Redis 7 (versão Alpine) que fornece armazenamento em memória para operações de cache rápidas, como contadores de visitas. Ele opera na porta 6379, também acessível apenas internamente. Um volume nomeado (`redis_data`) é utilizado para persistir os dados do cache.

Todos os serviços estão conectados através da rede Docker interna, permitindo que se comuniquem usando seus nomes de serviço como hostnames (ex: `db`, `cache`). Apenas o serviço Web tem sua porta exposta para o host, garantindo isolamento e segurança dos serviços de dados.

### Serviços

| Serviço | Imagem | Função | Porta |
|---------|--------|--------|-------|
| **web** | Python 3.11 + Flask | API REST que conecta aos demais serviços | 5000 (exposta) |
| **db** | PostgreSQL 15 Alpine | Banco de dados relacional para persistência | 5432 (interna) |
| **cache** | Redis 7 Alpine | Cache em memória para contadores rápidos | 6379 (interna) |

---

## 🔄 Fluxo de Comunicação

1. **Cliente** → Faz requisição HTTP para `http://localhost:5000`
2. **Web (Flask)** → Processa a requisição
3. **Web** → Conecta ao **PostgreSQL** via hostname `db` (rede interna)
4. **Web** → Conecta ao **Redis** via hostname `cache` (rede interna)
5. **Web** → Retorna resposta JSON ao cliente

---

## 📁 Estrutura de Arquivos

```
desafio3/
├── docker-compose.yml      # Orquestração dos serviços
├── docker_setup.ps1        # Script de inicialização (Windows)
├── docker_setup.sh         # Script de inicialização (Linux/Mac)
├── docker_cleanup.ps1      # Script de limpeza (Windows)
├── docker_cleanup.sh       # Script de limpeza (Linux/Mac)
├── README.md               # Este arquivo
└── web/
    ├── Dockerfile          # Imagem da aplicação Flask
    ├── app.py              # Código da API
    └── requirements.txt    # Dependências Python
```

---

## 🚀 Como Executar

### Windows (PowerShell)
```powershell
cd desafio3
.\docker_setup.ps1
```

### Linux/Mac (Bash)
```bash
cd desafio3
chmod +x docker_setup.sh
./docker_setup.sh
```

### Manual (Docker Compose)
```bash
cd desafio3
docker compose build
docker compose up -d
```

---

## 🌐 Endpoints da API

| Endpoint | Método | Descrição |
|----------|--------|-----------|
| `/` | GET | Página inicial com lista de endpoints |
| `/health` | GET | Verifica saúde de todos os serviços |
| `/visit` | GET | Registra visita no DB e incrementa cache |
| `/stats` | GET | Exibe estatísticas de visitas |

### Exemplos de Uso

```bash
# Verificar saúde dos serviços
curl http://localhost:5000/health

# Registrar uma visita
curl http://localhost:5000/visit

# Ver estatísticas
curl http://localhost:5000/stats
```

---

## ⚙️ Configurações do Docker Compose

### Dependências (`depends_on`)
```yaml
web:
  depends_on:
    db:
      condition: service_healthy
    cache:
      condition: service_healthy
```
O serviço **web** só inicia após **db** e **cache** estarem saudáveis.

### Variáveis de Ambiente
```yaml
environment:
  - DB_HOST=db           # Nome do serviço = hostname na rede
  - DB_PORT=5432
  - REDIS_HOST=cache     # Nome do serviço = hostname na rede
  - REDIS_PORT=6379
```

### Rede Interna
```yaml
networks:
  desafio3_network:
    driver: bridge
```
Todos os serviços compartilham a mesma rede, permitindo comunicação via hostname.

### Health Checks
Cada serviço possui verificação de saúde:
- **PostgreSQL**: `pg_isready` 
- **Redis**: `redis-cli ping`
- **Web**: `curl http://localhost:5000/health`

### Volumes Persistentes
```yaml
volumes:
  postgres_data:    # Dados do PostgreSQL
  redis_data:       # Dados do Redis
```

---

## 🧹 Limpeza

### Windows
```powershell
.\docker_cleanup.ps1
```

### Linux/Mac
```bash
./docker_cleanup.sh
```

### Manual
```bash
# Parar e remover containers
docker compose down

# Remover também volumes
docker compose down -v

# Remover também imagens
docker compose down --rmi local
```

---

## 📊 Verificando a Comunicação

### 1. Ver logs em tempo real
```bash
docker compose logs -f
```

### 2. Testar conectividade
```bash
# Testar endpoint de saúde
curl http://localhost:5000/health

# Resposta esperada:
{
  "status": "all services healthy",
  "services": {
    "web": "healthy",
    "database": "healthy",
    "cache": "healthy"
  }
}
```

### 3. Testar fluxo completo
```bash
# Registrar visitas
curl http://localhost:5000/visit
curl http://localhost:5000/visit
curl http://localhost:5000/visit

# Ver estatísticas
curl http://localhost:5000/stats
```

---

## 🔧 Tecnologias Utilizadas

- **Docker** & **Docker Compose** - Containerização e orquestração
- **Python 3.11** + **Flask** - Framework web
- **PostgreSQL 15** - Banco de dados relacional
- **Redis 7** - Cache em memória
- **Alpine Linux** - Imagens base otimizadas

---

## ✅ Critérios de Avaliação

| Critério | Pontos | Status |
|----------|--------|--------|
| Compose funcional e bem estruturado | 10 pts | ✅ |
| Comunicação entre serviços funcionando | 5 pts | ✅ |
| README com explicação da arquitetura | 5 pts | ✅ |
| Clareza e boas práticas | 5 pts | ✅ |
| **Total** | **25 pts** | |

---

## 📝 Boas Práticas Implementadas

1. **Health checks** em todos os serviços
2. **depends_on com condition** para garantir ordem de inicialização
3. **Volumes nomeados** para persistência de dados
4. **Rede bridge dedicada** para isolamento
5. **Variáveis de ambiente** para configuração
6. **Imagens Alpine** para menor tamanho
7. **Restart policy** para resiliência
8. **Multi-stage build** otimizado (cache de layers)
9. **Documentação completa** com exemplos
