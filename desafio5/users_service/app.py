"""
Microsserviço de Usuários
Fornece dados de usuários através de uma API REST
"""

from flask import Flask, jsonify

app = Flask(__name__)

# Base de dados simulada de usuários
USERS = [
    {"id": 1, "name": "Maria Silva", "email": "maria.silva@email.com", "role": "admin"},
    {"id": 2, "name": "João Santos", "email": "joao.santos@email.com", "role": "user"},
    {"id": 3, "name": "Ana Oliveira", "email": "ana.oliveira@email.com", "role": "user"},
    {"id": 4, "name": "Pedro Costa", "email": "pedro.costa@email.com", "role": "moderator"},
    {"id": 5, "name": "Carla Ferreira", "email": "carla.ferreira@email.com", "role": "user"}
]


@app.route('/health', methods=['GET'])
def health_check():
    """Endpoint para verificação de saúde do serviço"""
    return jsonify({
        "service": "users-service",
        "status": "healthy",
        "version": "1.0.0"
    })


@app.route('/users', methods=['GET'])
def get_users():
    """Retorna lista de todos os usuários"""
    return jsonify({
        "service": "users-service",
        "data": USERS,
        "total": len(USERS)
    })


@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Retorna um usuário específico por ID"""
    user = next((u for u in USERS if u["id"] == user_id), None)
    if user:
        return jsonify({
            "service": "users-service",
            "data": user
        })
    return jsonify({
        "service": "users-service",
        "error": "Usuário não encontrado"
    }), 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
