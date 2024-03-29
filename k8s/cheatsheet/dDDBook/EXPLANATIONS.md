DOCKER DEEP DIVE Explanations
=============================


Referring to Docker Technology:
   - The runtime
   - The daemon (Engine)
   - The orchestrator

Installing docker on a Linux gives you two major components:
   - the Docker client
   - the docker engine (daemon)
By default, the **Client** talks to the **daemon** via a local IPC/Unix socket at `/var/run/docker.sock`
