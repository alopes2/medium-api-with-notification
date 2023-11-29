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


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./configurations/init_lambda_functions/get_movies_init.js"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "get_movies" {
  filename      = data.archive_file.lambda.output_path
  function_name = "GetMoviesLambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handlerTwo"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"


  lifecycle {
    ignore_changes = [filename]
  }

  environment {
    variables = {
      foo = "bar"
    }
  }
}
