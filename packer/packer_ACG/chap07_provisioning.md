# Provisioning

## Bash

- Bash as provisioner
- The code snippet below is also taken from the last chapter

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
   /*
   The code after this is for this lecture
   */
   "provisioners": [
      # We can have any provisioners here, just open the block for it and continue
      {
         "type": "shell",
         # This can be in different ways, such as an inline script or a .sh file
         "inline": ["sudo apt update -y && sudo apt upgrade -y", "more commands"]
      },
      {
         # This is a second provisioner
         "type": "shell",
         # If you have only one script it should be script NOT scripts
         "scripts": ["firstScript.sh", "secondScript.sh", "and more scripts"],
         "environmental_vars": ["HOSTNAME=SOMETHING", "Var2=val2", "etc..."],
         "remote_folder": "remote folder to copy our scripts into",
         "skip_clean": true "or" false # Keep or don't keep our scripts after everything is done
      }
   ]

}
```

## File

- Upload files and directories to our remote machine
- It comes in the provisioners block with `"type": "file"`
- Would be visible in the following example, please note that this example is continuation of the previous lectures

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
         "inline": ["sudo apt update -y && sudo apt upgrade -y", "more commands"]
      },
      {
         /*
         This is the file provisioner
         */
         "type": "file",
         # Here we have to supply source and destination
         "source": "SOURCE_DIR/",
         # Please note that a trailing / means that only the content of the source are copied
         # Removing the trailing / means that the directory is copied to the destination
         "destination": "/tmp"
      },
      {
         # This is a second provisioner
         "type": "shell",
         # If you have only one script it should be script NOT scripts
         "scripts": ["firstScript.sh", "secondScript.sh", "and more scripts"],
         "environmental_vars": ["HOSTNAME=SOMETHING", "Var2=val2", "etc..."],
         "remote_folder": "remote folder to copy our scripts into",
         "skip_clean": true "or" false # Keep or don't keep our scripts after everything is done
      }
   ]

}
```

## Ansible

- Two options available
   1. Using existing Ansible provisioner
      - Runs Ansible playbook commands over ssh
      ```json
      "provisioners": [
         {
            "type": "ansible",
            "playbook_file": "./playbook.yml"
         }
      ]
      ```
   2. Using Ansible Local provisioner
      - Installs the Ansible on the remote host itself
      - We have to make sure it gets installed on the remote host using a shell provisioner first
      ```json
      "provisioners": [
         {
            "type": "ansible-local",
            "playbook_file": "./playbook.yml"
         }
      ]
      ```

- The same example from previous sections is used here also

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
   ]

}
```
