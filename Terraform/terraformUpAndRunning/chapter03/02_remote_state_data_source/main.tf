/*
- Data source for remote state file
- `terraform_remote_state`
- Can be used to fetch the terraform state file stored by another set of terraform configurations
- data returned by `terraform_remote_state` is read_only
- This state be read for example from your webserver, by @1
- All the output var from the db are stored in this file, and you can read them simply with the reference
`data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>`
- For example trying to update the user data (which is a bash script) to read address and port info of the database
```bash
#!/bin/bash
echo "HELLO" >> index.html
echo "${data.terraform_remote_state.db.outputs.address}" >> index.html
echo "${data.terraform_remote_state.db.outputs.port}" >> index.html
nohub busybox httpd -f -p ${var.server_port} &
```
*/

#@1
data "terraform_remote_state" "db" {
  backend = s3
  config = {
    bucket = "(YOUR_BUCKET_NAME)"
    key    = "stage/data-stroes/mysql/terraform.tfstate"
    region = "eu-central-1"
  }
}

/*
You can use the function `templatefile` to read a file at a path and render it
- For example you can have your bash script as this
```bash
#!/bin/bash
cat > index.html <<EOF
<h1> Hello, world</h1>
<p> DB address: ${db_address}</p>
<p DB Port: ${db_port}</p>
EOF
nohup busybox httpd -f -p ${server_port} &
```
- With this the launch configuration would look like @2
*/
#@2
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  # Render the User Data script as a template
  user_data = templatefile("user-data.sh", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })
  # Required when using a launch configuration with an autoscaling group.
  lifecycle {
    create_before_destroy = true
  }
}


provider "aws" {
  region = "eu-central-1"
}
