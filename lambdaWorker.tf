resource "aws_lambda_function" "worker" {
  filename         = "${path.module}/lambda_code/worker.js.zip"
  function_name    = "worker"
  role             = "${aws_iam_role.role.arn}"
  handler          = "worker.handler"
  runtime          = "nodejs14.x"
  source_code_hash = "${filebase64sha256("${path.module}/lambda_code/worker.js.zip")}"
}