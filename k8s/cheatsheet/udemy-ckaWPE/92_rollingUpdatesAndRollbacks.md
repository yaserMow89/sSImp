Rolling Updates and Rollbacks
=============================

- In deployment

## Rolout and Versioning
- First Deploy trigers a *rollout*
- A new *rollout* creates a new deployment *revision*
- With every update the same process happnes; a new *rollout* and a new deployment *revision*
- Keep track of changes made to the deployment
- Rollback
- To see the status of *rollout* for a deployment
```
k rollout status deployment/<depName>
```
- To see history of *rollout*
```
k rollout history deployment/<depName>
```

## Deployment *Strategies*
### *Recreate* Strategy
- Destroy all and create newer versions
   - Application *Down*
### *RollingUpdate* Strategy
- One by one
- Seamless
- Default

## How to do this
- Using the *definition* file
- Using `set` command
```
k set image deployment/<depName> <contName>=<newImage>
```
## How upgrade happens in *Deployment*
- A new *replicaSet*
- Updated containers will be deployed inside the new *replicaSet*
- At the same time takes down the pods, in the old *replicaSet*
- Can be seen using the `k get replicasets`
   - You can see both *replicaSets*

## Rollback
- Undo a rollout
```
k rollout undo deployment/<depName>
```
   - In this way the pods in the new *replicaSet* are destroyed
   - And the old *replicaSet* will come up, with the old pods


## Some Useful *Commands*

- `k rollout status deploy/<depName>`
- `k set image deploy<depName> <oldImageName>=<newImageName>`
- `k rollout history deploy/<depName>`
- `k rollout pause/resume deploy/<depName>`
- `k rollout undo deploy/<depName>` --> To the last revision
- `k rollout undo deploy/<depName> --to-revision=<revNumber>`
- `k rollout history deploy <depName> --revision=<revNumber>`
