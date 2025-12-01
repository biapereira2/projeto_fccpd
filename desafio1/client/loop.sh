#!/bin/sh
# Realiza requisições HTTP periódicas para o servidor

echo "=================================================="
echo "  Cliente iniciado - Desafio 1"
echo "  Servidor alvo: http://server:8080"
echo "  Intervalo: 5 segundos"
echo "=================================================="

# Aguarda servidor estar pronto
echo "Aguardando servidor..."
sleep 2

REQUEST_COUNT=0

while true; do
    REQUEST_COUNT=$((REQUEST_COUNT + 1))
    echo ""
    echo "--- Requisicao #$REQUEST_COUNT - $(date) ---"
    
    RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" http://server:8080/)
    HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
    BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "Status: OK (200)"
        echo "Resposta: $BODY"
    else
        echo "Status: ERRO (codigo: $HTTP_CODE)"
        echo "Resposta: $BODY"
    fi
    
    sleep 5
done