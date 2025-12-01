"""
API Gateway
Ponto único de entrada que orquestra chamadas aos microsserviços
"""

from flask import Flask, jsonify, request
import requests
import os

app = Flask(__name__)

# URLs dos microsserviços (usando nomes dos containers do Docker)
USERS_SERVICE_URL = os.getenv('USERS_SERVICE_URL', 'http://users-service:5001')
ORDERS_SERVICE_URL = os.getenv('ORDERS_SERVICE_URL', 'http://orders-service:5002')


@app.route('/', methods=['GET'])
def index():
    """Endpoint principal com informações da API"""
    return jsonify({
        "service": "api-gateway",
        "version": "1.0.0",
        "description": "API Gateway - Ponto único de entrada para os microsserviços",
        "endpoints": {
            "/": "Informações da API",
            "/health": "Status de saúde do gateway e serviços",
            "/users": "Lista todos os usuários (proxy para users-service)",
            "/users/<id>": "Busca usuário por ID",
            "/orders": "Lista todos os pedidos (proxy para orders-service)",
            "/orders/<id>": "Busca pedido por ID",
            "/orders/user/<user_id>": "Busca pedidos de um usuário",
            "/users/<id>/orders": "Busca usuário com seus pedidos (agregação)"
        }
    })


@app.route('/health', methods=['GET'])
def health_check():
    """Verifica a saúde do gateway e dos microsserviços"""
    services_status = {
        "gateway": "healthy"
    }
    
    # Verificar serviço de usuários
    try:
        response = requests.get(f"{USERS_SERVICE_URL}/health", timeout=5)
        services_status["users-service"] = "healthy" if response.status_code == 200 else "unhealthy"
    except requests.exceptions.RequestException:
        services_status["users-service"] = "unavailable"
    
    # Verificar serviço de pedidos
    try:
        response = requests.get(f"{ORDERS_SERVICE_URL}/health", timeout=5)
        services_status["orders-service"] = "healthy" if response.status_code == 200 else "unhealthy"
    except requests.exceptions.RequestException:
        services_status["orders-service"] = "unavailable"
    
    # Determinar status geral
    all_healthy = all(status == "healthy" for status in services_status.values())
    
    return jsonify({
        "service": "api-gateway",
        "status": "healthy" if all_healthy else "degraded",
        "services": services_status
    }), 200 if all_healthy else 503


# ==================== ROTAS DE USUÁRIOS ====================

@app.route('/users', methods=['GET'])
def get_users():
    """Proxy para obter todos os usuários"""
    try:
        response = requests.get(f"{USERS_SERVICE_URL}/users", timeout=10)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de usuários indisponível",
            "details": str(e)
        }), 503


@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Proxy para obter um usuário específico"""
    try:
        response = requests.get(f"{USERS_SERVICE_URL}/users/{user_id}", timeout=10)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de usuários indisponível",
            "details": str(e)
        }), 503


# ==================== ROTAS DE PEDIDOS ====================

@app.route('/orders', methods=['GET'])
def get_orders():
    """Proxy para obter todos os pedidos"""
    try:
        response = requests.get(f"{ORDERS_SERVICE_URL}/orders", timeout=10)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de pedidos indisponível",
            "details": str(e)
        }), 503


@app.route('/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    """Proxy para obter um pedido específico"""
    try:
        response = requests.get(f"{ORDERS_SERVICE_URL}/orders/{order_id}", timeout=10)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de pedidos indisponível",
            "details": str(e)
        }), 503


@app.route('/orders/user/<int:user_id>', methods=['GET'])
def get_orders_by_user(user_id):
    """Proxy para obter pedidos de um usuário"""
    try:
        response = requests.get(f"{ORDERS_SERVICE_URL}/orders/user/{user_id}", timeout=10)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de pedidos indisponível",
            "details": str(e)
        }), 503


# ==================== ROTA DE AGREGAÇÃO ====================

@app.route('/users/<int:user_id>/orders', methods=['GET'])
def get_user_with_orders(user_id):
    """
    Agregação: busca dados do usuário e seus pedidos
    Demonstra o poder do gateway em orquestrar múltiplos serviços
    """
    result = {}
    
    # Buscar dados do usuário
    try:
        user_response = requests.get(f"{USERS_SERVICE_URL}/users/{user_id}", timeout=10)
        if user_response.status_code == 200:
            result["user"] = user_response.json().get("data")
        else:
            return jsonify({
                "error": "Usuário não encontrado",
                "user_id": user_id
            }), 404
    except requests.exceptions.RequestException as e:
        return jsonify({
            "error": "Serviço de usuários indisponível",
            "details": str(e)
        }), 503
    
    # Buscar pedidos do usuário
    try:
        orders_response = requests.get(f"{ORDERS_SERVICE_URL}/orders/user/{user_id}", timeout=10)
        if orders_response.status_code == 200:
            result["orders"] = orders_response.json().get("data", [])
            result["total_orders"] = len(result["orders"])
        else:
            result["orders"] = []
            result["total_orders"] = 0
    except requests.exceptions.RequestException as e:
        result["orders"] = []
        result["orders_error"] = "Serviço de pedidos indisponível"
    
    return jsonify({
        "service": "api-gateway",
        "aggregation": "user-with-orders",
        "data": result
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
