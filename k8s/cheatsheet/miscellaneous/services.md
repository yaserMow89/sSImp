Services in K8S
===============

- Content of this page is taken from k8s official doc, here is the [link](https://kubernetes.io/docs/concepts/services-networking/service/)

- Exposing network application that is running as one or more pods in your clusters
- No need for changes in existing application
- Keeping better track of pods
- Service API is an **abstraction**
- Each service defines a logical set of **Endpoints** (usually they are pods, along with a policy about how to make them accessible)
- Decoupling is enabled by service **abstraction**
- The set of pods targeted by a service can also be without *selectors*
- *HTTP* workload, may go with *Ingress*
   - *Ingress* --> Not a service type
- Service is *object*
- Set of *EndpointSlices*


### Port Definition:
   - Port definitions in pods have **names**, and these names can be referenced in the `targetPort` attribute of a service, consider the following example:
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc                  # Name attribute is defined here

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc                 # Instead of directly passing the port, we are using it's name
```

- This offers more flexibility, because you can define different *targetPorts* for different pods and still refere to all of them using the *name* attribute
