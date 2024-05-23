ALL topics related to TLS
=========================


# TLS Certificate
- Trust between 2 parties
   1. Encryption
      - Symmetric
      - Asymmetric
         - SSH Keypair

   2. Verification
      - Checking for *legitimate* keys sent by server to the client
      - Self Signed Certificate
      - CA (Certificate Authority)
         - Certificate Signing Request (CSR) by User
         - The following command generates a `CSR`
         ```
         openssl req -new -key <keyName> -out <outputFileName> -subj "/C=<country>/ST=<state>/O=<orgName>, Inc./CN=<orgDomain>"     
         ```
         - Should be sent to *CA* for signing
            - *CA* validates it and sends it back to you
      - How browsers validate the *CAs*
         - They use the public key of the *CA* to validate the signature
         - The public keys belonging to the *CAs* are embedded within browsers
      - They only work with public *CAs*
      - But you can have your own *CA* also   
      - Certificates with public key are usually named as `*.crt` or `*.pem` certificates
      - Certificates with private key are usually named as `*.key` or `*-key.pem`
- Three types of certificates
   1. Root --> On *CAs*
   2. Server --> on *Servers*
   3. Client --> on *Clients*

# 146. TLS in K8S
- All communication between nodes needs to be secure and encrypted
- All communication between admins or developers needs to be secured and encrypted
- All communication between the components should also be secured and encrypted
- In order to achieve above points, clients and servers should use certificates

## Components level look
- Followings are **server** components
### 1. `kube-apiServer`
- Exposes an `https` api for other components and users
- Requires certificates to secure all the communications
   - **Generate** a *certificate* and *key* pair
### 2. `etcd-server`
- Requires a pair of key and a certificate for establishing secure communication links
### 3. `kubelet-server`
- On the *worker nodes*
- Also exposes an `https` api

- Followings are the **client** components
   - Whom are meant by clients?
      - The *Administrators*
      - Access through `kubectl` or `rest-api`
### 1. Admin
- Requires a pair of key and a certificate for establishing secure communication links
### 2. `kube-scheduler`
- is a client that accesses the `kube-apiserver`
- Requires a pair of key and a certificate for establishing secure communication links
### 3. `kube-controller-manager`
- Is another client that accesses the `kube-apiServer`
- Requires a pair of key and a certificate for establishing secure communication links
### 4. `kube-proxy`
- Is a client of `kube-apiServer`
- Requires a pair of keys and a certificate for establishing secure communication links

- Apart from all above, *servers* also communicate among themselves
   - Examples:
      1. `kube-apiserver` talking to `etcd`
         - `kube-apiServer` is a client of `etcd-server`
            - The only component in the *master-node* which talks to the `etcd-server`
         - can use the same keys which uses for itself acting as a server, or generate new ones
      2. `kube-apiServer` talking to `kubelet-server` on each individual node
         - Can use the original ones, or generate a new certificate and key pair

- K8S requires you to have at least one **CA** in your cluster for signing all these many certificates
   - The **CA** would also have it's own pair of certificates and key

# 147. TLS Certificates Creation
- Different tools available
   - *EasyRSA*
   - *OpenSSL*
   - *CFSSL*
- We will be using `openssl`
### Certificate for `CA`
- `openssl genrsa -out <keyName>.key 2048`
- Using the following command to generate a *certificate signing request* along with the already generated key
```
openssl req - new -key <keyName>.key -subj "/CN=<KUBERNETES-CA>" -out <CertName>.csr
```
- In the above command `CN=` is used to specify the name of the component that the certificate is going to be used for
- Finally we could sign the certificate using the following command
```
openssl x509 -req -in <certName>.csr -signkey <keyName>.key -out <certName>.crt
```
- Since it is for `CA` use it is signed by the `CA` private key, which was generated in the first step
   - This very same key will be also used to sign all other certificates from other components inside our cluster
- For all other certificates we will use this `ca keypair` to sign them
- At this point our `CA` has it's private key and **root certificate**

### Certificate for *Admin* User
1. Generate a *key*
```
openssl genrsa -out <keyName>.key 2048
```
2. Create a *CSR*
```
openssl req -new -key <keyName> -subj "/CN=<adminUserName>" -out <csrName>.csr
```
   - `adminUserName` could be anything, but it is the name that `kubectl` authenticates with, while running `kubectl` command
