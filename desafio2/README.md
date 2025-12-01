# Desafio 2 — Volumes e Persistência

## 📋 Objetivo

Demonstrar a persistência de dados usando volumes Docker com um banco de dados SQLite.

## 🏗️ Estrutura do Projeto

```
desafio2/
├── app/
│   ├── Dockerfile          # Imagem do container escritor
│   └── database_app.py     # Aplicação SQLite
├── reader/
│   ├── Dockerfile          # Imagem do container leitor
│   └── database_app.py     # Aplicação SQLite (modo leitura)
├── docker_setup.ps1        # Script de setup (Windows PowerShell)
├── docker_setup.sh         # Script de setup (Linux/Mac)
├── docker_cleanup.ps1      # Script de limpeza (Windows PowerShell)
├── docker_cleanup.sh       # Script de limpeza (Linux/Mac)
└── README.md               # Este arquivo
```

## 🚀 Como Executar

### Windows (PowerShell)

```powershell
cd desafio2
.\docker_setup.ps1
```

### Linux/Mac

```bash
cd desafio2
chmod +x docker_setup.sh
./docker_setup.sh
```

## 🔧 O Que o Script Faz

O script `docker_setup` executa os seguintes passos:

1. **Cria um volume Docker nomeado** (`desafio2-sqlite-data`)
2. **Constrói as imagens Docker** (writer e reader)
3. **Executa o container escritor** - adiciona registros ao SQLite
4. **Remove o container** (flag `--rm`)
5. **Verifica que o volume ainda existe**
6. **Executa o container leitor** - lê os dados persistidos
7. **Executa o escritor novamente** - adiciona mais registros
8. **Verificação final** - mostra todos os dados acumulados

## 📖 Conceitos Demonstrados

### Volumes Docker

Volumes são o mecanismo preferido para persistir dados gerados e utilizados por containers Docker.

```bash
# Criar um volume
docker volume create desafio2-sqlite-data

# Montar um volume em um container
docker run -v desafio2-sqlite-data:/data minha-imagem
```

### Tipos de Volumes

| Tipo | Descrição | Uso |
|------|-----------|-----|
| **Named Volume** | Volume gerenciado pelo Docker | ✅ Usado neste projeto |
| **Bind Mount** | Monta diretório do host | Para desenvolvimento |
| **tmpfs** | Armazena em memória | Dados temporários |

### Por que usar Volumes?

- ✅ **Persistência**: Dados sobrevivem à remoção do container
- ✅ **Compartilhamento**: Múltiplos containers podem acessar o mesmo volume
- ✅ **Backup**: Fácil fazer backup de volumes
- ✅ **Portabilidade**: Volumes funcionam em qualquer host Docker

## 📸 Demonstração de Persistência

### Passo 1: Container Escritor Adiciona Dados

```
======================================================================
  DESAFIO 2 - VOLUMES E PERSISTÊNCIA DE DADOS
======================================================================
  Container ID: abc123def456
  Modo: WRITE
  Banco de dados: /data/database.db
======================================================================

[INFO] Banco de dados inicializado em: /data/database.db
[MODO ESCRITA] Adicionando registros ao banco de dados...
[OK] Registro #1 adicionado pelo container abc123def456
[OK] Registro #2 adicionado pelo container abc123def456
[OK] Registro #3 adicionado pelo container abc123def456
```

### Passo 2: Container É Removido

```
[OK] Container 'sqlite-writer' não existe mais!
[OK] Volume 'desafio2-sqlite-data' ainda existe!
```

### Passo 3: Container Leitor (Diferente) Lê os Dados

```
======================================================================
  DESAFIO 2 - VOLUMES E PERSISTÊNCIA DE DADOS
======================================================================
  Container ID: xyz789uvw012   <- Container DIFERENTE!
  Modo: READ
  Banco de dados: /data/database.db
======================================================================

[MODO LEITURA] Lendo registros do banco de dados...

======================================================================
ID    Mensagem                  Container             Criado em           
======================================================================
1     Registro criado em ...    abc123def456         2025-11-30 12:00:00
2     Dados persistentes ...    abc123def456         2025-11-30 12:00:00
3     Este registro sobrev...   abc123def456         2025-11-30 12:00:00
======================================================================
Total de registros: 3

[SUCESSO] Os dados foram persistidos corretamente!
```

## 🧹 Limpeza

### Windows (PowerShell)

```powershell
.\docker_cleanup.ps1
```

### Linux/Mac

```bash
./docker_cleanup.sh
```

O script de limpeza remove:
- Containers (se existirem)
- Imagens Docker
- Volume com os dados

## 🔍 Comandos Úteis

```bash
# Listar volumes
docker volume ls

# Inspecionar volume
docker volume inspect desafio2-sqlite-data

# Executar container manualmente (modo escrita)
docker run --rm -v desafio2-sqlite-data:/data -e APP_MODE=write desafio2-writer

# Executar container manualmente (modo leitura)
docker run --rm -v desafio2-sqlite-data:/data -e APP_MODE=read desafio2-reader

# Remover volume
docker volume rm desafio2-sqlite-data
```

## ✅ Critérios Atendidos

| Critério | Pontos | Status |
|----------|--------|--------|
| Uso correto de volumes | 5 pts | ✅ Volume nomeado com montagem correta |
| Persistência comprovada após recriação | 5 pts | ✅ Dados mantidos após remoção do container |
| README com explicação e prints/resultados | 5 pts | ✅ Documentação completa |
| Clareza e organização do código | 5 pts | ✅ Código comentado e organizado |

## 🎯 Extras Implementados

- ✅ **Container leitor separado** (requisito opcional)
- ✅ **Scripts automatizados** para Windows e Linux
- ✅ **Múltiplas execuções** demonstrando acúmulo de dados
- ✅ **IDs de container** rastreados para provar que são containers diferentes

