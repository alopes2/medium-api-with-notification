module "get_movie_lambda" {
  source  = "./modules/lambda"
  name    = "get-movie"
  runtime = "nodejs20.x"
  handler = "index.handler"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.get_movie_lambda.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = module.get_movie_lambda.arn
}

resource "aws_api_gateway_rest_api" "movies_api" {
  name = "movies-api"
}

resource "aws_api_gateway_deployment" "movies_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.movies_api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.movies_resource.id,
      aws_api_gateway_method.movie_get_method.id,
      aws_api_gateway_integration.movie_get_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "live" {
  deployment_id = aws_api_gateway_deployment.movies_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.movies_api.id
  stage_name    = "live"
}

resource "aws_api_gateway_resource" "movies_resource" {
  parent_id   = aws_api_gateway_rest_api.movies_api.root_resource_id
  path_part   = "movies"
  rest_api_id = aws_api_gateway_rest_api.movies_api.id
}

resource "aws_api_gateway_method" "movie_get_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.movies_resource.id
  rest_api_id   = aws_api_gateway_rest_api.movies_api.id
}

resource "aws_api_gateway_integration" "movie_get_integration" {
  http_method             = aws_api_gateway_method.movie_get_method.http_method
  integration_http_method = "POST" # Lambda functions can only be invoked via POST
  resource_id             = aws_api_gateway_resource.movies_resource.id
  rest_api_id             = aws_api_gateway_rest_api.movies_api.id
  type                    = "AWS_PROXY"
  uri                     = module.get_movie_lambda.invoke_arn
}
