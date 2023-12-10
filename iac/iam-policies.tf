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

data "aws_iam_policy_document" "put_movie_item" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:PutItem",
    ]

    resources = [
      aws_dynamodb_table.movies-table.arn
    ]
  }
}

data "aws_iam_policy_document" "delete_movie_item" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DeleteItem",
    ]

    resources = [
      aws_dynamodb_table.movies-table.arn
    ]
  }
}

data "aws_iam_policy_document" "update_movie_item" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem",
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

resource "aws_iam_policy" "put_movie_item" {
  name        = "put_movie_item"
  path        = "/"
  description = "IAM policy allowing PUT Item on Movies DynamoDB table"
  policy      = data.aws_iam_policy_document.put_movie_item.json
}

resource "aws_iam_policy" "delete_movie_item" {
  name        = "delete_movie_item"
  path        = "/"
  description = "IAM policy allowing DELETE Item on Movies DynamoDB table"
  policy      = data.aws_iam_policy_document.delete_movie_item.json
}

resource "aws_iam_policy" "update_movie_item" {
  name        = "update_movie_item"
  path        = "/"
  description = "IAM policy allowing UPDATE Item on Movies DynamoDB table"
  policy      = data.aws_iam_policy_document.update_movie_item.json
}

resource "aws_iam_role_policy_attachment" "allow_getitem_get_movie_lambda" {
  role       = module.get_movie_lambda.role_name
  policy_arn = aws_iam_policy.get_movie_item.arn
}

resource "aws_iam_role_policy_attachment" "allow_putitem_create_movie_lambda" {
  role       = module.create_movie_lambda.role_name
  policy_arn = aws_iam_policy.put_movie_item.arn
}

resource "aws_iam_role_policy_attachment" "allow_deleteitem_delete_movie_lambda" {
  role       = module.delete_movie_lambda.role_name
  policy_arn = aws_iam_policy.delete_movie_item.arn
}

resource "aws_iam_role_policy_attachment" "allow_updateitem_update_movie_lambda" {
  role       = module.update_movie_lambda.role_name
  policy_arn = aws_iam_policy.update_movie_item.arn
}
