const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  try {
    const { id, content, job_type } = event;

    const params = {
      TableName: "jobTable",
      Item: {
        id: id,
        content: content,
        job_type: job_type,
        isProcessed: "false",
      },
    };

    await dynamodb.put(params).promise();

    const response = {
      statusCode: 200,
      body: JSON.stringify({
        message: "Données insérées avec succès dans la table jobTable.",
      }),
    };

    return response;
  } catch (error) {
    const response = {
      statusCode: 500,
      body: JSON.stringify({
        message: `Erreur lors de l'insertion des données dans la table jobTable : ${error.message}`,
      }),
    };

    return response;
  }
};
