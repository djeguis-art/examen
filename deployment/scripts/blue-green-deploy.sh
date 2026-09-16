#!/usr/bin/env bash

set -euo pipefail

JAR_FILE="$1"
DEPLOY_DIR="${2:-deployment/runtime}"

BLUE_PORT=8081
GREEN_PORT=8082

mkdir -p "$DEPLOY_DIR/blue"
mkdir -p "$DEPLOY_DIR/green"

cleanup() {
    echo
    echo "Deteniendo ambientes de prueba..."

    if [ -n "${BLUE_PID:-}" ]; then
        kill "$BLUE_PID" 2>/dev/null || true
    fi

    if [ -n "${GREEN_PID:-}" ]; then
        kill "$GREEN_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT

wait_for_app() {

    local URL="$1"

    for i in {1..30}; do

        if curl -fsS "$URL/api/tareas" > /dev/null 2>&1; then
            return 0
        fi

        sleep 2
    done

    echo "ERROR: La aplicacion no respondio en $URL"
    return 1
}

echo "========================================="
echo " BLUE-GREEN DEPLOYMENT"
echo "========================================="

echo
echo "Preparando ambiente BLUE..."

cp "$JAR_FILE" "$DEPLOY_DIR/blue/app.jar"

java -jar "$DEPLOY_DIR/blue/app.jar" \
    --server.port=$BLUE_PORT \
    > "$DEPLOY_DIR/blue/application.log" 2>&1 &

BLUE_PID=$!

wait_for_app "http://localhost:$BLUE_PORT"

echo "BLUE disponible en puerto $BLUE_PORT"

echo "blue" > "$DEPLOY_DIR/active-environment.txt"

echo
echo "Ambiente activo inicial: BLUE"

echo
echo "Preparando nueva version en GREEN..."

cp "$JAR_FILE" "$DEPLOY_DIR/green/app.jar"

java -jar "$DEPLOY_DIR/green/app.jar" \
    --server.port=$GREEN_PORT \
    > "$DEPLOY_DIR/green/application.log" 2>&1 &

GREEN_PID=$!

wait_for_app "http://localhost:$GREEN_PORT"

echo "GREEN disponible en puerto $GREEN_PORT"

echo
echo "Ejecutando acceptance tests sobre GREEN..."

bash deployment/scripts/acceptance-test.sh \
    "http://localhost:$GREEN_PORT"

echo
echo "Acceptance tests GREEN: OK"

echo "green" > "$DEPLOY_DIR/active-environment.txt"

echo
echo "========================================="
echo " DEPLOYMENT SUCCESS"
echo " Ambiente activo: GREEN"
echo "========================================="

echo
echo "Simulando mecanismo de rollback..."

bash deployment/scripts/acceptance-test.sh \
    "http://localhost:$BLUE_PORT"

echo "blue" > "$DEPLOY_DIR/active-environment.txt"

echo
echo "========================================="
echo " ROLLBACK SUCCESS"
echo " Ambiente activo restaurado: BLUE"
echo "========================================="