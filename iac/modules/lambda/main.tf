locals {
  filename = strcontains(var.runtime, "node") ? "index.js" : "main"
}

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
  name               = "${var.name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./modules/lambda/init_code/${local.filename}"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda.output_path
  function_name = var.name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler
  runtime       = var.runtime
}
