# provider "aws" {
#   region = "eu-central-1"
# }

// Getting the vpc id
data "aws_vpc" "default" {
  default = true
}

// Getting the subnet id in the default vpc
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_template" "example" {
  image_id      = "ami-0abe96a6773a37eb1"
  instance_type = var.instance_type
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }))
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_template {
    id = aws_launch_template.example.id
  }
  max_size            = var.min_size
  min_size            = var.max_size
  vpc_zone_identifier = data.aws_subnets.default.ids
  //
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "{var.cluster_name}-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "example" {
  name               = "{var.cluster_name}-example"
  load_balancer_type = "application"
  // Use all the subnets in the default VPC
  subnets         = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}



resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = "HTTP"
  // Default resonse if the page doesn't exist
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_security_group" "alb" {
  name = "{var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.http_port
  to_port           = local.http_port
  cidr_blocks       = local.all_ips
  ipv6_cidr_blocks  = local.all_ips_v6
  self              = false
  description       = "Simple ingress for the lb"
  protocol          = local.tcp_protocol
}

resource "aws_security_group_rule" "allow_http_outband" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
  ipv6_cidr_blocks  = local.all_ips_v6
  prefix_list_ids   = []
  description       = "Simple egress for the lb"
  self              = false
}

resource "aws_security_group" "instance" {
  name = "{var.cluster_name}-instance"
  ingress = [
    {
      description      = "web"
      from_port        = var.server_port
      to_port          = var.server_port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

/*
  ____ _                 _               ___ _____
 / ___| |__   __ _ _ __ | |_ ___ _ __   / _ \___ /
| |   | '_ \ / _` | '_ \| __/ _ \ '__| | | | ||_ \
| |___| | | | (_| | |_) | ||  __/ |    | |_| |__) |
 \____|_| |_|\__,_| .__/ \__\___|_|     \___/____/
                  |_|
*/

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

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-sldfjslkad"
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "eu-central-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}


/*
Declaring the `terraform_remote_state` resource
You delcare the remote state as below; and then you can see how it is called in the:
`resource "aws_launch_template" "example"
You can see that it is called in the user_data in that resource with format:
`data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>`
For example there we are calling the `address` and `port` attributes
*/
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "{var.db_remote_state_bucket}"
    key    = "{var.db_remote_state_key}"
    region = "eu-central-1"
  }
}

/*
              _             ___  _  _
  ___| |__   __ _ _ __ | |_ ___ _ __ / _ \| || |
 / __| '_ \ / _` | '_ \| __/ _ \ '__| | | | || |_
| (__| | | | (_| | |_) | ||  __/ |  | |_| |__   _|
 \___|_| |_|\__,_| .__/ \__\___|_|   \___/   |_|
                 |_|
*/


/*
How to have different envs like stage and prod
  - Of course you can copy and paste all the code, all the time and run `tf apply`
  - A better option would be tf modules
*/

/*
What is a tf module
  - Any set of tf config files in a folder could be a module
- running `tf apply` directly on a module is referred to as root module
*/

/*
First thing we have remove the provider block at the beginning; as it should be configured in teh root modules and not in the reusable modules
*/

/*
The module can be called upon with
```
module <NAME> {
  source = "<SOURCE>"
  [config ...]
}
```

- we can call webserver module in the main webserver file for example which is at `sSImp/Terraform/terraformUpAndRunning/chapter03/02_remote_state_data_source/stage/services/webserver-cluster/main.tf`
*/

/*
Avoid hardcoding the names in modules; otherwise you will get conflict errors if you run it in the same aws account
- To resolve this you should add configurable inputs to the module
- Modules can have parameters in tf same as programming languages
- They can be defined using input-variables
- Then you can change them in the module to read them
*/

/*
Module locals
- What if you have some values that are only for that module, and you are not going to change them per your workflows, but still you want to be able to maintain them easily
- Values such as the load_balancer port number, which is also used in a few other places; the value is 80 but it is in multiple places.
- This can be acheived with the locals; you define it and then address it with `local.<NAME>`; `<NAME>` is the variable's name
- Obviously they are only visible within the module and not out of it
- They can't be overriden also from outside the module
*/

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
  all_ips_v6   = ["::/0"]
}


