resource "aws_dynamodb_table" "movies-table" {
  name           = "Movies"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "ID"
  range_key      = "Title"

  attribute {
    name = "ID"
    type = "S"
  }

  attribute {
    name = "Title"
    type = "S"
  }
}
