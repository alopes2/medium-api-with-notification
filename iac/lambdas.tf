# Lambdas
module "get_movie_lambda" {
  source  = "./modules/lambda"
  name    = "get-movie"
  runtime = "nodejs20.x"
  handler = "index.handler"
}
