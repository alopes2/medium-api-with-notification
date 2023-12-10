# Lambdas
module "get_movie_lambda" {
  source  = "./modules/lambda"
  name    = "get-movie"
  runtime = "nodejs20.x"
  handler = "index.handler"
}

module "create_movie_lambda" {
  source  = "./modules/lambda"
  name    = "create-movie"
  runtime = "go1.x"
  handler = "main"
}

module "delete_movie_lambda" {
  source  = "./modules/lambda"
  name    = "delete-movie"
  runtime = "nodejs20.x"
  handler = "index.handler"
}

module "update_movie_lambda" {
  source  = "./modules/lambda"
  name    = "update-movie"
  runtime = "go1.x"
  handler = "main"
}
