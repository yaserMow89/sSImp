Volumes
=======

- Docker Containers --> Transient Nature
- Volumes
- Pods are also Transient in k8s world

- Take the example below
```
apiVersion:...
...
spec:
   containers:
      - image: alpine
        name: alpine
        command: ['/bin/sh', '-c']
        args: ["shuf -i 0-100 -n 1 >> /opt/number.out;"]
# Two lines above generate random number and store it to the file /opt/number.out
# The volume created in the volumes section can be mount using the following
   volumeMounts:
      - mountPath: /opt    # Address on the container
        name: data-volume  # Volume Name
# Above section says that any number random generated will be stored in the /opt mounted inside the container, which in turn is on the /data directory on the host
   volumes:
      - name: data-volume
        hostPath:          # Path on the hosting nodeS
         path: /data       # Path on the host
         type: Directory
# The volume above: Any files stored on this specific volume by the pods will be stored on the host at the given directory

```     

- If the pod is deleted the file with the random number will be on the `host`
- There are different `volume storage` options
   - We used the `hostPath` option to configure a directory on the `host` as storage space for the volume
      - In a **Single Node** Scenario it is fine, but what if there are multiple nodes
      - The **Pods** are on different `nodes` and they will have different `/data` directories, though they are expecting it to be same across all nodes
- Many solutions available and supported by k8s
   - For example using an `awsElasticBlockStoreVolume` the volume is defined as below:
   ```
   volumes:
      - name: data-volume
        awsElasticBlockstore:
         volumeID: <volumeID>
         fsType: ext4
   ```
