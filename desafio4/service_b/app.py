"""
Microsserviço B - Consumidor de Usuários
Consome o Microsserviço A e exibe informações combinadas sobre os usuários.
"""

from flask import Flask, jsonify, render_template_string
from datetime import datetime
import requests
import os

app = Flask(__name__)

# URL do Microsserviço A (configurável via variável de ambiente)
SERVICE_A_URL = os.environ.get('SERVICE_A_URL', 'http://service_a:5050')

# Template HTML para exibição amigável
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Usuários - Microsserviço B</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            color: white;
            text-align: center;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .stats {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
        }
        .stat-label {
            color: #666;
            margin-top: 5px;
        }
        .user-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }
        .user-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .user-card:hover {
            transform: translateY(-5px);
        }
        .user-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5em;
            font-weight: bold;
            margin-right: 15px;
        }
        .user-name {
            font-size: 1.3em;
            font-weight: bold;
            color: #333;
        }
        .user-role {
            color: #666;
            font-size: 0.9em;
        }
        .user-info {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
        }
        .info-label {
            color: #888;
        }
        .info-value {
            font-weight: 500;
            color: #333;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
        }
        .status-ativo {
            background: #d4edda;
            color: #155724;
        }
        .status-inativo {
            background: #f8d7da;
            color: #721c24;
        }
        .active-since {
            background: #e8f4fd;
            color: #0c5460;
            padding: 10px 15px;
            border-radius: 8px;
            margin-top: 15px;
            font-weight: 500;
        }
        .error-card {
            background: #f8d7da;
            color: #721c24;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
        }
        footer {
            text-align: center;
            color: white;
            margin-top: 40px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Dashboard de Usuários</h1>
        
        {% if error %}
        <div class="error-card">
            <h2>❌ Erro ao conectar com o Microsserviço A</h2>
            <p>{{ error }}</p>
        </div>
        {% else %}
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">{{ total_users }}</div>
                <div class="stat-label">Total de Usuários</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">{{ active_users }}</div>
                <div class="stat-label">Usuários Ativos</div>
            </div>
        </div>
        
        <div class="user-grid">
            {% for user in users %}
            <div class="user-card">
                <div class="user-header">
                    <div class="avatar">{{ user.name[0] }}</div>
                    <div>
                        <div class="user-name">{{ user.name }}</div>
                        <div class="user-role">{{ user.role }}</div>
                    </div>
                </div>
                <div class="user-info">
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value">{{ user.email }}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Status:</span>
                        <span class="status-badge status-{{ user.status }}">{{ user.status | upper }}</span>
                    </div>
                </div>
                <div class="active-since">
                    📅 {{ user.combined_info }}
                </div>
            </div>
            {% endfor %}
        </div>
        {% endif %}
        
        <footer>
            <p>Microsserviço B - Consumindo dados do Microsserviço A</p>
            <p>Atualizado em: {{ timestamp }}</p>
        </footer>
    </div>
</body>
</html>
"""


def calculate_time_active(date_str):
    """Calcula há quanto tempo o usuário está ativo."""
    active_date = datetime.strptime(date_str, "%Y-%m-%d")
    today = datetime.now()
    diff = today - active_date
    
    years = diff.days // 365
    months = (diff.days % 365) // 30
    
    if years > 0:
        return f"{years} ano(s) e {months} mês(es)"
    elif months > 0:
        return f"{months} mês(es)"
    else:
        return f"{diff.days} dia(s)"


def fetch_users_from_service_a():
    """Busca usuários do Microsserviço A."""
    try:
        response = requests.get(f"{SERVICE_A_URL}/users", timeout=5)
        response.raise_for_status()
        data = response.json()
        return data.get("users", []), None
    except requests.exceptions.RequestException as e:
        return None, str(e)


@app.route('/health', methods=['GET'])
def health_check():
    """Endpoint de health check."""
    return jsonify({
        "service": "service_b",
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service_a_url": SERVICE_A_URL
    })


@app.route('/', methods=['GET'])
def dashboard():
    """Dashboard HTML com informações combinadas dos usuários."""
    users, error = fetch_users_from_service_a()
    
    if error:
        return render_template_string(
            HTML_TEMPLATE,
            error=error,
            users=[],
            total_users=0,
            active_users=0,
            timestamp=datetime.now().strftime("%d/%m/%Y %H:%M:%S")
        )
    
    # Adiciona informação combinada para cada usuário
    for user in users:
        time_active = calculate_time_active(user["active_since"])
        user["combined_info"] = f"Usuário {user['name'].split()[0]} ativo desde {user['active_since']} ({time_active})"
    
    active_count = len([u for u in users if u["status"] == "ativo"])
    
    return render_template_string(
        HTML_TEMPLATE,
        error=None,
        users=users,
        total_users=len(users),
        active_users=active_count,
        timestamp=datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    )


@app.route('/api/users-info', methods=['GET'])
def get_users_combined_info():
    """API JSON com informações combinadas dos usuários."""
    users, error = fetch_users_from_service_a()
    
    if error:
        return jsonify({
            "success": False,
            "error": f"Falha ao conectar com Microsserviço A: {error}"
        }), 503
    
    # Processa e adiciona informações combinadas
    combined_users = []
    for user in users:
        time_active = calculate_time_active(user["active_since"])
        combined_users.append({
            "id": user["id"],
            "name": user["name"],
            "email": user["email"],
            "role": user["role"],
            "status": user["status"],
            "active_since": user["active_since"],
            "combined_info": f"Usuário {user['name'].split()[0]} ativo desde {user['active_since']} ({time_active})",
            "time_active": time_active
        })
    
    return jsonify({
        "success": True,
        "source": "service_a",
        "processed_by": "service_b",
        "timestamp": datetime.now().isoformat(),
        "count": len(combined_users),
        "users": combined_users
    })


@app.route('/api/user/<int:user_id>', methods=['GET'])
def get_user_info(user_id):
    """Busca informações combinadas de um usuário específico."""
    try:
        response = requests.get(f"{SERVICE_A_URL}/users/{user_id}", timeout=5)
        response.raise_for_status()
        data = response.json()
        
        if not data.get("success"):
            return jsonify(data), 404
        
        user = data["user"]
        time_active = calculate_time_active(user["active_since"])
        
        return jsonify({
            "success": True,
            "user": {
                **user,
                "combined_info": f"Usuário {user['name'].split()[0]} ativo desde {user['active_since']} ({time_active})",
                "time_active": time_active
            }
        })
        
    except requests.exceptions.RequestException as e:
        return jsonify({
            "success": False,
            "error": f"Falha ao conectar com Microsserviço A: {str(e)}"
        }), 503


if __name__ == '__main__':
    print("🚀 Microsserviço B - Consumidor de Usuários iniciando...")
    print(f"📡 Conectando ao Microsserviço A em: {SERVICE_A_URL}")
    print("📍 Endpoints disponíveis:")
    print("   GET /health - Health check")
    print("   GET / - Dashboard HTML com usuários")
    print("   GET /api/users-info - API JSON com informações combinadas")
    print("   GET /api/user/<id> - Info combinada de um usuário")
    app.run(host='0.0.0.0', port=5051, debug=False)
