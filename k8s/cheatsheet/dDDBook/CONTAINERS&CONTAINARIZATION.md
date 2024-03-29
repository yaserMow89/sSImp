Containers and Containerization
===============================



- SIGTERM --> `docker stop`
- SIGKILL --> `docker rm -f`


### Self-healing containers
   - always --> always restarts a failed container
   - unless-stopped --> no start of the container upon restarting the *docker daemon*
   - on-failure --> In case container exits with a non-zero code, and also starts stopped containers upon *docker daemon* start

### Containerizing and app
   - simple to build, ship and run
   - `-t` --> Name (and I guess maybe also tag)
   - If instruction adds content, it will create new layer; If it is adding instruction on how to build image and run the container, it will crreate metadata
   - To see the instructions history to build a contianer: `docker history <ImageName>:<tag>`

### Pushing image
   - Image should be tagged before pushing
      - `docker tag <ImageName:CurrentTag <userID>/<ImageName>:<tag>`
   - can be pushed:
      - `docker push <Registry>/<userID>/<repo>:<imageTag>`
      - An example could be: `docker push yasermow/ddd-book:ch8.1`
      - Note that we didn't give the registry address, the default registry will be used `docker.io` in this case.

### Multi-stage builds
### Multi-platform builds

#### Leveraging the build chache
   - *cache hit* & *cache miss*
   - *invalidating the cache*
   - `--no-cache`
#### Squashing the image
   - `--squash`

#### no-install-recommends
   - `no-install-recommends`
   
