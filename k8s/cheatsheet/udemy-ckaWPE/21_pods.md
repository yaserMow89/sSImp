Pods
====
- Encapsulation of containers
- Single instance of application
- smallest unit possible to be created in k8s
- pods usually have 1-to-1 relationship with containers
- **Helper** containers
   * Share the same network space
      * So both of them are localhosts
   * Can easily share volumes also
- **Multi-container** pods are rare 
