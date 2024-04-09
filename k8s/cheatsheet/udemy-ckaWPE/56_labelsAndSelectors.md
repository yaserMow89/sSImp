Labels and Selectors
====================
## Labels
- Properties attached to each item

## Selectors
- Filter the labels
- To select a pod with already created label `kubectl get pods --selector labelKey=labelValue`

## Annotations
- Record for informatory purpose only

# Useful commands:
```
k get all --selector <labelKey>=<labelValue>                                           # List of all objects with specific label
k get all --selector <label1Key>=<label1Val>,<label2Key>=<label2Val>,...               # Filter through multiple labels
--no-headers                     # It is an option can be passed to avoid printing the header row (first row) with the output
```
