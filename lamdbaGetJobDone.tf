resource "aws_lambda_function" "getJobDone" {
  filename         = "${path.module}/lambda_code/getJobDone.js.zip"
  function_name    = "getJobDone"
  role             = "${aws_iam_role.role.arn}"
  handler          = "getJobDone.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/getJobDone.js.zip")}"
}