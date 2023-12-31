# API Gateway
resource "aws_api_gateway_rest_api" "movies_api" {
  name = "movies-api"
}

resource "aws_api_gateway_deployment" "movies_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.movies_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.movies_root_resource.id,
      aws_api_gateway_resource.movie_resource.id,
      module.get_movie_method.id,
      module.get_movie_method.integration_id,
      module.create_movie_method.id,
      module.create_movie_method.integration_id,
      module.delete_movie_method.id,
      module.delete_movie_method.integration_id,
      module.update_movie_method.id,
      module.update_movie_method.integration_id,
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

resource "aws_api_gateway_resource" "movies_root_resource" {
  parent_id   = aws_api_gateway_rest_api.movies_api.root_resource_id
  path_part   = "movies"
  rest_api_id = aws_api_gateway_rest_api.movies_api.id
}

resource "aws_api_gateway_resource" "movie_resource" {
  parent_id   = aws_api_gateway_resource.movies_root_resource.id
  path_part   = "{movieID}"
  rest_api_id = aws_api_gateway_rest_api.movies_api.id
}

module "get_movie_method" {
  source               = "./modules/rest-api-method"
  api_id               = aws_api_gateway_rest_api.movies_api.id
  http_method          = "GET"
  resource_id          = aws_api_gateway_resource.movie_resource.id
  resource_path        = aws_api_gateway_resource.movie_resource.path
  integration_uri      = module.get_movie_lambda.invoke_arn
  lambda_function_name = module.get_movie_lambda.name
  region               = var.region
  account_id           = var.account_id
}


module "create_movie_method" {
  source               = "./modules/rest-api-method"
  api_id               = aws_api_gateway_rest_api.movies_api.id
  http_method          = "POST"
  resource_id          = aws_api_gateway_resource.movies_root_resource.id
  resource_path        = aws_api_gateway_resource.movies_root_resource.path
  integration_uri      = module.create_movie_lambda.invoke_arn
  lambda_function_name = module.create_movie_lambda.name
  region               = var.region
  account_id           = var.account_id
}

module "delete_movie_method" {
  source               = "./modules/rest-api-method"
  api_id               = aws_api_gateway_rest_api.movies_api.id
  http_method          = "DELETE"
  resource_id          = aws_api_gateway_resource.movie_resource.id
  resource_path        = aws_api_gateway_resource.movie_resource.path
  integration_uri      = module.delete_movie_lambda.invoke_arn
  lambda_function_name = module.delete_movie_lambda.name
  region               = var.region
  account_id           = var.account_id
}

module "update_movie_method" {
  source               = "./modules/rest-api-method"
  api_id               = aws_api_gateway_rest_api.movies_api.id
  http_method          = "PUT"
  resource_id          = aws_api_gateway_resource.movie_resource.id
  resource_path        = aws_api_gateway_resource.movie_resource.path
  integration_uri      = module.update_movie_lambda.invoke_arn
  lambda_function_name = module.update_movie_lambda.name
  region               = var.region
  account_id           = var.account_id
}
