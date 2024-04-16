#!/bin/bash

# Define the root directory based on the script's location
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PID_FILE="$ROOT_DIR/pids.txt"

# Function to stop a process by PID
stop_process() {
    echo "Stopping process $1..."
    kill $1
}

# Read PIDs from the file and stop the requested service
echo "Stopping the requested services..."
if [[ -f "$PID_FILE" ]]; then
    while IFS= read -r line
    do
        case "$1" in
            server)
                # Assume server is the first PID in the file
                stop_process $line
                break
                ;;
            client)
                # Assume client is the second PID in the file
                client_pid=$line
                ;;
            *)
                stop_process $line
                ;;
        esac
    done < "$PID_FILE"

    [[ -n "$client_pid" ]] && stop_process $client_pid
    rm -f "$PID_FILE"
    echo "Requested services have been stopped."
else
    echo "PID file not found at $PID_FILE."
fi
