Kube Config
===========

- How to pass a request to a k8s cluster using the certificates
```
curl https://my-kybe-playground:6443/api/v1/pods/ \
   --key <userKey>.key
   --cert <userCert>.crt
   --cacert <CACert>.crt
```
- The same can be done using `kubectl`
```
kubectl get pods
   --server my-kube-playground:6443
   --client-key <userKey>.key
   --client-certificate <userCert>.crt
   --certificate-authority <CACert>.crt
```
obviously writing all these every time is a tedious task, so you move them to the `kubeconfig` file, and specify the file as `--kubeconfig` option in your command
```
kubectl get pods --kubeconfig </path/to/file>
```
- By default `kubectl` looks at `~/.kube/config` for this `kubeconfig` file

## `kubeconfig` File
- Has 3 sections
   1. **Clusters**
      - Various k8s clusters that you need access to
   2. **Users**
      - User accounts with which you gain access to the clusters
   3. **Contexts**
      - Which user account will be used to access which cluster
      - For example `Admin@production` to access the `production` cluster using the `Admin` account
- How the above fit in our case?
   - The server specifications goes to the **Cluster** section
   ```
   --server
   --certification-authority
   ```
   - The user specifications goes to the **User** section
   ```
   --client-key
   --client-certificate
   ```
### `kubeconfig` file *Structure*
- `.yml` format file
```
current-context: <defaultContextName>
apiVersion: v1
kind: Config
clusters:      # Array
- name: <clusterName>
  cluster:
   certificate-authority: <CACert>.crt
   server: <serverAddress>:6443

contexts:      # Array
- name: <userName>@<clusterName>
  context:
   cluster: <clusterName>
   user: <userName>

users:         # Array
- name: <userName>
  user:
   client-certificate: <userCert>.crt
   client-key: <userKey>.key
```
- How to add a new cluster with user?
   - Add the cluster data
   - Add the user data
   - Add the context
- Using `current-context` key, you can have **Default** context
   - `current-context` can be changed using `k config use-context <contextName>`
      - Changes made by this command are reflected in the `config` file
- `k config view` to show content of current `config` file
- `k config view --kubeconfig=<customConfigFile>` to pass non-default `config` file
- Much more can be done using the `config` option in `kubectl`; check them out at `k config --help`
### `NameSpaces` in `kubeconfig`
- can be specified at `contexts.name.context.namespace`
   - If defined, once you switch to a context it will automatically work on the defined `nameSpace`
### *Certificates* in `kubeconfig`
- Can be passed in various ways
   1. Using the field: `certificate-authority`, `client-certificate` and `client-key`
   2. Can be passed as data, like `certificate-authority-data` and provide the certificate data as `base64`
