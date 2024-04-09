Imperative VS Declarative & kubectl apply
=========================================
1. Imperative
   - *what* and *how*
   - *checks*
      - make decisions based on the output coming from checks
   - using *commands*
      - Two ways to do it:
         * A. Using commands
         * B. Wasn't discussed
      - `kubectl replace`
         - returns an error, if the object doesn't already exist
      - Other Imperative commands:
      ```
      # For creating an object
      kubectl run
      kubectl create
      kubectl expose

      # For updating an object
      kubectl edit
      kubectl scale
      kubectl set
      ```
   - Some Useful commands:
   ```
   kubectl run nginx-pod --image nginx:alpine

   kubectl run redis --image redis:alpine --labels="tier=db,secLabel=secVal"

   kubectl expose pod redis --port=6379 --name redis-service

   kubectl create deployment  webapp --image=kodekloud/webapp-color --replicas=3

   k run custom-nginx --image nginx --expose --port 8080

   kubectl run custom-nginx --image=nginx --port=8080

   k create deploy redis-deploy --namespace dev-ns --image redis --replicas 2

   kubectl run httpd --image=httpd:alpine --port=80 --expose
   ```
   - This [link](https://faun.pub/should-i-configure-the-ports-in-kubernetes-deployment-c6b3817e495) is for better understanding **expose** port
2. Declarative
   - *what* (requirements)
   - *intelligence*
   - using *files* to define the desired state of the infrastructure
   - `kubectl apply`
      - Intelligent enough to create the object, if it doesn't already exist
      - Multiple object configuration files
         - use a path to all the objects

## kubectl *apply*
- Apply command takes into consideration *local file* and the *last applied configuration* before making a decision on what changes are to be made
- If the object does not exist, after creating it a config file similar to our *local file* is created within *kubernetes* (named as *live object configuration*); with some additional fields to store the status of the object
- In the process of applying a *local file* the `yaml` is converted into `json`, and then stored as the *last applied configuration*
- And if changes are made and applied, all the three files (*local file*, *last applied configuration* and *kubernetes* or also known as *live object configuration* file) are compared to understand what further changes are due
- First changes are written to the *kubernetes* (or *live object configuration*) and then also to the *last applied configuration*, to keep things updated
- The file *last applied configuration* is not actually a file, but rather is an annotation to the *live object configuration* file, referenced as *last-applied-configuration*
- *last applied configuration* is only available using the `apply`, when the `kubectl create` or `kubectl replace` are used this information is not stored
