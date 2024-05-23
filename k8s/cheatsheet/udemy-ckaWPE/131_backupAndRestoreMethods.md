Backup & Restore Methods
========================

## Backup candidates
### Resource configuration
   - Imperative
   - Declarative
      - Preferred for saving
      - Stored on source code repos
         - backed up
   - Using the source code repos does not include resources created in the *Imperative* way, and a solution to back them up and also resources created via the *Declarative* way, `kube-apiserver` could be queried
#### Querying `kube-apiserver`
- Can be done in either of two ways:
   - Using `kubectl`
   - Directly querying the `kube-apiserver`
- Can save all the resource configurations for all objects on the cluster as a copy
   - For example to get all `pods`, `deployments` and `services` in all `namespaces`:
   ```
   k get all --all-namespaces -o yaml > <desiredFileName>.yml
   ```
   - The above command is not inclusive of all Resource Groups on the cluster, there are far many other groups to be considered
- There are also *tools* that can do this
### ETCD cluster
- Info about cluster itself, nodes and any other resources created on the cluster
- While configuring it a *location* is also specified for storing all the data
   - Could be taken using this command on my cluster
   ```
   ps aux | grep -i etcd | grep -i data-dir
   ```
   - `data-dir` is the value which holds the location
- Simply the `data-dir` could be backed up and it will do the job
- Also comes with builtin backup utility, and could be used to take snapshots
```
ETCDCTL_API=3 etcdctl snapshot save <snapshotName>.db
```
- To view the snapshots
```
ETCDCTL_API=3 etcdclt snapshot status snapshot.db
```
- To restore
   - stop the `kube-apiserver`
   ```
   service kube-apiserver stopped
   ```
   - Restore
   ```
   ETCDCTL_API=3 etcdctl snapshot restore <snapshotName>.db --data-dir <newDirectory>
   ```
   - When `etcd` restores from a backup, a new cluster configuration starts and configures the members of `etcd` as new members to a new cluster, this is to prevent a new member from joining an existing cluster
   - So after running the command we also should configure the `etcd` to read from the new given `--data-dir`
   - Reload the service daemon and `etcd` service
   ```
   systemctl restart daemon-reload
   service etcd restart
   ```
   start back the `kube-apiserver` service
   ```
   service kube-apiserver start
   ```
   - **NOTE** It is important to specify:
      - certificate file for *Authentication*
      - Endpoint to the *etcd cluster*
      ```
      --endpoints=https://127.0.0.1:2379
      ```
      - The *CA Certificate*
      ```
      --cacert=/etc/etcd/ca.crt
      ```
      - *etcd server* certificate
      ```
      --cert=/etc/etcd/etcd-server.crt
      ```
      - The *Key*
      ```
      --key=/etc/etcd/etcd-server.key
      ```
