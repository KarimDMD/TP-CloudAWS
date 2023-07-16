resource "aws_dynamodb_table" "jobTable" {
  name              = "jobTable"
  billing_mode      = "PAY_PER_REQUEST"
  stream_enabled    = true
  stream_view_type  = "NEW_AND_OLD_IMAGES"
  hash_key          = "id"

  attribute {
    name = "id"
    type = "N"
  }
  attribute {
    name = "content"
    type = "S"
  }
  attribute {
    name = "job_type"
    type = "S"
  }
  attribute {
    name = "isProcessed"
    type = "S"
  }

  global_secondary_index {
    name               = "jobTypeIndex"
    hash_key           = "job_type"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "contentIndex"
    hash_key           = "content"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

   global_secondary_index {
    name               = "isProcessedIndex"
    hash_key           = "isProcessed"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}

resource "aws_dynamodb_table" "contentTable" {
  name           = "contentTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "N"
  }
  attribute {
    name = "content"
    type = "S"
  }
  attribute {
    name = "job_type"
    type = "S"
  }

  global_secondary_index {
    name               = "jobTypeIndex"
    hash_key           = "job_type"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }

  global_secondary_index {
    name               = "contentIndex"
    hash_key           = "content"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}