3. Generate a *signed Certificate* using the following command
```
openssl x509 -req -in <adminCSRName>.csr -CA <caCertName>.crt -CAkey <caKeyName>.key -out <adminSignedCert>.crt
```
   - Signing the *admin's* user certificate with our local *CA's* key and certificate is going to make it valid through out our cluster
   - We can also create a *group* for all the users for whom we want to give access to the cluster, and assign them to it; it happens in the second step, while creating the *CSR*
   ```
   openssl req -new -key <keyName> -subj "/CN=<adminUserName>/O=system:masters" -out <csrName>.csr
   ```

- This same process can be followed to generate certificates for all other components within the cluster
- Just keep in mind that for **System Components** their names should be **prefixed** with the `system` keyword, these are:
   * `kube-scheduler`
   * `kube-controller`
   * `kube-proxy`

## How to use these *Certificates*
- There are 2 ways to use them:
   1. Take the `admin` user as an example and think, as you want to use it to manage the cluster, the certificate can be used instead of *userName* and *password* as below
   ```
   curl https://kube-apiserver:6443/api/v1/pods \
   --key <adminKey>.key --cert <adminSignedCert>.crt --cacert <caCertName>.crt
   ```
   2. The other way is to move these parameters into a *configuration* file, called `kube-config.yml`, and define the `api-server` **endpoint** details, **certificates** to use
   ```
   apiVersion: v1
   clusters:
   - cluster:
      certificate-authority: ca.crt
      server: https://<api-serverEndpoint>:6443
     name: kubernetes
   kind: Config
   users:
   - name: <Ex: kubernetes-admin>
     user:
      client-certificate: <adminSignedCert>.crt
      client-key: <adminKey>.key
   ```
   - Also bear in mind that the *CA* certificate should also be given to all the components and users which want to communicate with each other, it is same as providing your own *CA's* certificate in your browsers

## Server side *Certificates*
### A) `etcd` Servers
- `etcd` certificate and **peer** certificates (In case you have *highly-available* `etcd` cluster)
   - **Peer** certificates must be generated additionaly
- You can specify all these certificates while starting the `etcd` server
   - Can be done using *key* and *cert* file options
   - Options are also available for specifying **peer** certificates
- The *CA* root certificate is required to verify the clients connecting to the `etcd` server are valid
### B) `kube-api` Server
- Most *popular* of all components within the cluster
- Aliases for it:
   * kuberenetes
   * kubernetes.default
   * kubernetes.default.svc
   * kuberenetes.default.svc.cluster.local
   * The ip of the host or the pod running it
- All of the above *aliases* must be present in the certificate file for it
- How to generate the certificate and key pair?
   1. Generate the *key*
   ```
   openssl genrsa -out <keyName>.key
   ```
   2. Generate the *CSR*
   ```
   openssl req -new -key <keyName>.key -subj "/CN=kube-apiserver" -out <CSRName>.csr -config openssl.cnf
   ```
      - Create an `openssl.cnf` file to embed all the names for it
      ```
      openssl.conf Content
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = nonRepudiation,
      subjectAltName = @alt_names
      [alt_names]
      DNS.1 = kubernetes
      DNS.2 = kubernetes.default
      DNS.3 = kuberenetes.default.svc
      DNS.4 = kubernetes.default.svc.cluster
      IP.1 = <IP>
      IP.2 = <IP>
      ```
   3. *Sign* the certificate
   ```
   openssl x509 -req -in <CSRName>.csr -CA <CACrt>.crt -CAkey <CAKey>.key -out <APIServerCert>.crt
   ```
- File needs to be passed in for `api-server` for establishing communication
   - The following are for `api-server` as a server
      * `ca-certificate`
      * `api-server.crt`
      * `api-server.key`
   - The following are required for `api-server` communicating to `etcd`
   as a client
      * `ca-certificate`
      * `api-server-etcd-client.crt`
      * `api-server-etcd-client.key`
   - The following are required for `api-server` communicating to `kubelet` as a client
      * `ca-certificate`
      * `api-server-kubelet-client.crt`
      * `api-server-kubelet-client.key`
