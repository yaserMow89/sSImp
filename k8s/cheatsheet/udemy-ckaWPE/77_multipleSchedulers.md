Multiple Schedulers
===================

- K8S cluster can have multiple *schedulers* at a time
- While creating a **pod** or **deployment** you can have it scheduled by a specific scheduler
- Multiple schedulers --> different names
- Default scheduler name is `default-scheduler`
   - `scheduler-config.yaml`
      - Content looks like this
      - The purpose of the file is mainly for setting the name for the scheduler
      - It is not necessary for the default scheduler, but if you are creating custom ones and intending to use them, they should have a name that you can address them with the name
      ```
      apiVersion: kubeScheduler.config.k8s.io/v1
      kind: KubeSchedulerConfiguration
      profiles:
         - schedulerName: default-Scheduler
      ```

## How to deploy your own scheduler
- Earlier used to be done as a process, but these days you do it using a pod, same as every other control-plane component, and below is how to do it:
   - Create a *pod* definition file
      - Pass `kubeconfig` property,which is the path to the scheduler config file and contains the authentication information to connecto to the k8s **api-server**
      - pass custom *kube scheduler configuration file* as a `config` option
         - The *name* is also specified in this file
         - One more option for this file is `leaderElectOption`
            - In case you have multiple copies of the scheduler runing on different master nodes
               - Cause only one can be active at a time
      - This is not complete


- Using a new shceduler is by specifying the scheduler name within the new pod or deployment as `schedulerName` field; comes under `.spec.schedulerName`
   - If scheduler is not configured correctly the new pods will remain in a **pending** state
      - If the logs are looked at, it maybe understood that the *scheduler* causing the problem

## Useful commands
   - To know which scheduler has picked up a pod
   ```
   k get events -o wide
   ```
      - Is seen under the `source` column
   - `k get logs <schedulerName> --name-space=<namespaceName>`
