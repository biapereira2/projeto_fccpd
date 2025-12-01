"""
Microsserviço de Pedidos
Fornece dados de pedidos através de uma API REST
"""

from flask import Flask, jsonify

app = Flask(__name__)

# Base de dados simulada de pedidos
ORDERS = [
    {
        "id": 1,
        "user_id": 1,
        "product": "Notebook Dell XPS",
        "quantity": 1,
        "price": 8500.00,
        "status": "entregue"
    },
    {
        "id": 2,
        "user_id": 2,
        "product": "Mouse Logitech MX Master",
        "quantity": 2,
        "price": 450.00,
        "status": "em trânsito"
    },
    {
        "id": 3,
        "user_id": 1,
        "product": "Teclado Mecânico",
        "quantity": 1,
        "price": 350.00,
        "status": "processando"
    },
    {
        "id": 4,
        "user_id": 3,
        "product": "Monitor 27 polegadas",
        "quantity": 1,
        "price": 1800.00,
        "status": "entregue"
    },
    {
        "id": 5,
        "user_id": 4,
        "product": "Webcam HD",
        "quantity": 1,
        "price": 280.00,
        "status": "em trânsito"
    }
]


@app.route('/health', methods=['GET'])
def health_check():
    """Endpoint para verificação de saúde do serviço"""
    return jsonify({
        "service": "orders-service",
        "status": "healthy",
        "version": "1.0.0"
    })


@app.route('/orders', methods=['GET'])
def get_orders():
    """Retorna lista de todos os pedidos"""
    return jsonify({
        "service": "orders-service",
        "data": ORDERS,
        "total": len(ORDERS)
    })


@app.route('/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    """Retorna um pedido específico por ID"""
    order = next((o for o in ORDERS if o["id"] == order_id), None)
    if order:
        return jsonify({
            "service": "orders-service",
            "data": order
        })
    return jsonify({
        "service": "orders-service",
        "error": "Pedido não encontrado"
    }), 404


@app.route('/orders/user/<int:user_id>', methods=['GET'])
def get_orders_by_user(user_id):
    """Retorna todos os pedidos de um usuário específico"""
    user_orders = [o for o in ORDERS if o["user_id"] == user_id]
    return jsonify({
        "service": "orders-service",
        "user_id": user_id,
        "data": user_orders,
        "total": len(user_orders)
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)
