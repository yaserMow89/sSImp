# Building a base Template

## Builders

- Does actual work to build the image, without it the packer wouldn't know what image to generate and what platform it should generate for
- Currently 30 available
- Each has it's own set of parameters

```json
{
   # This first block is only for storing variables for later use, and has nothing related to packer yet
   "variables": {
      "aws_access_key": "",
      "aws_secret_key": ""
   },
   # This is the builders block and defining the HCL builders
   "builders": [
      {
         "type": "amazon-ebs",
         "access_key": "{{user `aws_access_key`}}",
         "secret_key": "{{user `aws_secret_key`}}",
         "region": "us-east-1",
         "instance_type": "t2.micro",
         "ami-name": "packer-base-ami-{{timestamp}}",
         "source_ami_filter": {
            "filters": {
               "virtualization_type": "hvm",
               "name": "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*",
               "root-device-type": "ebs"
            },
            "owners": ["099720109477"],
            "most_recent": true
         },
         "ssh_username": "ubuntu",
      }
   ]
}
```

## Communicators

- Agent for the packer to talk to the remote that is creating our image
- By default done by `ssh`
- The code is in the Builders section code
   - It is only the `ssh_username` part
   - In case the communicator is not ssh we can define it using the key `communicator`

## Building the image

- Before building we can validate our template using
```bash
packer validate packer.json      # To validate our build file
packer fix packer.json           # To give you the preferred style of packer for your json file
packer build <Json file>         # This is if you have json file
packer build .                   # This is if you have hcl file
```
