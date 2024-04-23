Multi Container Pods
====================

- Microservices
   - Set of independent, small and re-usable code
   - scale up
   - scale down
   - modify each service

- Sometimes you may need multiple services to work together --> multi container pods

## Multi Container Pods
- Share same lifecycle
   - created and destroyed together
- share same network space
   - refer to each other as *localhost*
- Access to the same *storage volume*
- **Design Patterns**
   - *Sidecar*
   - *Adapter*
   - *Ambassador*

### *initContainer*
   - Run one time when the pod is first created
   - Or a process that waits for an external service or database to be up before the actual application starts
   - Is configured inside `initContainers:` section inside a pod under `spec`
   ```
   spec:
      containers:
      # Comes the container
      initContainers:
         - name: <name>
           image: <imageName>
           command: ['sh', '-c', 'git clone <some-repo-that-will-be-used-by-application> ; done;']    # This is only an example
   ```
   - When the pod is started, *initContainer* must finish and complete before the real container starts
   - You can configure **multiple** of them
      - In such case each of them runs one at a time in sequential order
   - *Failure* --> Pod Restart

### How to do this
- As you know the `spec.containers.` in here the `containers` is a list, so that you can add as many containers as you want
```
# Rest of data
spec:
   containers:
      - name: container1
        image: <image>
      - name: container2
        image: <image>

# Rest of data
```
