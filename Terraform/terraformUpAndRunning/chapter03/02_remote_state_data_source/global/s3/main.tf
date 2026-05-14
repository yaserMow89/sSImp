provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-up-and-running-state-sldfjslkad"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket                  = aws_s3_bucket.terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

/*_             ___  _  _
  ___| |__   __ _ _ __ | |_ ___ _ __ / _ \| || |
 / __| '_ \ / _` | '_ \| __/ _ \ '__| | | | || |_
| (__| | | | (_| | |_) | ||  __/ |  | |_| |__   _|
 \___|_| |_|\__,_| .__/ \__\___|_|   \___/   |_|
                 |_|
*/
