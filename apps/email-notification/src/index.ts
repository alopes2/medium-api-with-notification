import { SQSEvent, Context, SQSHandler, SQSRecord } from "aws-lambda";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";
import { MovieCreated, MovieCreatedEventType, MovieDeleted, MovieDeletedEventType, MovieUpdated, MovieUpdatedEventType } from "./models.js";

export const handler: SQSHandler = async (event: SQSEvent, context: Context): Promise<void> => {
  const client = new SESClient({});
  const promises: Promise<void>[] = [];
  for (const message of event.Records) {
    promises.push(processMessageAsync(message, client));
  }

  await Promise.all(promises);

  console.info("done");
};

async function processMessageAsync(message: SQSRecord, client: SESClient): Promise<void> {
  try {
    const eventType = message.messageAttributes["Type"].stringValue ?? "MovieEvent";
    console.log(`Processing ${eventType} message ${message.body}`);

    await sendEmail(message, eventType, client);

    console.log(`Processed ${eventType} message ${message.body}`);
  } catch (err) {
    console.error("An error occurred");
    console.error(err);
  }
}
async function sendEmail(message: SQSRecord, eventType: string, client: SESClient) {
  const [subject, body] = buildSubjectAndBody(message.body, eventType);

  const sourceEmail = process.env.SOURCE_EMAIL || ""; // Ideally it needs to be validated and logged if not set
  const destinationEmail = process.env.DESTINATION_EMAIL || ""; // Ideally it needs to be validated and logged if not set

  const command = new SendEmailCommand({
    Source: sourceEmail,
    Destination: {
      ToAddresses: [destinationEmail],
    },
    Message: {
      Body: {
        Text: {
          Charset: "UTF-8",
          Data: body,
        },
      },
      Subject: {
        Charset: "UTF-8",
        Data: subject,
      },
    },
  });

  await client.send(command);
}

function buildSubjectAndBody(messageBody: string, eventType: string): [string, string] {
  let subject = "";
  let body = "";
  const messageJsonBody = JSON.parse(messageBody);
  switch (eventType) {
    case MovieCreatedEventType:
      const movieCreatedEvent = <MovieCreated>messageJsonBody;
      subject = "New Movie Added: " + movieCreatedEvent.title;
      body = "A new movie was added!\n" + "ID: " + movieCreatedEvent.id + "\n" + "Title: " + movieCreatedEvent.title + "\n" + "Rating: " + movieCreatedEvent.rating + "\n" + "Genres: " + movieCreatedEvent.genres;
      break;
    case MovieDeletedEventType:
      const movieDeletedEvent = <MovieDeleted>messageJsonBody;
      subject = "Movie Deleted. ID: " + movieDeletedEvent.id;
      body = "A movie was updated!\n" + "ID: " + movieDeletedEvent.id;
      break;

    case MovieUpdatedEventType:
      const movieUpdatedEvent = <MovieUpdated>messageJsonBody;
      subject = "Movie Updated: " + movieUpdatedEvent.title;
      body = "A movie was updated!\n" + "ID: " + movieUpdatedEvent.id + "\n" + "Title: " + movieUpdatedEvent.title + "\n" + "Rating: " + movieUpdatedEvent.rating + "\n" + "Genres: " + movieUpdatedEvent.genres;
      break;

    default:
      throw new Error("An unknown movie event was received");
  }

  return [subject, body];
}
