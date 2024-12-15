# Chapter 02 - Packer


## What is Packer

- Images are created using templates
- Templates can be either **json** or **hcl**
- Depends to the user which ever template format they would like to use

## Why User packer

- Rethink how we create our golden image

## Packer Breakdown

- Few components in packer
   1. **Builders**
      - Define the desired platform and platform configuration
   2. **Provisioner**
      - Can be either the current provisioner that we have, such as puppet, chef or salt or can be provisioning scripts or files that are uploaded for provisioning
   3. **Post-processer**
      - For anything that we want to do after creating the image, like uploading it to some specific place, or maybe adding some metadata to it
      - Post-processer is related to builder, for example it would be different in aws compared to azure
   4. **Communicator**
      - Used by packer to communicate to the machine during the creation process
      - Spinning up instance, configuring it, and deleting it after creation and ...
      - By default is not required, but is required for windows as an example winrm could be used
- A **Build** is the combination of the previous components to create a machine image
   - It is essentially a combination of your builder, provisioner, post-processer and any changes to create a machine image
   - Multiple images coming out of a machine are considered multiple builds
- An **Artifact** is produced once a build is ran
- Packer **Command** used to manage image build
