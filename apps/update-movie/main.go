package main

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/sns"
)

func handleRequest(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	movieID := request.PathParameters["movieID"]

	if strings.TrimSpace(movieID) == "" {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Movie ID invalid",
		})

		return events.APIGatewayProxyResponse{
			Body:       string(response),
			StatusCode: 400,
		}, nil
	}

	var updateMovie Request
	err := json.Unmarshal([]byte(request.Body), &updateMovie)

	if err != nil {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Got error marshalling update movie item, " + err.Error(),
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
	dynamoDbService := dynamodb.New(sess)

	movieData := MovieData{
		Title:  updateMovie.Title,
		Genres: updateMovie.Genres,
		Rating: updateMovie.Rating,
	}

	attributeMapping, err := dynamodbattribute.MarshalMap(movieData)

	if err != nil {
		response, _ := json.Marshal(ErrorResponse{
			Message: "Got error marshalling update movie item to DynamoAttribute, " + err.Error(),
		})

		return events.APIGatewayProxyResponse{
			Body:       string(response),
			StatusCode: 500,
		}, nil
	}

	// Create item in table Movies
	tableName := "Movies"

	input := &dynamodb.UpdateItemInput{
		ExpressionAttributeValues: attributeMapping,
		TableName:                 aws.String(tableName),
		Key: map[string]*dynamodb.AttributeValue{
			"ID": {
				S: aws.String(movieID),
			},
		},
		ReturnValues:     aws.String("ALL_NEW"),
		UpdateExpression: aws.String("set Rating = :rating, Title = :title, Genres = :genres"),
	}

	updateResponse, err := dynamoDbService.UpdateItem(input)

	if err != nil {
		errorResponse, _ := json.Marshal(ErrorResponse{
			Message: "Got error calling UpdateItem, " + err.Error(),
		})

		return events.APIGatewayProxyResponse{
			Body:       string(errorResponse),
			StatusCode: 500,
		}, nil
	}

	var movie Movie
	err = dynamodbattribute.UnmarshalMap(updateResponse.Attributes, &movie)

	publishEventToSNS(sess, movie)

	response := events.APIGatewayProxyResponse{
		StatusCode: 200,
	}

	return response, nil
}

func publishEventToSNS(sess *session.Session, item Movie) {
	snsService := sns.New(sess)

	movieUpdatedEvent := MovieUpdated{
		ID:     item.ID,
		Title:  item.Title,
		Rating: item.Rating,
		Genres: item.Genres,
	}

	eventJSON, err := json.Marshal(movieUpdatedEvent)

	_, err = snsService.Publish(&sns.PublishInput{
		Message: aws.String(string(eventJSON)),
		MessageAttributes: map[string]*sns.MessageAttributeValue{
			"Type": {
				DataType:    aws.String("String"),
				StringValue: aws.String(movieUpdatedEvent.getEventName()),
			},
		},
		TopicArn: aws.String("arn:aws:sns:eu-central-1:044256433832:movie-updates-topic"),
	})

	if err != nil {
		fmt.Println(err.Error())
	}
}

func main() {
	lambda.Start(handleRequest)
}
