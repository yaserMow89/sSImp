# Commands

- Second level headlines refer to **chapters**
- Third level headlines refer to specific **Lessons**

## General Troubleshooting Methods

```bash
man -k command
journalctl --since --until
```

## System Startup issues

### Boot Process

```bash

```

### Identifying Boot Failures

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Regaining Root Control

```bash
rd.break
```

### Kernel Modules

```bash
### Gathering info on mods
/lib/modules/$(uname -r)/modules.builting # Modules that are builtin the running kernel
lsmod # Modules that are loaded and being actively used by our Kernel
      # Can also see if they are being used by other modules
modinfo [mod Name] # Information about a module
modinfo [mode Name] -p # Shows the parameters with a mod and some info about each of them
find /lib/modules/$(uname -r))/ -type -f -name *.ko* # A list of modules being used currently

### Managing mods
modprobe [mod Name]     # Add a mod
modprobe -r [mod Name]  # Remove a mod

### Managing Parameters

modprobe [mod Name ] [Parameter Name]=[new value]  # Sets the parameter value of a mod to a new value
                                                   # To change the parameters value, they should be removed first using   modprobe -r first, change it, and it will be loaded automatically
/sys/module/$(mod Name)/parameters                 # To see the parameter values

/etc/modprobe.d/                                   # Is also a place that is used by some modules to store parameters
```

### 15 Identifying Service Failures

```bash
systemctl daemon-reload
systemctl list-dependencies      # See the dependencies structure among services
systemctl enable debug-shell.service   # Starts root on tty9
systemctl list-jobs     # List of running jobs
systemctl show [unit Name] # Shows more info about a service

```


### Hardware Issues

```bash
lsscsi                  # SCSI (DISK) Info
dmidecode               # BIOS Stats
dmidecode -t memory     # Memory
journalctl -f -u mcelog # Get logs related to hardware


```

## File System Issue

### Recovering Corrupted File Systems

```bash
### Repairing xfs file systems:
xfs_repair -n [file system]      # Dry run for finding issues
                                 # Removing -n, runs the fix
### Repairing ext file systems:
e2fsck                           # -n --> non-interactiv, readonly mount
                                 # -p --> Attempts Automatic repair
dumpe2fs                         # Outputs info about the defined ext4 system
```

### Troubleshooting LVM

```bash
/etc/lvm/lvm.conf          # Set archive = 1 will enable archiving for lvm
/etc/lvm/archive           # Archive location
vgcfgrestore               # Volume Group Configuration restore command
vgcfgrestore -l [vg Name]  # Lists available restore points for specific vg
vgcfgrestore -f [archive]  # Uses archive file to restore a lv
lvchange -a[n|y]           # Activate or deactivate an lv
```

### Recovering data from Encrypted File System

```bash
cryptsetup luksHeaderBackup [luks drive] --header-backup-file [dst. file address]
cryptsetup luksHeaderRestore [luks drive] --header-backup-file [file address]
cryptsetup luksAddKey [luks drive] [luks key; can also be a file containing key]
/etc/crypttab        # Used for auto opening of luks encrypted drives
                     # For example: luks	efd3beaa-b54b-4962-8fa1-6dfd69c25094	/root/secret.key
cryptsetup luksDump [luks drive]

```

### Troubleshooting ISCSI

## Package Management

## Networking issues

### Networking Overview

### Verify Network Connectivity

```bash
ping        # -c [number]--> count for number of packets
            # -f --> flood destination server
            # -s [number] --> size of packet to be sent
telnet [ip] [port]      # Can be port specific and leverages TCP Connections, unlike ping which uses UDP

ncat (nc) [dest ip] [port]       # Tests both TCP and UDP
   ncat -l 443                   # Starts listening on port 443
   ncat [dest ip] 443            # Starts session between current device and target server on port 443

```

### Fixing Connectivity Issues

```bash
firewall-cmd --list-all    # List active rules on firewall
firewall-cmd --zone=public --add-port=[port number]/[tcp/udp]     # To allow connections to a port
                                                                  # It is not persistent
                                                                  # Persistence can be achieved via either --permanent or --runtime-to-permanent
firewall-cmd --zone=public --add-port=80/tcp    # Allows connections to http
nmcli d show
nmcli c show
nmcli c up [connection name]

```

### 22 Inspecting Network Traffic

```bash
watch [option|s] "[command to run]"     # Runs a command periodically
   watch -n 5 "curl localhost"   # Runs the command every 5 seconds

# flags for wireshark and tcpdump are similar:
#  -c packet count
#  -w output file
#  -r read file
#  -i interface
tcpdump -i [interface]     # Shows interface specific data
tcpdump -i [interface] 'port [port number]'  # Filters traffic related to a specific port
```
## Application Issues

### Identifying Library Dependencies

```bash
ldconfig -p          # List all the libraries on the computer
ldd                  # List shared libraries, should be used with an application
   ldd $(which httpd)
```

### Identifying Memory Leaks

```bash
valgrind
```

### Application Debugging tools

```bash
ltrace      # Library tracing
ltrace [command absolute path] target_file
ltrace $(whcih cat) file.txt

strace

```

### SELinux Issue

```bash
ls -Z [File Name]    # Shows SELinux security context info
seinfo -u            # Shows list of user roles
semanage login -l    # Shows login roles assigned to the current user
semanage user -l     # Shows various selinux user options, as well as roles which can be assigned to these users
seinfo -r            # Shows object roles that can be assigned
semanage port -l     # Shows Associated ports for various services

chcon -R --reference [source context file] [destination context file]
   # Would change the context of the dest file according to the source file
   # chcon stands for change context
```

## Authentication Issues

### PAM Issues
```bash

```

## Aiding Third-Party Investigation

### Creating Kernel Crush Dumps
```bash

```
