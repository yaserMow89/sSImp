# Extending the Template

## Parallel Builds


## HCL Building Blocks

- gets with the extension `*.pkr.hcl`
- Conversion to hcl is almost one to one
- An example would be

```hcl
source "<BUILDER>" "<BUILD NAME>" {
   image = "<IMAGE_NAME>"
   "Other parameteres"

}

```

- A complete example would be:
- File name should be `*.pkr.hcl`
- So we can have multiple sources, and organize things into different files
- For example we would have a source file named `amazon-ubuntu.pkr.hcl` and it would be

```hcl
source "amazon-ebs" "aws-ubuntu" {
   access_key = "<KEY>"
   secret_key = "<KEY>"
   region = "<REGION>"
   instance_type = "<TYPE>"
   ami_name = "<NAME>"
   source_ami_filter {
      filters = {
         virtualization_type = "<TYPE>"
         name = "<NAME>"
         root-device-type = "<TYPE>"
      }
      owners = ["<OWNERS>"]
      most_recent = true
   }
   ssh_username = "<USERNAME>"
}
```

- Now we can have another source file also named as `lxd-ubuntu.pkr.hcl`

```hcl
source "lxd" "ubuntu" {
   image = "ubuntu:focal"
   init_sleep = "30"   
}
```

- Let's create the file that would build both builds from our two previous files. named as `prom-app.pkr.hcl`
- Our build would consist of calling the sources to build and also the provisioners

```hcl
build {
   # List of sources are defined here
   sources = [
      # Gonna be source.builder.buildName
      "source.amazon-ebs.aws-ubuntu",
      "source.lxd.ubuntu"
   ]
   # And we can also provide our provisioners here
   provisioner "shell" {
      script = "scripts/prom-init.sh"
   }

   provisioner "file" {
      source = "prometheus.service"
      destination = "/tmp"
   }

   provisioner "shell" {
      script = "scripts/prom-post.sh"
   }
}
```

- At this point you have run `packer build <dest_dir>` and it will build all the sources within that directory
