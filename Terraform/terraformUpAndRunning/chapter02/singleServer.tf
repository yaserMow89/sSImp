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

/* <<-EOF and EOF are terraform's heredoc syntax
      This basically allows to have multiple lines of strings
      without having to enter the \n */
/* Terraform Expressions
       - Anything that returns a value
       - Many types, but one which we are interested in here:
        - Reference expression: Allows to access values from other parts of code
          - For example to use the security group id in our instance resource block
            we would use a resource attribute reference which uses the following syntax
              `<PROVIDE>_<TYPE>.<NAME>.<ATTRIBUTE>*/

/*Dependency graph
  - Upon the declaration of references into the resources, you are creaging implicit dependency
    - These dependencies are parsed by Terraform, to build a dependency graph
      This is eventually used to determine which resources should be build first*/

/*terraform graph can be used to show this dependency graph and this can be later turned into
  depicted graphs using the GraphvizOnline*/

/*Variables in terraform:
  Different ways to declare them:
    in the command line using the optoin `-var`
    via a file using the `-var-file` option
    via env var using `TF_VAR_<variable_name>
    If no variable is defined, it will fall back to default, else will prompt user for entering it
  attributes:
    description
    default
      default value
    type --> these are supported: string, number, bool, list, map, set, object, tuple and any
      default is any
    validation
      validation checks on the variable
    sensitive
      it is like no_log: true in Ansible
      it will not be logged
  examples:
    can combine type constraints
      variable "list_numeric_example" {
        description = "An example of numeric list"
        type = list(number)
        default = [1,3,2]
    can create more complicated ones like this one with the object type
      variable "object_var_example" {
        description = "Object type var"
        type = object ({
          name = string
          age = number
          tags = list (string)
          enabled = bool
        })
        default = {
          name = test
          age = 23
          tags = ["a", "b", "c"]
          enabled = true
        }
      }
to address a var you can use `var.<VARIABLE_NAME>`
to address inside of a string literal, you need to interpolate it, using syntax:
`"${...}"*/


/*
There are also output vars same as input vars
This can be any terraform expression that you would like to output
Attribute:
  - description
  - sensitive
  - depends_on
    In case you have to direct terraform the dependency of the var
You can also only see all the outputs by `terraform output`
You can sepecify output with `terraform output <OUTPUT_NAM>`
*/

/*
Data Sources
- Read only info that is fetched from the provider
- The fetched data is provided to the code
- Each provider exposes a variety of data soruces
- AWS for example provides the followings:
  - VPC data, subnet data, AMI IDs, IP address ranges, current user's identity and ...
- Syntax is similar to a resource
```
data "<PROVIDER>_<TYPE> <NAME>"
  [config ...]
```
  - TYPE is data source type; like vpc
  - NAME identifier to be used in the code, to refer to this data source
  - CONFIG is parameters specific to that data source -- they are typically search filters, telling provider exactly what you want
- To get the data of a data soruce you go with `data.<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>`
- They can also be combined to lookup other data sources, like here we only get the subnets
```
data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```
*/

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
# output "public_ip" {
#   value       = aws_instance.example.public_ip
#   description = "public ip address of the instance"
# }
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

// Having the launch configurator this is not necessary anymore
# resource "aws_instance" "example" {
#   ami                         = "ami-0abe96a6773a37eb1"
#   instance_type               = "t3.micro"
#   user_data                   = <<-EOF
#               #!/bin/var/env bash
#               echo "Yooo, World" > index.xhtml
#               nohup busybox httpd -f -p ${var.server_port} &
#               EOF
#   vpc_security_group_ids      = [aws_security_group.instance.id]
#   user_data_replace_on_change = true

#   tags = {
#     Name = "terraform-example"
#   }
# }

// aws LC does not support tags, but they can be provided with the AG
// Apparently launch configuration is not supported with accounts created after a specific date
// I had to switch to launch template instead
# resource "aws_launch_configuration" "example" {
#   image_id      = "ami-0abe96a6773a37eb1"
#   instance_type = "t3.micro"
#   user_data     = <<-EOF
#               #!/bin/bash
#               echo "hello world!" > index.xhtml
#               nohup busybox httpd -f -p ${var.server_port} &
#               EOF

#   lifecycle {
#     create_before_destroy = true
#   }
# }
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
/*
ASG uses a reference to the lc with the configuration name
LCs are immutable, so if you change any of it's parameters terraform will try to replace it
Normally it means deleting the old resources and creating replacement
But because the ASG has a reference to the old one, terraform won't be able to delete it
`lifecycle` is supported on every terraform resource, as it can help us here
  - They support different settings
  - A particularly useful settings is `create_before_destroy`
    - This will first the replacement resource, first and update all the references to it
      - So it goes in invereted order, instead of trying to delete the LC, which would fail, because
        asg is pointing at it, it will first create and then try to delete
*/
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

// Target EC2 instances can be attached via a static list with aws_lb_target_group_attachement
//  - But this could change, since instances could go down and come up with ASG
//
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
/*
We also need a Load balancer
- Can be one of the types: Application LB, Network LB or Classic LB
- They have different components, like:
  - Listener: port on which it is listening
  - Listener rule: send requests to matching paths
  - target groups: LB also checks for their health
- AWS automatically scales up/down the LBs based on the traffic
- They consist of multiple servers, that can run in separate subnets
- AWS handles the failover also if one goes down
- To use one
  - First, we should create one
  - define a listener for the created lb
*/
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

/*
By default all aws resoruces including albs, don't allow in/out trrafic, a security group should be created specifically for this ALB
- Should allow incoming requests on port 80
- Should allow outgoing on all ports, so ALB can perform health checks
*/
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

// Upon changes on an existing object --> Refreshing state
