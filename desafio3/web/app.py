"""
Desafio 3 - Aplicação Web com Flask, PostgreSQL e Redis
Demonstra comunicação entre múltiplos serviços via Docker Compose
"""

import os
import time
from flask import Flask, jsonify
import psycopg2
import redis

app = Flask(__name__)

# Configurações via variáveis de ambiente
DB_HOST = os.environ.get('DB_HOST', 'db')
DB_PORT = os.environ.get('DB_PORT', '5432')
DB_NAME = os.environ.get('DB_NAME', 'desafio3_db')
DB_USER = os.environ.get('DB_USER', 'postgres')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'postgres123')

REDIS_HOST = os.environ.get('REDIS_HOST', 'cache')
REDIS_PORT = int(os.environ.get('REDIS_PORT', '6379'))


def get_db_connection():
    """Estabelece conexão com o PostgreSQL"""
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )


def get_redis_connection():
    """Estabelece conexão com o Redis"""
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


def init_db():
    """Inicializa o banco de dados com tabela de visitas"""
    max_retries = 10
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            
            # Criar tabela de visitas se não existir
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS visits (
                    id SERIAL PRIMARY KEY,
                    endpoint VARCHAR(100) NOT NULL,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')
            
            conn.commit()
            cursor.close()
            conn.close()
            print("Banco de dados inicializado com sucesso!")
            return True
        except Exception as e:
            print(f"Tentativa {attempt + 1}/{max_retries} - Aguardando banco de dados... ({e})")
            time.sleep(retry_delay)
    
    print("Falha ao conectar ao banco de dados após várias tentativas")
    return False


@app.route('/')
def index():
    """Página inicial - testa conexão com todos os serviços"""
    return jsonify({
        'service': 'Desafio 3 - Docker Compose',
        'description': 'Aplicação orquestrando Web + PostgreSQL + Redis',
        'endpoints': {
            '/': 'Esta página',
            '/health': 'Status de saúde dos serviços',
            '/visit': 'Registra visita no DB e incrementa contador no cache',
            '/stats': 'Estatísticas de visitas'
        }
    })


@app.route('/health')
def health_check():
    """Verifica a saúde de todos os serviços"""
    status = {
        'web': 'healthy',
        'database': 'unknown',
        'cache': 'unknown'
    }
    
    # Testar conexão com PostgreSQL
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('SELECT 1')
        cursor.close()
        conn.close()
        status['database'] = 'healthy'
    except Exception as e:
        status['database'] = f'unhealthy: {str(e)}'
    
    # Testar conexão com Redis
    try:
        r = get_redis_connection()
        r.ping()
        status['cache'] = 'healthy'
    except Exception as e:
        status['cache'] = f'unhealthy: {str(e)}'
    
    all_healthy = all(v == 'healthy' for v in status.values())
    
    return jsonify({
        'status': 'all services healthy' if all_healthy else 'some services unhealthy',
        'services': status
    }), 200 if all_healthy else 503


@app.route('/visit')
def register_visit():
    """Registra uma visita no PostgreSQL e incrementa contador no Redis"""
    result = {
        'success': False,
        'database_insert': False,
        'cache_increment': False
    }
    
    # Registrar no PostgreSQL
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO visits (endpoint) VALUES (%s) RETURNING id",
            ('/visit',)
        )
        visit_id = cursor.fetchone()[0]
        conn.commit()
        cursor.close()
        conn.close()
        result['database_insert'] = True
        result['visit_id'] = visit_id
    except Exception as e:
        result['database_error'] = str(e)
    
    # Incrementar contador no Redis
    try:
        r = get_redis_connection()
        count = r.incr('visit_counter')
        result['cache_increment'] = True
        result['total_visits_cache'] = count
    except Exception as e:
        result['cache_error'] = str(e)
    
    result['success'] = result['database_insert'] and result['cache_increment']
    
    return jsonify(result), 200 if result['success'] else 500


@app.route('/stats')
def get_stats():
    """Obtém estatísticas de visitas do PostgreSQL e Redis"""
    stats = {}
    
    # Buscar do PostgreSQL
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Total de visitas no banco
        cursor.execute("SELECT COUNT(*) FROM visits")
        stats['db_total_visits'] = cursor.fetchone()[0]
        
        # Últimas 5 visitas
        cursor.execute("""
            SELECT id, endpoint, timestamp 
            FROM visits 
            ORDER BY timestamp DESC 
            LIMIT 5
        """)
        stats['db_recent_visits'] = [
            {'id': row[0], 'endpoint': row[1], 'timestamp': str(row[2])}
            for row in cursor.fetchall()
        ]
        
        cursor.close()
        conn.close()
    except Exception as e:
        stats['db_error'] = str(e)
    
    # Buscar do Redis
    try:
        r = get_redis_connection()
        counter = r.get('visit_counter')
        stats['cache_visit_counter'] = int(counter) if counter else 0
    except Exception as e:
        stats['cache_error'] = str(e)
    
    return jsonify(stats)


if __name__ == '__main__':
    print("Inicializando aplicação...")
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
