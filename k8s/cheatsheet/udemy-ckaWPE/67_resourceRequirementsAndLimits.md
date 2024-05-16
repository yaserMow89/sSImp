Resource Requirements and Limits
================================

## Resource Requests
- Min ammount of resources
- Guaranteed amount of resources
## Resource limits
- Can be distinct between many containers in a pod
- Are specified uner `.spec.containers.resources` in pod, below is an example:
```
resources:
   requests:
      memory: "<desiredAmount>"
      cpu: <desiredAmount>
   limits:
      memory: "<desiredAmount>"
      cpu: <desiredAmount>
```

## Default Configurations
- No limits or requests by default

## Default Behavior
### CPU
   - No limits, no requests; one pod can consume all the resources, and prevent others from resources
   - If limits are set and no request is set, request is also set automatically to limits
   - Both set ;)
   - No limits, but requests are set; in this case each pod is guaranteed the requested amount, but if free they can go as high as available
      - Most ideal
   - Setting **requests** is a good practice; cause it guarantees min resources for a pod to run
### Memory
   - Almost similar to CPU
   - No limits, no requests; same as *CPU*; one can consume all resources and prevent others from getting any resources
   - Limits set, no requests; same as *CPU*, requests is also set to limits
   - Both set
   - No limits, requests set; get the minimum, but when available can go as high as available
      - But if others claim their guaranteed amount of ram and it is already being used by another pod, it should be killed, cause unlike cpu we can't throttle memory
## Limit Ranges
   - Default settings for all pods
   - Applicable at the **namespace** level
   - An example, for CPU
   ```
   apiVersion: v1
   kind: LimitRange
   metadata:
      name: <name>
   spec:
      limits:
      - default:
         cpu: <cpuLimit>
        defaultRequest:
         cpu: <cpuRequest>
        max:
         cpu: <cpuLimitMax>
        min:
         cpu: <cpuRequestMin>
        type: container

   ```
   - An example for Memory
   ```
   apiVersion: v1
   kind: LimitRange
   metadata:
      name: <name>
   spec:
      limits:
      - default:
         memory: <memoryLimit>
        defaultRequest:
         memory: <memoryRequest>
        max:
         memory: <memoryLimitMax>
        min:
         memory: <memoryRequestMin>
        type: Container
   ```
   - They are effective on **DuringScheduling** time of a pod, with respect to pod lifecycle
      - Doesn't effect the already running pods (**DuringExecution**)

## Resource Quotas
   - Restricting total amount of resources allowed to be consumed by applications deployed in the cluster
   - At a **namespace** limit
   - Hard limits
   - For example:
   ```
   apiVersion: v1
   kind: ResourceQuota
   metadata:
      name: <name>
   spec:
      hard:
         requests.cpu: <totalRequestableCPU>
         requests.memory: <totalRequestableMemory>
         limits.cpu: <maxRequestableCPU>
         limits.memory: <maxRequestableMemory>
   ```

## Exceed Limits
   - CPU
      - Throttled
   - Memory
      - Can use more than limits
      - Happening constantly, terminates the pod
         - The error in the logs would be `OOM`(`Out Of Memory`)

## Measurements
   - CPU
      - m --> milli
      - 1 --> 1 hyperthread
      - 1m --> lowest possible value
         - one milli
   - Memory
      - Mi  --> Mibibyte = 1048576 bytes
      - Gi  --> Gibibyte = 1073741824 bytes
      - Ki  --> Kibibyet = 1024 byets
      - G   --> Gigabyet
      - M   --> Megabyte
      - K   --> Kilobyet
