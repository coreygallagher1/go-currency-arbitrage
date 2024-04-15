#!/bin/bash

# Function to start services
start_services() {
    echo "Starting Data Ingestion Service..."
    go run ./cmd/data_ingestion/main.go & echo $! > pids.txt

    echo "Starting Arbitrage Detection Service..."
    go run ./cmd/arbitrage_detection/main.go & echo $! >> pids.txt

    echo "Starting Profit Calculation Service..."
    go run ./cmd/profit_calculation/main.go & echo $! >> pids.txt

    echo "All services started. PIDs saved to pids.txt."

    # Monitor the services and exit if any of them fail
    wait $(cat pids.txt)
    echo "A service has exited unexpectedly, stopping all services..."
    stop_services
}

# Function to stop services
stop_services() {
    echo "Stopping all services..."

    # Check if pids.txt exists and read each PID line by line
    if [ -f pids.txt ]; then
        while IFS= read -r pid
        do
            kill $pid 2>/dev/null
            echo "Stopped service with PID $pid"
        done < pids.txt
        # Remove the PID file after stopping the services
        rm pids.txt
    fi
    echo "All services have been stopped."
}

# Check command line arguments
if [ "$1" = "start" ]; then
    start_services
elif [ "$1" = "stop" ]; then
    stop_services
else
    echo "Usage: $0 start|stop"
fi
