Environment setup for Docker on Linux
=======================================

How to prepare Environment on Linux:
   - Install `multipass`
   ```
   sudo snap install multipass
   ```
   - Run the desired instance
   ```
   multipass launch docker --name myNode
   ```
   - List all VMs
   ```
   multipass ls
   ```
   - Connect to a VM
   ```
   multipass shell myNode
   ```
   - Delete VM
   ```
   multipass delete myNode
   multipass purge
   ```
> In case there are issues: `sudo systemctl restart snap.multipass.multipassd.service`

   - Exiting out of container without shutting it off: `Ctrl+pq`
