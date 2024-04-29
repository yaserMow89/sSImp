Docker Security & Security Contexts
===================================
## 173. Security in Docker
### process *Isolation*
- container **isolation** --> `namespaces`
- Process within a *container* is visible on the *docker host*, but with a different `process ID`
   - It is visible since the *container* `namespace` runs as a branch to the host
   - It is called process **isolation**

### Users
- By default the processes inside and outside a *container* run with `root` user
- If you want them to run with a different user, provide the id while running the container `docker run --user=<userID> <image> <command> <arg>`
   - Example `docker run --user=1000 ubuntu sleep 3600`
- Can also be enforced inside the `Dockerfile` for example
```
FROM ubuntu

USER 1000
```
   - Build it and run it; the process will run the given user id

### Considerations
- If running the container without specifying a user, meaning to run with `root` user
   - The `root` user within the container isn't really same as the `root` user on the host running the container
   - Docker uses **Linux** capabilities to implement this
   - On a normal linux host `/usr/include/linux/capability.h`
   - Docker uses the same concept to limit the power of the `root` user within the container
   - In case you would like to grant more capabilities to the root user in a container, you can use the `--cap-add <capability>` option while running the container
   - You can also drop privileges using the `--cap-drop <capability>` option
   - Or if you want to run with all privileges **enabled** use the `--privileged` flag

## 174. Security Contexts
- The same security feature for the **Docker** can be configured in k8s
- It can be implemented in a `container` or a `pod` level
   - If configure at `pod` level, all `containers` within the `pod` will inherit them
   - If configured at both `pod` and `container` level, the `container` settings will overwrite the settings on the `pod`
- A *`pod`* level config would be, `capability` can only be applied to the `container` level, **NOT** the `pod` level
```
...
spec:
   containers:
   ...
   securityContext:
      runAsUser: <userID> # for example runAsUser: 1000
```
- To apply on the container level, move it under the container
```
...
spec:
   containers:
      - name: <name>
        image: <imageName>
        securityContext:
         runAsUser: <userID>
         capabilities:
            add: ["<capability>"]

```
