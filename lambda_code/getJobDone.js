const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const params = {
      TableName: "jobTable",
      FilterExpression: "isProcessed = :processed",
      ExpressionAttributeValues: { ":processed": "true" },
    };

    const result = await dynamodb.scan(params).promise();

    const response = {
      statusCode: 200,
      body: JSON.stringify(result.Items, null, 2),
    };

    return response;
  } catch (error) {
    const response = {
      statusCode: 500,
      body: JSON.stringify({
        message: `Erreur lors du traitement : ${error.message}`,
      }),
    };

    return response;
  }
};
