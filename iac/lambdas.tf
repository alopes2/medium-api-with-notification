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

module "email_notification_lambda" {
  source  = "./modules/lambda"
  name    = "email-notification"
  runtime = "nodejs20.x"
  handler = "index.handler"
  environment_variables = {
    "SOURCE_EMAIL"      = "${var.source_email}"
    "DESTINATION_EMAIL" = "${var.destination_email}"
  }
}

resource "aws_lambda_event_source_mapping" "email_notification_trigger" {
  event_source_arn = aws_sqs_queue.movie_updates_queue.arn
  function_name    = module.email_notification_lambda.arn
  enabled          = true

  # If you set filters,the Lambda Event Filter deletes messages from the Queue
  # when they don’t match the filter criteria.
  # filter_criteria {
  #   filter {
  #     pattern = jsonencode({
  #       attributes = {
  #         Type : ["MovieCreated", "MovieDeleted", "MovieUpdated"]
  #       }
  #     })
  #   }
  # }
}
