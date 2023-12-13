locals {
  filename = strcontains(var.runtime, "node") ? "index.mjs" : "main"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./modules/lambda/init_code/${local.filename}"
  output_path = "${var.name}_lambda_function_payload.zip"
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    sid = "AllowLambdaToAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

  }

  statement {
    sid = "AllowLambdaToWriteLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
