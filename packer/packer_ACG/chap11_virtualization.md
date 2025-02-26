# Virtualization

## Building a VirtualBox Image with Packer

- 3 builders with VirtualBox
   1. *virtualbox-iso*
   2. *virtualbox-ovf*
   3. *virtualbox-vm*

- we are focusing on the first option here; an example would be:
- There are many keystrokes that we can use as boot commands, for example:
   - `<insert><home><end><pageUp><pageDown><spacebar><tab><enter><return><f1...f12><menu><leftAlt><rightAlt><leftCtrl><rightCtrl><leftShift><rightShift><waitSeconds><wait1h15m20s>`
- To get combinations of words or keyboard bindings we do on and off, so `ctrl+c` would be: `<leftCtrlOn>c<leftCtrlOff>`
```json
{
   "variables": {
      "password": "packer"
   },
   "builders": [
      {
         "type": "virtualbox-iso",
         "guest_os_type": "Other_64",
         "iso_url": "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86/alpine-standard-3.21.0-x86.iso",
         "iso_checksum": "file:https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-standard-3.21.0-x86_64.iso.sha256",
         "ssh_username": "root",
         "ssh_password": "{{user `password`}}",
         "shutdown_command": "poweroff",
         "boot_command": [
            "root<enter><wait>",
            "Some Other Commands"

         ]
      }
   ],
   "provisioners": [
      {
         "type": "shell",
         "inline": ["apk udpate"]
      }
   ]
}

```

## Build a Vagrant Box with Packer

```json
{
   "builders": [
      {
         "type": "vagrant",
         "source_path": "generic/alpine38",
         "provider": "virtualbox",
         "teardown_method": "destroy",
         "communicator": "ssh"
      }
   ],

   "provisioners": [
      {
         "type": "shell",
         "inline": ["sudo apk update"]
      }
   ]
}

```
