
provider "aws" {
  region = "eu-central-1"
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t4g.micro"
  skip_final_snapshot = true
  db_name             = "example_database"
  username            = var.db_username
  password            = var.db_password
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-sldfjslkad"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

/*
      _                 _             ___  _  _
  ___| |__   __ _ _ __ | |_ ___ _ __ / _ \| || |
 / __| '_ \ / _` | '_ \| __/ _ \ '__| | | | || |_
| (__| | | | (_| | |_) | ||  __/ |  | |_| |__   _|
 \___|_| |_|\__,_| .__/ \__\___|_|   \___/   |_|
                 |_|
 */
