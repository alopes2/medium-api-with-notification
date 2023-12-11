import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, DeleteCommand } from "@aws-sdk/lib-dynamodb";
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { PublishCommand, SNSClient } from "@aws-sdk/client-sns";
import { MovieDeleted } from "./models.js";

const tableName = "Movies";

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const movieID = event.pathParameters?.movieID;

  if (!movieID) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Movie ID missing",
      }),
    };
  }

  console.log("Deleting movie with ID ", movieID);

  const client = new DynamoDBClient({});
  const docClient = DynamoDBDocumentClient.from(client);

  const command = new DeleteCommand({
    TableName: tableName,
    Key: {
      ID: movieID.toString(),
    },
  });

  try {
    await docClient.send(command);

    await publishEventToSNS(movieID);

    return {
      statusCode: 204,
      body: JSON.stringify({
        message: `Movie ${movieID} deleted`,
      }),
    };
  } catch (e: any) {
    console.log(e);

    return {
      statusCode: 500,
      body: JSON.stringify({
        message: e.message,
      }),
    };
  }
};

async function publishEventToSNS(movieID: string) {
  const snsClient = new SNSClient({});

  const event: MovieDeleted = {
    id: movieID,
  };

  const eventName = "MovieDeleted";

  try {
    await snsClient.send(
      new PublishCommand({
        Message: JSON.stringify(event),
        TopicArn: "arn:aws:sns:eu-central-1:044256433832:movie-updates-topic",
        MessageAttributes: {
          Type: {
            DataType: "String",
            StringValue: eventName,
          },
        },
      })
    );
  } catch (e: any) {
    console.warn(e);
  }
}
