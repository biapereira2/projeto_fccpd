# Projeto Docker - Desafios de Containerização

O repositório contém 5 desafios práticos de Docker elaborados durante a disciplina de Fundamentos da computação concorrente, paralela e distribuída, onde são abordados desde conceitos básicos de containers e redes até arquiteturas de microsserviços.

---

## 🗂️ Estrutura do Repositório

```
Projeto2_DesafioDocker/
├── README.md                 # Este arquivo
├── desafio1/                 # Containers em Rede
│   ├── README.md             # 📖 Documentação detalhada
│   ├── server/
│   └── client/
├── desafio2/                 # Volumes e Persistência
│   ├── README.md             # 📖 Documentação detalhada
│   ├── app/
│   └── reader/
├── desafio3/                 # Docker Compose
│   ├── README.md             # 📖 Documentação detalhada
│   ├── docker-compose.yml
│   └── web/
├── desafio4/                 # Microsserviços Independentes
│   ├── README.md             # 📖 Documentação detalhada
│   ├── service_a/
│   └── service_b/
└── desafio5/                 # API Gateway
    ├── README.md             # 📖 Documentação detalhada
    ├── docker-compose.yml
    ├── gateway/
    ├── users_service/
    └── orders_service/
```

> **📖 Nota:** Cada pasta de desafio contém seu próprio **README** com documentação detalhada, incluindo explicações da arquitetura, instruções de execução e exemplos de testes.

---

## 🚀 Como Executar

Cada desafio possui scripts de setup e cleanup para Windows (PowerShell) e Linux/Mac (Bash).

### Windows (PowerShell)

```powershell
# Entrar na pasta do desafio desejado
cd desafio1

# Executar o setup
.\docker_setup.ps1

# Para limpar o ambiente
.\docker_cleanup.ps1
```

### Linux/Mac (Bash)

```bash
# Entrar na pasta do desafio desejado
cd desafio1

# Dar permissão de execução (apenas na primeira vez)
chmod +x docker_setup.sh docker_cleanup.sh

# Executar o setup
./docker_setup.sh

# Para limpar o ambiente
./docker_cleanup.sh
```

---

## 📝 Resumo de Cada Desafio

### Desafio 1 — Containers em Rede
Criação de dois containers Docker (servidor Flask e cliente curl) que se comunicam através de uma rede customizada. Demonstra a resolução de DNS interno do Docker e comunicação entre containers.

### Desafio 2 — Volumes e Persistência
Demonstração de persistência de dados usando volumes Docker com SQLite. Os dados sobrevivem à remoção dos containers, permitindo que novos containers acessem informações previamente armazenadas.

### Desafio 3 — Docker Compose
Orquestração de múltiplos serviços (Flask + PostgreSQL + Redis) usando Docker Compose. Demonstra a configuração de dependências entre serviços, volumes para persistência e rede interna.

### Desafio 4 — Microsserviços Independentes
Dois microsserviços Flask independentes que se comunicam via HTTP. O Serviço B consome dados do Serviço A, demonstrando o padrão de comunicação entre microsserviços.

### Desafio 5 — Microsserviços com API Gateway
Arquitetura completa com API Gateway centralizando o acesso a dois microsserviços (usuários e pedidos). O gateway expõe endpoints `/users` e `/orders`, orquestrando as chamadas aos serviços internos.

---

## 🛠️ Pré-requisitos

- **Docker** instalado e em execução
- **Docker Compose** instalado (para desafios 3 e 5)
- **PowerShell** (Windows) ou **Bash** (Linux/Mac)

---

## 🔧 Tecnologias Utilizadas

- **Docker** - Containerização
- **Docker Compose** - Orquestração de containers
- **Python 3.11** - Linguagem de programação
- **Flask** - Framework web
- **PostgreSQL** - Banco de dados relacional
- **Redis** - Cache em memória
- **SQLite** - Banco de dados embarcado

---

## 📚 Documentação Detalhada

Para informações completas sobre cada desafio, consulte os READMEs específicos:

- [📖 Desafio 1 - Containers em Rede](./desafio1/README.md)
- [📖 Desafio 2 - Volumes e Persistência](./desafio2/README.md)
- [📖 Desafio 3 - Docker Compose](./desafio3/README.md)
- [📖 Desafio 4 - Microsserviços Independentes](./desafio4/README.md)
- [📖 Desafio 5 - API Gateway](./desafio5/README.md)
