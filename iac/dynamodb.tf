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

resource "aws_dynamodb_table_item" "the_matrix" {
  table_name = aws_dynamodb_table.movies-table.name
  hash_key   = aws_dynamodb_table.movies-table.hash_key
  range_key  = aws_dynamodb_table.movies-table.range_key

  item = <<ITEM
  {
    "ID": {"S": "1"},
    "Title": {"S": "The Matrix"},
    "Genres": {"SS": [
        "Action",
        "Sci-Fi"
      ]
    },
    "Rating": {"N": "8.7"}
  }
  ITEM
}

resource "aws_dynamodb_table_item" "scott_pilgrim" {
  table_name = aws_dynamodb_table.movies-table.name
  hash_key   = aws_dynamodb_table.movies-table.hash_key
  range_key  = aws_dynamodb_table.movies-table.range_key

  item = <<ITEM
  {
    "ID": {"S": "2"},
    "Title": {"S": "Scott Pilgrim vs. the World"},
    "Genres": {"SS": [
          "Action",
          "Comedy"
        ]
      },
    "Rating": {"N": "7.5"}
  }
  ITEM
}

resource "aws_dynamodb_table_item" "star_wars" {
  table_name = aws_dynamodb_table.movies-table.name
  hash_key   = aws_dynamodb_table.movies-table.hash_key
  range_key  = aws_dynamodb_table.movies-table.range_key

  item = <<ITEM
  {
    "ID": {"S": "3"},
    "Title": {"S": "Star Wars: Episode IV - A New Hope"},
    "Genres": {"SS": [
          "Action",
          "Adventure",
          "Sci-Fi",
          "Fantasy"
        ]
      },
    "Rating": {"N": "8.6" }
  }
  ITEM
}

resource "aws_dynamodb_table_item" "star_wars_v" {
  table_name = aws_dynamodb_table.movies-table.name
  hash_key   = aws_dynamodb_table.movies-table.hash_key
  range_key  = aws_dynamodb_table.movies-table.range_key

  item = <<ITEM
  {
    "ID": {"S": "4"},
    "Title": {"S": "Star Wars: Episode V - The Empire Strikes Back"},
    "Genres": {"SS": [
          "Action",
          "Adventure",
          "Sci-Fi",
          "Fantasy"
        ]
      },
    "Rating": {"N": "8.7" }
  }
  ITEM
}
