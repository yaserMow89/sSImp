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
