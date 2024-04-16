package main

import (
	"context"
	arbitrage "go-currency-arbitrage/pkg/proto"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"google.golang.org/grpc"
)

type server struct {
	arbitrage.UnimplementedArbitrageServiceServer
}

func (s *server) SendCurrencyPrice(ctx context.Context, in *arbitrage.CurrencyPrice) (*arbitrage.Acknowledge, error) {
	log.Printf("Received: %v at price %v", in.GetCurrencyPair(), in.GetPrice())
	return &arbitrage.Acknowledge{Message: "Received"}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()

	go func() {
		arbitrage.RegisterArbitrageServiceServer(s, &server{})
		if err := s.Serve(lis); err != nil {
			log.Fatalf("failed to serve: %v", err)
		}
	}()

	// Handle graceful shutdown
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM) // Capture Ctrl+C and kill command
	<-c
	s.GracefulStop()
	lis.Close()
	log.Println("Server has been stopped.")
}
