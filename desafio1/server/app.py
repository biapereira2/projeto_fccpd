from flask import Flask, request
from datetime import datetime

app = Flask(__name__)


@app.route('/')
def index():
    timestamp = datetime.now().isoformat()
    print(f"[{timestamp}] Requisicao recebida de {request.remote_addr}")
    return {
        'msg': 'Hello from server', 
        'client_ip': request.remote_addr,
        'timestamp': timestamp
    }


@app.route('/health')
def health():
    return {'status': 'healthy'}


if __name__ == '__main__':
    print("=" * 50)
    print("  Servidor Flask - Desafio 1")
    print("  Porta: 8080")
    print("=" * 50)
    app.run(host='0.0.0.0', port=8080)