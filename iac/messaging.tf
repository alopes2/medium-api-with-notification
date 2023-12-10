resource "aws_sns_topic" "movie_updates" {
  name = "movie-updates-topic"
}

resource "aws_sqs_queue" "movie_updates_queue" {
  name = "movie-updates-queue"
}

resource "aws_sns_topic_subscription" "movie_updates_sqs_target" {
  topic_arn = aws_sns_topic.movie_updates.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.movie_updates_queue.arn
}
