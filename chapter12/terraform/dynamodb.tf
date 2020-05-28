resource "aws_dynamodb_table" "movies" {
  name           = "Movies"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  global_secondary_index {
    name               = "MovieTitleIndex"
    hash_key           = "title"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  tags = {
    Stack = "Watchlist"
  }
}

resource "aws_dynamodb_table" "favorites" {
  name           = "Favorites"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  global_secondary_index {
    name               = "MovieTitleIndex"
    hash_key           = "title"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  tags = {
    Stack = "Watchlist"
  }
}