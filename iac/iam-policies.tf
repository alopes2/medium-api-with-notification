data "aws_iam_policy_document" "get_movie_item" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
    ]

    resources = [
      aws_dynamodb_table.movies-table.arn
    ]
  }
}

resource "aws_iam_policy" "get_movie_item" {
  name        = "get_movie_item"
  path        = "/"
  description = "IAM policy allowing GET Item on Movies DynamoDB table"
  policy      = data.aws_iam_policy_document.get_movie_item.json
}

resource "aws_iam_role_policy_attachment" "allow_getitem_get_movie_lambda" {
  role       = module.get_movie_lambda.role_name
  policy_arn = aws_iam_policy.get_movie_item.arn
}
