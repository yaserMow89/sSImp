# Post-Processors

- Things we would do after building the image
- The code is taken from earlier lessons


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
   ],
   "provisioners": [
      # We can have any provisioners here, just open the block for it and continue
      {
         "type": "shell",
         # This can be in different ways, such as an inline script or a .sh file
         "inline": [
            "sudo apt update -y && sudo apt upgrade -y", "more commands",
            # Here we install ansible
            "sudo apt install ansible -y"
         ]
      },
      {
         "type": "file",
         # Here we have to supply source and destination
         "source": "SOURCE_DIR/",
         # Please note that a trailing / means that only the content of the source are copied
         # Removing the trailing / means that the directory is copied to the destination
         "destination": "/tmp"
      },
      {
         "type": "ansible-local",
         # If you have more than one file, you can just use playbook_files and pass a list of them
         # We would have the option "playbook_dir" or "playbook_paths" if you have multiple directories
         # You can also pass inventory groups or file inventory_file, groups
         # inventory_file must be on the local workstation
         # can also pass roles_path for roles
         "playbook_file": "playbook.yml"
      }
   ],
   # This is the list of our post-processors
   "post-processors": [
      {
         "type": "vagrant"
      },
      {
         "type": "compress",
         "output": "vagrant.tar.gz"
      }
   ]
}
```
