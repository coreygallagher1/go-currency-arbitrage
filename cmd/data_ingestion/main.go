package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func fetchData() {
	// Example function to simulate fetching data
	fmt.Println("Fetching data...")
	// Implement actual data fetching logic here
}

func main() {
	ticker := time.NewTicker(10 * time.Second)
	go func() {
		for {
			select {
			case <-ticker.C:
				fetchData()
			}
		}
	}()

	log.Println("Data Ingestion Service started")
	http.ListenAndServe(":8080", nil) // Optionally listen for HTTP requests
}
