from flask import Flask, jsonify
from datetime import datetime, timedelta
import random

app = Flask(__name__)

USERS = [
    {
        "id": 1,
        "name": "Ana Silva",
        "email": "ana.silva@email.com",
        "role": "Desenvolvedora",
        "active_since": "2022-03-15",
        "status": "ativo"
    },
    {
        "id": 2,
        "name": "Bruno Santos",
        "email": "bruno.santos@email.com",
        "role": "DevOps Engineer",
        "active_since": "2021-08-22",
        "status": "ativo"
    },
    {
        "id": 3,
        "name": "Carla Mendes",
        "email": "carla.mendes@email.com",
        "role": "Data Scientist",
        "active_since": "2023-01-10",
        "status": "ativo"
    },
    {
        "id": 4,
        "name": "Daniel Costa",
        "email": "daniel.costa@email.com",
        "role": "Tech Lead",
        "active_since": "2020-05-01",
        "status": "inativo"
    },
    {
        "id": 5,
        "name": "Elena Rodrigues",
        "email": "elena.rodrigues@email.com",
        "role": "Frontend Developer",
        "active_since": "2023-06-20",
        "status": "ativo"
    }
]


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        "service": "service_a",
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    })


@app.route('/users', methods=['GET'])
def get_users():
    return jsonify({
        "success": True,
        "count": len(USERS),
        "users": USERS
    })


@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = next((u for u in USERS if u["id"] == user_id), None)
    if user:
        return jsonify({
            "success": True,
            "user": user
        })
    return jsonify({
        "success": False,
        "error": f"Usuário com ID {user_id} não encontrado"
    }), 404


@app.route('/users/active', methods=['GET'])
def get_active_users():
    active_users = [u for u in USERS if u["status"] == "ativo"]
    return jsonify({
        "success": True,
        "count": len(active_users),
        "users": active_users
    })


if __name__ == '__main__':
    print(" Microsserviço A - API de Usuários iniciando...")
    print(" Endpoints disponíveis:")
    print("   GET /health - Health check")
    print("   GET /users - Lista todos os usuários")
    print("   GET /users/<id> - Busca usuário por ID")
    print("   GET /users/active - Lista usuários ativos")
    app.run(host='0.0.0.0', port=5050, debug=False)
