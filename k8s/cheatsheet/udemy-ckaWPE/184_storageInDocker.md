Storage in Docker
=================
- Two concepts in Dokcer storage
   1. **Storage Drivers**
   2. **Volume Drivers**



#Docker Storage Drivers
- Docker *Storage* drivers and *FileSystem (FS)*


## File System
- `/var/lib/docker`
   - Files related to *images* and *containers* running on the host

### Image and Container storing Format
- **Layered** architecture
   - Each line of Instruction in `Dockerfile` creates a new **Layer** on the top of pervious layers which were built as result from pervious lines
   - Advantages --> reuse-ability
   - Read-only layers
   - **container layer**
      - **writeable layer**
         - As long as the container is alive
      - Different among containers
      - If you modify a file in the `only-read` layers, your changes will be stored on the `write read` layer
         - The file is copied to the `write read` layer and the modifications are written on that layer and stored, but no changes are made to the `read only` layers
         - *`Copy-On-Write`* mechanism
         - Persists as long as the container is alive
- How to store the data
### Volumes
- Using the `docker volume create <name>`
   - `/var/lib/docker`
- Can be mounted `docker run -v <volName>:<mount/path/in/the/container> <containerName>`
   - Will be created automatically if not created before running the container
- Can be something rather the *default* volume (`/var/lib/docker`) location
   - Only have to provide the full path
   - Called *`bind`* mounts
      - Mounting directories from any location on the docker host
- Using `-v` is the old style, the new and preferred way of mounting is using `--mount`
```
docker run --mount type=<bindOrVolume>,source=<locationOnHost>,target=<locationOnContainer> <containerName>
```

- All above is done by **Docker Storage Drivers**
   - Not the **Volumes**, they are handled by **volume drivers**
