# ----- ROLE -----

resource "aws_iam_role" "role" {
  name = "LambdaWriteToDBRole"

  assume_role_policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    POLICY
}

# ----- POLICY -----

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBPolicy"
  description = "Permissions to write and read DynamoDB table"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FullDynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:UpdateItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": [
        "${aws_dynamodb_table.jobTable.arn}",
        "${aws_dynamodb_table.contentTable.arn}"
      ]
    },
    {
      "Sid": "AllObjectActions",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.contentBucket.arn}/*"
      ]
    },
    {
      "Sid": "DynamoDBStreamAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ],
      "Resource": "${aws_dynamodb_table.jobTable.stream_arn}"
    }
  ]
}
POLICY
}

# ----- ATTACHMENT -----

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}