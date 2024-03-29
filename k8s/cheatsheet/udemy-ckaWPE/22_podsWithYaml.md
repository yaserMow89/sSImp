Pods with Yaml
==============

- A k8s definition file always contains 4 top (root) level fields:
- They are also required fields (Must have them in the configuration file)
   1. **apiVersion**
      - The version of the k8s api, being used to create the object
   2. **kind**
      - Type of object
   3. **metadata**
      - Data about the object
      - Data under this label are in form of a **dict**
      - *name* field is a string within a dict
      - *labels* is a dict within a dict
   4. **spec**
      - Depends on the object to be created
      - It is a **dict**
      - *containers* --> can be either a list or array, cause we may have multiple containers 
