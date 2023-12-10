package main

import (
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/google/uuid"
)

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var newMovie Request
	err := json.Unmarshal([]byte(request.Body), &newMovie)

	if err != nil {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Got error marshalling new movie item, " + err.Error(),
		})

		return events.APIGatewayProxyResponse{
			Body:       string(response),
			StatusCode: 500,
		}, nil
	}

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	// Create DynamoDB client
	svc := dynamodb.New(sess)

	item := Movie{
		ID:     uuid.NewString(),
		Title:  newMovie.Title,
		Genres: newMovie.Genres,
		Rating: newMovie.Rating,
	}

	av, err := dynamodbattribute.MarshalMap(item)
	if err != nil {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Got error marshalling new movie item to DynamoAttribute, " + err.Error(),
		})

		return events.APIGatewayProxyResponse{
			Body:       string(response),
			StatusCode: 500,
		}, nil
	}

	// Create item in table Movies
	tableName := "Movies"

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(tableName),
	}

	_, err = svc.PutItem(input)
	if err != nil {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Got error calling PutItem, " + err.Error(),
		})

		return events.APIGatewayProxyResponse{
			Body:       string(response),
			StatusCode: 500,
		}, nil
	}

	responseData := Response{
		ID:     item.ID,
		Title:  item.Title,
		Genres: item.Genres,
		Rating: item.Rating,
	}

	responseBody, err := json.Marshal(responseData)

	response := events.APIGatewayProxyResponse{
		Body:       string(responseBody),
		StatusCode: 200,
	}

	return response, nil
}

func main() {
	lambda.Start(handleRequest)
}
