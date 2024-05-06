Persistent Volumes and Volume Claims
====================================

## 189. Persistent Volumes
- In last lecture (188_volumes.md) volumes were being created within the pod definition file
- Config Storage in a more central way
- Persistent Volume --> Cluster wide pool of storage volumes, to be used by users deploying applications on the cluster
- Storage can be claimed by users using the *persistent volume claims*
- can be created:
```
apiVersion: v1
kind: PersistentVolume
metadata:
   name: <volName>
spec:
   accessModes:
      - <mode>
   capacity:
      storage: <Size> # Example could be 1Gi
   hostPath:          # Volume Type
      path: /tmp/data
```

- `accessModes` --> How a volume should be mounted on a host
   - `ReadOnlyMany`
   - `ReadWriteOnce`
   - `ReadWriteMany`
- `hostPath` type uses a local directory on a node and is not supposed to be used in a production environment
   - Can be replaced with `AWS` solution for example (Also seen in the last lecture)
      - ```
      awsElasticBlockStore:
         volumeID: <volume-id>
         fsType: ext4
      ```

### Some Useful commands
- `k apply -f <definitionFile>.yml`
- `k get persistentvolume`

## 190. Persistent Volumes Claims
- A separate object from `PVs`
- A `PV` is created by Admin usually
- A `PV claim` is created by users usually, to use the volume
- Once a **claim** is created, k8s binds the `PV` to `claims` based on the request and properties set on the volume
- Every `PV Claim` is bound to a single `PV`
- During the binding k8s tries to find a `PV` that has sufficient capacity as requested by the `Claim`, and any other request properties such as `Access Modes`, `Volume Modes`, `Storage Class`, and etc...
   - However if there are multiple `PVs` for a specific `Claim`, you could use `labels` to bind to the right `PV`
- Relationship between `Claims` and `PVs` is **1-to-1**, once a `PV` is bound to a `Claim` no other `Claims` can use it, no matter how much more capacity is left on it
- If no `PVs` are available the `Claim` will remain in a pending state, once new `PVs` are available binding will take place automatically
- A `PV Claim` definition file:
```
apiVersion: v1
kind: PersistentVolumeClaims
metadata:
   name: <pvcName>
spec:
   accessModes:
      - ReadWriteOnce
   resources:
      requests:
         storage: 500Mi
```

- Can be created using `k create -f <defFile>.yml`
   - The k8s looks at the `Claim` and checks for volumes where `accessModes` matches and the `resources.request.storage` also meets the required capacity
- Can be viewed using `k get pvc ` or `k get persistentvolumeclaim`
   - Can also see which `PVs` are bound to which `claims`
- Can be deleted using `k delete pvc <name>`
   - What will happen to an underlying `PV` when a `claim` to it is deleted
      - Is defined by `persistentVolumeReclaimPolicy` an example would be:
         - Is defined under `.spec.persistentVolumeReclaimPolicy`
      ```
      kind: PersistentVolume
      apiVersion: ...
      ...
      spec:
         capacity: ...
         ...
         persistentVolumeReclaimPolicy: <policy>
      ```
         - **Default** value is `Retain`
            - The `PV` remains until it is *deleted manually*
            - Is not available for *re-use* by any other claims
         - Or can be set to `Delete`
            - As soon as the `Claim` is deleted, the `PV` is deleted as well
         - Or can also be set to `Recycle`
            - Data will be **scrubbed** before the `PV` is made available to be used by another `Claim`

## 191. `PVCs` in Pods
- `PVCs` can be defined within pods also, as below:
```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```
