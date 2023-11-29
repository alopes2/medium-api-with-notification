package main

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Name string `json:"name"`
}

type Response struct {
	Body string `json:"body"`
	StatusCode int `json:"statusCode"`
}

func HandleRequest(ctx context.Context, event *MyEvent) (*Response, error) {
	message := Response {
		Body:"Hello from Lambda!",
		StatusCode: 200,
	}
	return &message, nil
}

func main() {
	lambda.Start(HandleRequest)
}