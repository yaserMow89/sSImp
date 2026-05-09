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
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "public ip address of the instance"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
resource "aws_instance" "example" {
  ami                         = "ami-0abe96a6773a37eb1"
  instance_type               = "t3.micro"
  user_data                   = <<-EOF
              #!/bin/var/env bash
              echo "Yooo, World" > index.xhtml
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  vpc_security_group_ids      = [aws_security_group.instance.id]
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
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
