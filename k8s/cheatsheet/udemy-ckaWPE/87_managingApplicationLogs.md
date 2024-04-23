Managing Application Logs
=========================

- `kubectl logs -f <podName>`
   - `-f` is for live stream
- If you hve multiple containers inside a pod, the name of the container which you want to get logs from should be specified
   - `kubectl logs -f <podName> <containerName>`

- `k logs <podName> -c <containerName>`
   - `-c` is for container within the pod