### C) `kubelet` Server
- A key and certificate pair for *each node* on the cluster
- They will be **named** after their **Nodes'** names
- Once they are created use them in the `kubelet-config.yml` file on each node
   - Provide the `root CA` certificate and `kubelet` ndoe certificate and key
   - The `kubelet-config.yml` will look like:
   ```
   kind: KubeletConfiguration
   apiVersion: kubelet.config.k8s.io/v1beta1
   authentication:
      x509:
         clientCAFile: "ca.pem"
   authorization:
      mode: Webhook
   clusterDomain: "cluster.local"
   clusterDNS:
      - "10.32.0.10"
   podCIDR: "$(POD_CIDR)"
   resolveConf: "/run/systemd/resolve/resolv.conf"
   runtimeRequestTimeout: "15m"
   tlsCertFile: "<kubeletNodeCert>.crt"
   tlsPrivateKeyFile: "<kubeletNodeKey>.key"
   ```
- There are also `kubelet` **Client** certificates to talk to the `kube-apiserver`
   - Since nodes are *system components* the names for each of these certificates are: `system:node:<nodeName>`
   - And to grant them **Proper Permissions** by the `kube-apiServer` they should also be added to the group `SYSTEM:NODES` same as admin users were added to the group `system:masters`
   - Once they are generated they are going to the `kube-config` files

# 148. View Certificate Details
- How to the cluster was setup
   1. The **Hard** way
      - Generated by yourself
      - As **Services**
      - For **troubleshooting** and Inspecting **Logs**
      ```
      journalctl -u etcd.service -1
      ```
   2. The **kubeadm** way
      - Taken care of by `kubeadm`
      - As **Pods**
      - Will be used as our example
      - How to do this:
         * **Identify** All the certificates on the System
         * **Paths**
         * **Names**
         * **Alternate Names** or **ALT Names**
         * **Organization**
         * **Issuer** of the certificate
         * **Expiration** date
      - Look at file `/etc/kubernetes/manifests/kube-apiserver.yaml`
         * Identify each certificate file and take note of it
         * Look inside each certificate file to find more details about it
         * run the command `openssl x509 -in </cert/path/and/name> -text -noout`
            * Under `subject` you can find the **Name** of the cert
            * Under `X509v3 Subject Alternative Name` you can find the **Alternate Names**
            * Under `Validity` section, **Expiration** date can be found
            * Under `Issuer`
         - This same approach could be used to find information about all the certificates
         - Make sure you have right **Names**, **Alternate Names**, **Organizations**, most importantly issued by the right **Issuer** and the **Expiration** date
         - The certificate requirements are explained in details in the K8S *documentation* page
      - For **Troubleshooting** and Inspecting **Logs**
      ```
      kubectl logs <podName>
      # For example
      k logs etcd-master
      ```
      - Sometimes if the `kube-api` and the `kube-etcd` both fail, the `kubectl` won't function anymore; in such scenarios you can go one level deeper, you can use *`docker`* to get the logs for the pods
         - You can use `docker ps -a` to get all the containers and then use the `docker logs <contID>` to get the logs for that specific container

# 152. Certificates `API`
- so far --> `CA` Server + `Crts` for components
- A new admin
   - Generates `Key` + `CSR`
   - Current Admin Signs the `CSR` by `CA` Server
- But it expires after some time
- Where is the **CA** Server
   - It is only a pair of key and cert file
   - Whoever has access to these can sign any cert for the k8s environment
   - Just need to store them in a save place, and where ever they are stored that system becomes the **CA** Server
- Whenever you want to sign a cert, you can login to that server and sing it
- As of now, the `master-node` is working as our `CA`
   - The same approach is also applied in `kubeadm`
