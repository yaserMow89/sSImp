provider "aws" {
  region = "eu-central-1"
}

module "webserver_cluster" {
  source                 = "../../../modules/services/webserver-cluster"
  cluster_name           = "webserver-prod"
  db_remote_state_bucket = "terraform-up-and-running-state-sldfjslkad"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
  instance_type          = "t3.micro"
  min_size               = 2
  max_size               = 3
}
