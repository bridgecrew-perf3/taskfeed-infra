resource "aws_dynamodb_table" "User" {
  name           = "User"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "userame"

  attribute {
    name = "userame"
    type = "S"
  }
}

resource "aws_dynamodb_table" "Todo" {
  name           = "Todo"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "owner"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "owner"
    type = "S"
  }
}
