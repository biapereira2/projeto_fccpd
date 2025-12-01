#!/usr/bin/env python3
"""
Desafio 2 - Volumes e Persistência
Aplicação SQLite que demonstra persistência de dados com volumes Docker.
"""

import sqlite3
import os
import sys
from datetime import datetime

# Caminho do banco de dados (será montado via volume)
DATABASE_PATH = os.environ.get('DATABASE_PATH', '/data/database.db')

def init_database():
    """Inicializa o banco de dados criando a tabela se não existir."""
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS registros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mensagem TEXT NOT NULL,
            container_id TEXT,
            criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    conn.close()
    print(f"[INFO] Banco de dados inicializado em: {DATABASE_PATH}")

def adicionar_registro(mensagem):
    """Adiciona um novo registro ao banco de dados."""
    container_id = os.environ.get('HOSTNAME', 'desconhecido')
    
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT INTO registros (mensagem, container_id)
        VALUES (?, ?)
    ''', (mensagem, container_id))
    
    conn.commit()
    registro_id = cursor.lastrowid
    conn.close()
    
    print(f"[OK] Registro #{registro_id} adicionado pelo container {container_id}")
    return registro_id

def listar_registros():
    """Lista todos os registros do banco de dados."""
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    cursor.execute('SELECT * FROM registros ORDER BY id')
    registros = cursor.fetchall()
    conn.close()
    
    if not registros:
        print("[INFO] Nenhum registro encontrado no banco de dados.")
        return []
    
    print("\n" + "=" * 70)
    print(f"{'ID':<5} {'Mensagem':<25} {'Container':<20} {'Criado em':<20}")
    print("=" * 70)
    
    for registro in registros:
        id_, mensagem, container_id, criado_em = registro
        print(f"{id_:<5} {mensagem:<25} {container_id:<20} {criado_em:<20}")
    
    print("=" * 70)
    print(f"Total de registros: {len(registros)}")
    print()
    
    return registros

def contar_registros():
    """Conta o número total de registros."""
    conn = sqlite3.connect(DATABASE_PATH)
    cursor = conn.cursor()
    
    cursor.execute('SELECT COUNT(*) FROM registros')
    total = cursor.fetchone()[0]
    conn.close()
    
    return total

def main():
    """Função principal do aplicativo."""
    mode = os.environ.get('APP_MODE', 'write')
    
    print("\n" + "=" * 70)
    print("  DESAFIO 2 - VOLUMES E PERSISTÊNCIA DE DADOS")
    print("=" * 70)
    print(f"  Container ID: {os.environ.get('HOSTNAME', 'desconhecido')}")
    print(f"  Modo: {mode.upper()}")
    print(f"  Banco de dados: {DATABASE_PATH}")
    print("=" * 70 + "\n")
    
    # Inicializa o banco de dados
    init_database()
    
    if mode == 'write':
        # Modo escrita: adiciona registros
        print("\n[MODO ESCRITA] Adicionando registros ao banco de dados...")
        
        # Adiciona alguns registros de exemplo
        mensagens = [
            f"Registro criado em {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            "Dados persistentes com Docker Volumes",
            "Este registro sobrevive à remoção do container"
        ]
        
        for msg in mensagens:
            adicionar_registro(msg)
        
        print("\n[INFO] Registros adicionados com sucesso!")
        
    elif mode == 'read':
        # Modo leitura: apenas lista os registros
        print("\n[MODO LEITURA] Lendo registros do banco de dados...")
    
    # Sempre lista os registros ao final
    print("\n[INFO] Listando todos os registros persistidos:")
    registros = listar_registros()
    
    total = contar_registros()
    print(f"[RESULTADO] Total de registros no banco: {total}")
    
    if total > 0:
        print("[SUCESSO] Os dados foram persistidos corretamente!\n")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
