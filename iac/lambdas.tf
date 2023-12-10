# Lambdas
module "get_movie_lambda" {
  source        = "./modules/lambda"
  name          = "get-movie"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  init_filename = "index.mjs"
}

module "create_movie_lambda" {
  source        = "./modules/lambda"
  name          = "create-movie"
  runtime       = "go1.x"
  handler       = "main"
  init_filename = "main"
}

module "delete_movie_lambda" {
  source        = "./modules/lambda"
  name          = "create-movie"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  init_filename = "index.mjs"
}
