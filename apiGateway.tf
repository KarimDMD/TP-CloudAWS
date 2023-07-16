resource "aws_apigatewayv2_api" "gateway" {
  name = "jobService"
  protocol_type = "HTTP"
}


# ----- INTEGRATION -----

resource "aws_apigatewayv2_integration" "intAddJob" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.addJob.invoke_arn
}

resource "aws_apigatewayv2_integration" "intGetJobDone" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.getJobDone.invoke_arn
}

resource "aws_apigatewayv2_integration" "intWorker" {
  api_id           = aws_apigatewayv2_api.gateway.id
  integration_type = "AWS_PROXY"
  connection_type = "INTERNET"
  integration_method = "POST"
  integration_uri =aws_lambda_function.worker.invoke_arn
}


# ----- ROUTE -----

resource "aws_apigatewayv2_route" "routeAddJob" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /addJob"
  target = "integrations/${aws_apigatewayv2_integration.intAddJob.id}"
}

resource "aws_apigatewayv2_route" "routeGetJobDone" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /getJobDone"
  target = "integrations/${aws_apigatewayv2_integration.intGetJobDone.id}"
}

resource "aws_apigatewayv2_route" "routeWorker" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /worker"
  target = "integrations/${aws_apigatewayv2_integration.intWorker.id}"
}


# ----- PERMISSION -----

# addJob

resource "aws_lambda_permission" "allow_lambda_invocation_addJob" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.addJob.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
  statement_id  = "AllowExecutionFromAPIGateway"
}

# getJobDone

resource "aws_lambda_permission" "allow_lambda_invocation_getJobDone" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.getJobDone.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
  statement_id  = "AllowExecutionFromAPIGateway"
}

# worker

resource "aws_lambda_permission" "allow_lambda_invocation_worker" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.worker.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
  statement_id  = "AllowExecutionFromAPIGateway"
}

resource "aws_lambda_event_source_mapping" "dynamodb_stream_mapping" {
  event_source_arn  = aws_dynamodb_table.jobTable.stream_arn
  function_name     = aws_lambda_function.worker.arn
  starting_position = "LATEST"
  batch_size        = 10
  maximum_batching_window_in_seconds = 60
}

resource "aws_lambda_permission" "dynamodb_stream_permission" {
  statement_id  = "AllowDynamoDBStreamAccess"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.worker.arn
  principal     = "dynamodb.amazonaws.com"
  source_arn    = aws_dynamodb_table.jobTable.stream_arn
}


# ----- STAGE -----

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "prod"
  auto_deploy = true
}


# ----- OUTPUT -----

output "api_endpoint" {
    value = aws_apigatewayv2_api.gateway.api_endpoint
}
output "stage_url" {
    value = aws_apigatewayv2_stage.prod.invoke_url
}