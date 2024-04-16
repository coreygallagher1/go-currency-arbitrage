package main

import (
	"context"
	arbitrage "go-currency-arbitrage/pkg/proto"
	"log"

	"google.golang.org/grpc"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := arbitrage.NewArbitrageServiceClient(conn)

	// Contact the server and print out its response.
	currencyPair := "BTC_USD"
	price := 10000.00 // Dummy price
	r, err := c.SendCurrencyPrice(context.Background(), &arbitrage.CurrencyPrice{CurrencyPair: currencyPair, Price: price})
	if err != nil {
		log.Fatalf("could not send price: %v", err)
	}
	log.Printf("Acknowledgement: %s", r.GetMessage())
}
