Monitoring Cluster Components
=============================


- Resource Consumption
- What?
- Node Level Metrics
   - How many?
   - How many healthy?
   - Preformance
      - CPU
      - Memory
      - Disk
      - Network
- Pod level metrics
   - Number of pods
   - Preformance metrics
- K8S Solution
   - As of now, no built in full feature solution
   - But there are some solutions available
      - Metrics Server
         - 1 per k8s cluster
         - Receives metrics from *pods* and *nodes*; aggregates and stores them
         - **In memory** solution
         - `kubelet`
            - `cAdvisor` or *container advisor*
               - Responssilbe for retreiving preformance metrics from *pods* and exposing them through the `kubelet` api for the Metrics Server
         - How to deploy
            - You can deploy with it's repo available on `github`
            - And then deploy the required components using `kubectl create -f <deploymentFiles/>`
               - Deploys a set of *Services*, *pods* and *roles* to enable the Metrics Server to pull for prefomance metrics from the *nodes* in the cluster
            - Once deployed give it some time to get the data
         - `k top node` can be used to see the metrics related to *nodes*
         - `k top pod` can be used to see the metrics related to *pods*
      - Prometheus
      - Elastic Stack
      - Datadog
      - Dynatrace
   - Hepster --> deprecated