## Certificate `API`
- To automate the signing and renewing process of certificates
- An admin who already has access to the cluster, creates an object called `CertificateSigningRequest`
- The request can be **reviewed** and **approved** by the cluster admins
- And finally shared with the user
- How it is done?
   1. User generates the key `openssl genrsa -out <userKey>.key 2048`
   2. Creates the `CSR` with their name on it `openssl req -new -key <userKey>.key -subj "/CN=<userName>" -out <userCSR>.csr`
   3. The admin creates a `CertificateSigningRequest` object
   ```
   apiVersion: certificates.k8s.io/v1
   kind: CertificateSigningRequests
   metadata:
      name: <maybeUserName>
   spec:
      expirationSeconds: 600 #seconds, it was in the lecture
      usages:
      - digital signature
      - key encipherment
      - server auth
      request:
         # The base64 format of the CSR created by the user
         # to get it just do the following
            # cat <userCSR>.csr | base64
            # and paste it here
   ```
   - Here is one which worked:
```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: akshay
spec:
  signerName: kubernetes.io/kube-apiserver-client
  groups:
    - system:authenticated
  usages:
    - client auth
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZV3R6YUdGNU1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQXpkSktBWGhxOUNGbWxqN3lLWE1hcjRIVGduNndackVWejNFQVorNVRuWllICjVob0dDczQ0QjNYektWT0NMeDFWeFBhMHZ2dWp1ZE9ZZWM5WkpRZ0lNZ291SWV1R0kxcFI2aWF1dDBRaE5LV3YKTklVL2RIcWd0cXREdzY4ci94WGtkZHhtckhGZzZZRklPYnlKZTVOTExCRzlJVHhxeGY0WUh0NHZzcU1DcnU5QgpGbnFlMU52MDdLL3ZzODZFWmZFM2ZXQ29EYWpUTDZ2Sk55cmo5dm1vb09QZ3Z4L0ZzWDduVG5OTWphdXdIOVRzCnpDbGFlak1qLzVkZGNVM0l5ZVhJOEtib05teHZkVzJwclNuZ3FlWk9ScWh5TEJ4M2svR3hoclAxakVwSnBnaXgKcjM1TGt3aWtxUy9NQU1iWEtPeDNGdW9wL2VLVmIrd2dYOGxxT3FZeExRSURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBRGl4RitSQW5yV3JxU2UycVczMEREYm9peW1xUDNzTytTcTlocktBKzVjaTZGWjNKUEJxCnl6RHVEenY0ZTljS0Z0STBOT1lvcjBHWEJ1eTdTckQ1a3BncGY5T21nVVFzUDZkeDYxN3VoY3hhRGdYdi9MVmoKRTFEVFpqVXZpaUU3V1JKcGJqL1plZ3V6RGtYMVdtVWdNTGxNRUZ4V3hjR210dkdzc0hraU50WTJ2d1oxMUJzNApnRkNBSTZ4REFUOHZRM1hSQ3Z4OTZlT0wzY092NjVWRDdtbHBUazJDVWFOSTdyMkhoY2dOOFRYMWJHYUkySS8wCjZ0YjkvWjFMWlZKVHpTUzlmU1dKVTFncU40WDVabVMydVZLNVNlelhtbmM5emFjR2ZyRFBqS1M2YlZIRnFVcEoKbFJPQnYwTytiVzd0ZkxOdFNaSFM3Ly9ZVjNlQkhycFprQm89Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
```
      - The `.spec.request` field was generated using this
      ```
      cat akshay.csr | base64 -w 0
      ```
      - `-w 0` prints in a **Single Line**
   4. All the `CSRs` on the cluster can be seen by the admins using `k get csr`
   5. Can be **Approved** using the command `k certificate approve <csrName>`
      - K8S signs it using the `CA` key and generates a signed certificate for the user
      - Can be **Rejected** using `k certificate deny <csrName>`
      - Can be **Deleted** using `k delete csr <csrName>`
   6. The Signed Certificates can be viewed `k get csr` and `k get csr <csrName> -o yaml`
      - The part that we are concerned with is at `status.certificates`
   7. It is in `base64` you just have to decode it `echo "status.certificates"|base64 --decode`
   8. Share it with the user
- All the certificate related operations are done by the `controller-manager`
   - The responsible components within the `controller-manager` are
      - `CSR-Approving`
      - `CSR-Signing`
   - The controller manager has two options
      - `--cluster-signing-cert-file`
      - `--cluster-signing-key-file`
      - For `CA` key and cert, in order to sign other certs
