Config Maps
===========

- The content of this file are taken from the following links:
   1. [link](https://kubernetes.io/docs/concepts/configuration/configmap/)

- API object used to store non-confidential data in key-value pairs
- Can be consumed as env vars
- Less than `1 MB`
- Fields
   - `Data`--> *UTF-8*
   - `binaryData` --> *binary data*
- Pod and configMap must be in the *same namespace*
- Four ways to use a configMap inside a pod to config a container
   1. Inside container command and args
   2. Env vars for a container
   3. File in read-only volume, for the application to read
   4. Write code to run inside the pod that uses the kubernetes API to read a configMap
