data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "get_movies" {
  function_name = "GetMoviesLambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  runtime = "nodejs20.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}