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

module "process_movie_update_events_lambda" {
  source  = "./modules/lambda"
  name    = "process-movie-update-events"
  runtime = "nodejs20.x"
  handler = "index.handler"
}

resource "aws_lambda_event_source_mapping" "movie_update_events_trigger" {
  event_source_arn = aws_sqs_queue.movie_updates_queue.arn
  function_name    = module.process_movie_update_events_lambda.arn

  filter_criteria {
    filter {
      pattern = jsonencode({
        attributes = {
          Type : ["MovieCreated", "MovieDeleted", "MovieUpdated"]
        }
      })
    }
  }
}
