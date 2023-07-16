resource "aws_lambda_function" "addJob" {
  filename         = "${path.module}/lambda_code/addJob.js.zip"
  function_name    = "addJob"
  role             = "${aws_iam_role.role.arn}"
  handler          = "addJob.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/addJob.js.zip")}"
}