/*
Module Outputs
- Assume you want are expecting a return parameter from a module upon calling it
- This is where module outputs come into play
- Like you want to have `aws_autoscaling_schedule` resource only in your prod
  - The only way to do it is through the module which is going to be applied to both PROD and STAGE
  - If you call it only from the PROD webserver, you would require the `autoscaling_group_name` which already sits inside the module
    - Good use of Module outputs can be made here
- You can add the asg name as an output variable in the module
- The module output variables can be accessed using the following syntax: `module.<MODULE_NAME>.<OUTPUT_NAME>`
*/
/*
Module Gotchas
- file paths and inline blocks; each of them is discussed below with details
*/

/*
- File Path
- `templatefile` should be given a relative path
- By default tf interprets the path relative to the current working directory
- So if you have the `user-data.sh` in the module, but you are trying to call on the module from another directory by running `tf apply` it won't be able to find the `user-data.sh` since it is not in the same directory which you are running the `tf apply` from
- To solve this you can use an expression known as path reference, which is of form `path.<TYPE>`
- tf supports following types of path references
  - `path.module`
    - Returnes the filesystem path of the module where the expression is defined
  - `path.root`
    - Returns the filesystem path of the root module
  - `path.cwd`
    - Returns the filesystem path of the current working directoy; it is useful in advacned usecases of tf, where you run it from a directory which is not the root module directory
- for the `user-data.sh` we need the path relative to itself, so we should use the `path.module`
  - it is defined as following:
  ```
  templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })
  ```
*/

/*
Inline Blocks
- The configuration for some tf resources, can be either as separate blocks or as inline blocks
- An inline block is an argument set within a resource file, as:
```tf
reresource "XXX" "YYY" {
  <NAME> {
    [CONFIG... ]
  }
}
```
- Here `<NAME>` is the name of the inline block, for example the ingress and egress, while defining the security group resource
- If you try to use a mix of both, it will fail due to conflicting errors; only one type should be used
- But a good practice is to use separate resources while creating a module
  - Makes them more flexible, since they can be added anywhere
  - For example in our current `aws_security_group` resource we are using inline blocks, and this doesn't give the option to add additional ingress or engress rules from outside the module
  ```
  resource "aws_security_group" "alb" {
    ingress = [
      {
        [CONFIG...]
      }
    ]
    egress = [
      {
        [CONFIG...]
      }
    ]
  }
  ```
- You can see in the module how we have modified it now, with adding separate resources as security group rules, it is changed like this:
```tf
resource "aws_security_group" "alb" {
  name = "{var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.http_port
  to_port           = local.http_port
  cidr_blocks       = local.all_ips
  ipv6_cidr_blocks  = local.all_ips_v6
  self              = false
  description       = "Simple ingress for the lb"
  protocol          = local.tcp_protocol
}

resource "aws_security_group_rule" "allow_http_outband" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
  ipv6_cidr_blocks  = local.all_ips_v6
  prefix_list_ids   = []
  description       = "Simple egress for the lb"
  self              = false
}
```
- Dont forget to export the id of the security group in the outputs.tf file
- Now assume you want to expose an extra port in the staging env for testing, you can simply create `aws_security_group_rule` resrouce and attach it to the security group; same as you do it for the module itself
*/

/*
Module Versioning

- Version modules to avoid changes being deployed to stage from being deployed to the prod
- It would make sense to have module versions
- We have used `source` so far for declaring modules, but terraform supports other module sources too; such as git URLs, mercurial URLs, and arbitrary HTTP URLs
- The easiest way to create a versioned module, is to put the code for the module in a separate git repo and to set the source parameter to the repos URL
- With this means you will have your tf code across two repos
  - Modules
  - live
    - This includes your live infras in each env, like stage, prode, and etc...
- The git repo can be addressed with the same `source` parameter as below:
```
source                 = "github.com/yaserMow89/modules//services/webserver-cluster?ref=v0.0.1"
```
  - Note how the `ref` parameter allows you to select the verion
    - This can also b edone based on branch name and also sha1 hash
    - Tags are advised, since they are human friendly and readable; and also they point to commit hashes
      - You can follow the following format for tagging `MAJOR.MINOR.PATCH`
        - MAJOR --> Incompatible API Changes
        - MINOR --> new backward compatbile functionality
        - PATCH --> backward compatible bug fixes
- After adding git urls you need to do another `tf init` to get the modules from the git url
- This way wheneven you are changing the module code, you can push it with a new tag and make sure you only use it in staging and after doing some tests, you can use it in the PROD then
*/
