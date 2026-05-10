provider "aws" {
  region = "eu-central-1"
}

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

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

resource "aws_launch_template" "example" {
  image_id      = "ami-0abe96a6773a37eb1"
  instance_type = "t3.micro"
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "hello world!" > index.xhtml
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_template {
    id = aws_launch_template.example.id
  }
  max_size            = 10
  min_size            = 2
  vpc_zone_identifier = data.aws_subnets.default.ids
  //
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"
  tag {
    key                 = "Name"
    value               = "terraform-ags-example"
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
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  // Use all the subnets in the default VPC
  subnets         = data.aws_subnets.default.ids
  security_groups = [aws_security_group.alb.id]
}

output "alb" {
  value       = aws_lb.example.dns_name
  description = "PUBLIC DNS NAME"
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
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
  name = "terraform-example-alb"
  ingress = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "Simple ingress for the lb"
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      description      = "Simple egress for the lb"
    }
  ]
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
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
