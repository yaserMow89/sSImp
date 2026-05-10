// Terraform state
/*
- Terraform state file --> on each run
- File is `terraform.tfstate`
- It contains mapping between resources in the config files and real world state of the resources
- The output of the `plan` command is a diff of your config files and the actualy resources
- How to manage state file in a team
  - Shared location where all team members can access it
  - Locking the file to avoid race conditions
  - Isolaitng state files for different envs like prod and dev
- Where to store the state file
  - Not Version control
  - Terraform backend:
    - Default backend: local disk; what we have been doing all this time
    - Remote backends: are available; like aws s3, azure storage, google and etc...
      - Manual error
        - on every `plan` or `apply` the state file will be loaded automatically by terraform
      - Locking
        - Natively supported by most of them
      - Secrets
        - Encryption supported
        - Access permissions can be defined on them
      - AWS S3 is a good choice if you are using aws

*/

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state-jskdweafassss"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
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

/*
To configure terraform to store the state file in S3 we add a `backend` configuration block to the code
The format is
```
terraform {
  backend "<BACKEND_NAME>"
  [config...]
}
```
- After declaring the backend for the state file, you have to run the init command again
  - The command not only downloads the provider, but also configures the terraform backend
- With the following backend in place, now before running tf commands, it will pull the latest state from this bucket
- After running command it pushes the latest state
- Limiatations
  - chicken and egg for creation the s3 bucket
    - To add the remote backend:
      1. Write the s3 and dynamodb with a local state file
      2. Add remote backend in the second step
    - To remove the remote backend
      1. Remove backend config and do `tf init` to get the state on local disk
      2. run `tf destroy` to delete the s3 bucket
  - Backed block doesn't allow the use of any variables or references
    - The backend block should be separately defined for every module you have
    - The key should be unique, otherwise it overwrites
    - One sulotion to avoid the copy/paste is to define a var file with the repetitive vars (`backend.hcl`), and only add the necessarry vars to the backend-config; this way upon running `tf init` all the variables are going to be red from the vars file
    - terragrunt can also help here for managing the backend configuration
*/

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-jskdweafas"
    // The filepath where within the s3 bucket terraform should store the state file
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
    // The dynamodb table to use for locking
    use_lockfile = true
    // Encrypting the state file in the s3 bucket
    // We have already enabled encryption on the bucket, this is going to act as a second layer
    encrypt = true
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the s3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

/*
State File Isolation
- If all the code is managed with one state file, it could break the entier infra with a single mistake
- Separate envs make isolation
- You should have bulkheads
- Two ways in which isolation could happen
  1. Via workspaces
    - Quick, isolated test on the same config
  2. Via file layout
    - For PROD
  - Each of them will be studied in details below
*/

/*
Isolation via WORKSPACES
- Single workspace at start named, default
- Workspaces can be done with `terraform workspace`
- New can be created with `tf workspace new <NAME>`
- You can list them with `tf workspace list`
- You can switch `tf workspace select <NAME>`
- This will create an `env` folder in your s3 bucket and under this will create a separate directory for each of your workspaces
- So basically switching the worksapce is switching the path for the state file
- You can also change how module behaves based on the workspace
- States have a few drawbacks
  - Same backend storage for spaces
  - Workspaces are not visible in the code
  - Fairly error prone
*/
/*
Isolation via FILE LAYOUT
- To achieve full isolation
- can be done at env level or even at component level
*/
