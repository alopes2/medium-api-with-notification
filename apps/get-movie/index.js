import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const tableName = "Movies";

export const handler = async (event) => {
  const movieID = event.pathParameters?.movieID;

  if (!movieID) {
    return {
      statusCode: 400,
      body: {
        message: "Movie ID missing",
      },
    };
  }

  console.log("Getting movie with ID ", movieID);

  const client = new DynamoDBClient({});
  const docClient = DynamoDBDocumentClient.from(client);

  const command = new GetCommand({
    TableName: tableName,
    Key: {
      ID: movieID.toString(),
    },
  });

  try {
    const dynamoResponse = await docClient.send(command);
    if (!dynamoResponse.Item) {
      return {
        statusCode: 404,
        body: {
          message: "Movie not found",
        },
      };
    }

    const response = {
      statusCode: 200,
      body: JSON.stringify(dynamoResponse.Item),
    };

    return response;
  } catch (e) {
    console.log(e);

    return {
      statusCode: 500,
      body: {
        message: e.message,
      },
    };
  }
};
