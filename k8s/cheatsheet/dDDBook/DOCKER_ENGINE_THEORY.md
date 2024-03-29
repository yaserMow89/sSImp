

Docker Engine in docker is like ESXi in VMware
July 2017 Open Container Initiative (OCI) released following standards:
   - Image Spec
   - Container runtime spec (runc)
   - Now a third one to *Standardize image distribution via registries*

### runc:
- Basically a cli wrapper for libcontainer. libcontainer originally replaced LXC as the interface layer with the host os in the early docker architecture.
- Has a single purpose in life --> create containers

### containerd:
- All of the container execution logic was ripped from docker daemon and refactored into a new tool called containerd.
- Sole purpose of it's life is to manage container *lifcycle*
   - Operations such as: `start`, `pause`, `rm`, ...
- Is available as a daemon for *Linux* and *Windows*
   - In *Linux* is called *containerd.service*
- It was supposed to work for single purpose (Container lifcycle), but over time it extended to image pulls, volumes and networks. (It is a controversial point as I see)

> Note: How a container is created; the whole process is explained in the OneNote--> SeDe --> Docker --> Intro

### Shim
- containerd forks a new instance of *runc* for every container it creates. Once the container is created the *runc* process terminates. Once the container's parent process is killed (Meaning runc), shim becomes the container's parent. Some of it's resposibilities are:
   - Keeping any *STDIN* and *STDOU* streams open, so that when the daemon is restarted, the container doesn't terminate due to pipes being closed.
   - Reports the container's exit status back to the daemon
   - If you kill the shim process of a container, the container terminates (I tested it :))

### How it's implemented on Linux
   - The components discussed so far are implemented as separate binaries in:
      - /usr/bin/dockerd (the Docker daemon)
      - /usr/bin/containerd
      - /usr/bin/containerd-shim-runc-v2
      - /usr/bin/runc

### so what does daemon do?
   - implementing Docker API
   - Authentication
   - security
   - pushing and pulling images
   - and some other things
