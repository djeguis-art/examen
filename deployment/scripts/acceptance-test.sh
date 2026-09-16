#!/usr/bin/env bash

set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"

echo "========================================="
echo " ACCEPTANCE TEST - API DE TAREAS"
echo "========================================="
echo "Ambiente: $BASE_URL"
echo

echo "[1/3] Verificando disponibilidad de la API..."

HTTP_STATUS=$(curl -s \
    -o /tmp/acceptance-get.json \
    -w "%{http_code}" \
    "$BASE_URL/api/tareas")

if [ "$HTTP_STATUS" != "200" ]; then
    echo "ERROR: La API respondio con HTTP $HTTP_STATUS"
    exit 1
fi

echo "OK - API disponible (HTTP 200)"

echo
echo "[2/3] Creando tarea de aceptacion..."

HTTP_STATUS=$(curl -s \
    -o /tmp/acceptance-post.json \
    -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"titulo":"Prueba de aceptacion automatizada"}' \
    "$BASE_URL/api/tareas")

if [ "$HTTP_STATUS" != "201" ]; then
    echo "ERROR: No fue posible crear la tarea. HTTP $HTTP_STATUS"
    exit 1
fi

grep -q '"titulo":"Prueba de aceptacion automatizada"' \
    /tmp/acceptance-post.json

echo "OK - Tarea creada correctamente (HTTP 201)"

echo
echo "[3/3] Verificando tarea creada..."

curl -fsS "$BASE_URL/api/tareas" \
    | grep -q "Prueba de aceptacion automatizada"

echo "OK - La tarea fue recuperada correctamente"

echo
echo "========================================="
echo " ACCEPTANCE TESTS PASSED"
echo "========================================="