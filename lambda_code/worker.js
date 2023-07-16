const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const s3 = new AWS.S3();

exports.handler = async (event) => {
  try {
    for (const record of event.Records) {
      if (record.dynamodb && record.dynamodb.NewImage) {
        const id = parseInt(record.dynamodb.NewImage.id.N, 10);
        const content = record.dynamodb.NewImage.content.S;
        const job_type = record.dynamodb.NewImage.job_type.S;

        if (job_type === "addToS3") {
          const contentJson = JSON.stringify(content);

          const params = {
            Bucket: "jobcontentbucket",
            Key: `${id}.json`,
            Body: contentJson,
          };

          await s3.putObject(params).promise();
          await updateProcessedStatus(id, "true");
        } else if (job_type === "addToDynamoDB") {
          const params = {
            TableName: "contentTable",
            Item: {
              id: id,
              content: content,
              job_type: job_type,
            },
          };

          await dynamodb.put(params).promise();
          await updateProcessedStatus(id, "true");
        }
      }
    }

    console.log("Processed");
  } catch (error) {
    console.log("Error: " + error);
    throw error;
  }
};

async function updateProcessedStatus(id, processed) {
  const params = {
    TableName: "jobTable",
    Key: { id: id },
    UpdateExpression: "SET isProcessed = :processed",
    ExpressionAttributeValues: { ":processed": processed },
  };

  try {
    await dynamodb.update(params).promise();
  } catch (error) {
    console.error("Error: " + error);
    throw error;
  }
}
