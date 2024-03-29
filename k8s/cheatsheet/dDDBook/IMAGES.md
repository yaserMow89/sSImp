Images in Docker
===================

- Images are considered *build-time* constructs
- Containers are considered *run-time* constructs
- Images don't include a *Kernel*, because the share the kernel of the host

- Local image repository, in my case(Ubuntu 22.04):
   ```
   /var/lib/docker/image/overlay2
   ```

### image registries
   - Centralized place to store the images
   - Image registries are divided into repos, and repos contain images
      - As of my understanding repos contain different versions of the same image
   - *Official Repositories*

### Writeable Layer
   - Every container gets it's own writeable layer on top of the image and the layers below that are read-only
   - The writeable layer is used in case container wants to write data on the image
### Pulling images
   - `docker pull <repository>:<tag>`
   - To pull from *unofficial repos*:
      - `docker pull <UserName|OrganizationName>/<RepoName>:<tag>`
         - For example: `docker pull nigelpoulton/tu-demo:v2`
   - To pull from 3rd party registries:
      - `docker pull <registryDNS>/<repo>:<tag>`
         - For example: `docker pull gcr.io/google-containers/git-sync:v3.1.5`
            - pulls `git-sync` from `gcr.io` registry
   - *latest* tag is an arbitrary tag, and does not guarantee the image to be latest
   - Images with **dangling** tag
   - Currently supported filters by docker:
      - *dangling*: Accepts true or false, and returns only dangling images (true), or non-
      dangling images (false).
      - *before*: Requires an image name or ID as argument, and returns all images
      created before it.
      - *since*: Same as above, but returns images created after the specified image.
      - *label*: Filters images based on the presence of a label or label and value. The
      docker images command does not display labels in its output.
   - *reference* can be used for all other filtering
      - `docker images --filter=reference="*:latest"`
   - *format* flag can be used to format the output using *go* templates
      - `docker images --format "{{.Size}}"`
      - Can also be combined, like: `docker images --format "{{.ID}}:{{.Size}}:{{.Repository}}:{{.Tag}}"`

### Searching Docker hub using *CLI*
   - Searches against NAME field
   - `docker search nigelpoulton`: searches for all repos with *nigelpoulton* in the *NAME* field
   - By default `docker search` only shows 25 lines, you can use `--limit` flag to increase to a maximum of 100

### Deleting images:
   - `docker image prune` --> Deletes all the dangling images
   - `docker image prune -a` --> Deletes all the images which are not associated with any containers

#### Miscellaneous commands:
```
docker inspect
docker history
docker images -q // Only shows the ID of the images
```

### Image *digest*
   - digest == hash
      - It makes digests **immutable**
   - can be seen using `--digests` flag
      - `docker images --digests`
   - pulling image using digest:
      - `docker pull ImageName@sha256:Image'sDigest`
   - **distribution hash**

### Multi-architecture Images
   - A single Image tag supporting multiple architectures and platforms
   - A simple pull command will pull the right image on any architecture
   - How does it work?
      - *Registry API* supports two important constructs:
         * **manifest lists**
            - A list of all supported architectures by that specific image
         * **manifests**
            - Contains image config and layer data for a specific manifest
         * Diagram available on OneNote: SeDe-->Docker-->Images

   - To see the *manifest list* of an image:
      - `docker manifest inspect ImageName`

### How an Image is reterived with respect to *manifest*
   - When an image is requested and pulled the following steps happen:
      - Client asks for *manifest lists* (or also *fat manifest*) of a specific image
      - It gets it and looks into the list and sees if it can find it's own architecture in the list
      - Once the architecture is located, it gets the *manifest* for the specific architecture
      - Now the Layers for that specific *manifest* are requested by client from registry
      - Registry sends them
