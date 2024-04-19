Encrypting Secret Data at Rest
==============================

- create a secret
```
k create secret generic my-secret --from-literal=key1=supersecret
k get secret my-secret -o yaml
```
- only **base64** encoded, *not encrypted*

## How this data is stored in the `etcd` server
- Install `etcdctl`
- If we get the current secret at `etcd`, using the following command
```
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/<secretName>
```
   - Gives you the secret
   - You can also pipe it into `| hexdump -C` will give you the secret again
   - The data is in *plainText* and without encryption
- Can also check whether encryption is enabled or not
```
ps aux | grep kube-api | grep "encryption-provider-config"
```
   - If nothing comes back, means that encryption is not enabled

### How to Enable Encryption
- You should just create a config file and pass it to `encryption-provider-config`
- You can decide which resources should be encrypted
   - Defined under `resources`
- You can encrypt using *providers
   - Some of the providers are:
      - Default is `identity`
         - Means *no encryption*
      - `aescbc`
      - `aesgcm`
      - `secretbox`
   - You can select any and provide it the key
      - `secret` in key is used to preform the actual encryption
   - The *order* that you write the providers is very important
      - The one at the top would be the first one used to encrypt; so for example if you use `identity` at the beginning means that no encryption is taking place
- A simple example would be:
```
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
   - resources:
      - secrets         # Resource that you want this file to be applied on
     providers:
      - aescbc:
         keys:
            - name: <keyName>
              secret: <Base64EncodedSecret>
      - identity: {}
```
   - To generate a 32 byte random key you can use:
   ```
   head -c 32 /dev/random | base64
   ```
   - And feed it to the `secret` in Encryption configuration file
- Add the encryption configuration file in the *kube-api-server* config file
- Once changes are made to the kube-api-server, it is going to restart and come up with the new changes
- Now if you run:
```
ps aux | grep kube-api | grep "encryption-provider-config"
```
   - You can see that it has encryption configured
- Now if you create a secret, and look for it you will find it encrypted
- Once encryption is implemented only new resources will be encrypted not the old ones, but if you update the old ones they are also going to be encrypted
- You can also encrypt all secrets using
```
k get secrets --all-namespaces -o json | kugectl replace -f -
```
