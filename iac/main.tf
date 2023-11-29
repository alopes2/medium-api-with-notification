module "get_movies_lambda" {
  source  = "./modules/lambda"
  name    = "GetMoviesLambda"
  runtime = "nodejs20.x"
  handler = "index.handler"
}
