import { SQSEvent, Context, SQSHandler, SQSRecord } from "aws-lambda";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

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

    const sourceEmail = process.env.SOURCE_EMAIL || ""; // Ideally it needs to be validated and logged if not set
    const destinationEmail = process.env.DESTINATION_EMAIL || ""; // Ideally it needs to be validated and logged if not set

    console.log(sourceEmail)
    console.log(destinationEmail)

    const command = new SendEmailCommand({
      Source: sourceEmail,
      Destination: {
        ToAddresses: [destinationEmail]
      },
      Message: {
        Body: {
          Text: {
            "Charset": "UTF-8",
            "Data": message.body
          }
        },
        Subject: {
          "Charset": "UTF-8",
          "Data": `${eventType.replace(/([a-z])([A-Z])/, '$1 $2')}`
        }
      }
    });

    await client.send(command);

    console.log(`Processed ${eventType} message ${message.body}`);
  } catch (err) {
    console.error("An error occurred");
    console.error(err);
  }
}
