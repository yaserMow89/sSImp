provider "aws" {
  region = "eu-central-1"
}

// Many types of resources can be created for each provider
/* General syntax for creating a resource is:
resource "<provider>_<type>" "<name>" {
  [config...]
}
- type could be the type of the resource, like an ec2, s3, Application, user ...
*/

resource "aws_instance" "yaser-test" {
  ami           = "ami-0abe96a6773a37eb1"
  instance_type = "t3.micro"
  tags = {
    Name = "terraform-example"
  }
}

// Upon changes on an existing object --> Refreshing state
