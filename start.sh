#!/bin/bash

# Define the root directory based on the script's location
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Function to start server
start_server() {
    echo "Starting the server..."
    SERVER_DIR="$ROOT_DIR/cmd/server"
    cd "$SERVER_DIR"
    if [[ -f ./server ]]; then
        ./server &
        SERVER_PID=$!
        echo "Server started with PID $SERVER_PID"
        echo $SERVER_PID > "$ROOT_DIR/pids.txt"
    else
        echo "Server executable not found in $SERVER_DIR."
    fi
}

# Function to start client
start_client() {
    echo "Starting the client..."
    CLIENT_DIR="$ROOT_DIR/cmd/client"
    cd "$CLIENT_DIR"
    if [[ -f ./client ]]; then
        ./client &
        CLIENT_PID=$!
        echo "Client started with PID $CLIENT_PID"
        echo $CLIENT_PID >> "$ROOT_DIR/pids.txt"
    else
        echo "Client executable not found in $CLIENT_DIR."
    fi
}

# Check command-line argument
case "$1" in
    server)
        start_server
        ;;
    client)
        start_client
        ;;
    *)
        start_server
        start_client
        ;;
esac

echo "Requested services are running."
