Image Security
==============
- defining `image: nginx` in a pod is actually:
   - `image: library/nginx`
      - The first part is the user or the account name and if nothing is provided it assumes it to be `library`
      - `library` default account where docker official images are stored
         - promote best practices
         - maintained by dedicated team, who are responsible for reviewing and publishing
         - If you were to use your own images, instead of `library` you would use your own **user Name** or maybe **company name**
- `registry`
   - It is actually `docker.io/library/nginx` ;)
   - `docker.io` or the first part is the image `registry`
      - where all the images are stored
      - Not only `docker.io`, many other are available
         - `gcr.io` --> google
   - Also **private registries**
- `repository`
   - the last part in `docker.io/library/nginx` which is `nginx`
   - can be made private
   - First you have to login --> on **docker**
      - `docker login <privateRegistryName.io>`
   - How to do on k8s
      - k8s images are pulled using `docker runtime`
      - First we have to create a `secret` of type `docker-registry` and fill it with the following data
      ```
      k create secret docker-registry <name> \
      --docker-server=<registryDNS> \
      --docker-username=<userName> \
      --docker-password=<pass> \
      --docker-email=<email>
      ```
      - `docker-registry` is a secret type for accessing *private* registries
      - Within the pod definition file under `.spec.imagePullSecrets` we pass the name for the `secret`, like this:
      ```
      spec:
         containers:
         ...
         imagePullSecrets:
            - name: <secName>
      ```
