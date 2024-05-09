IP Address Management in Weave
==============================
- **Bridges** and **Pods**

- According to **CNI** it is the responsibility of the **CNI Plugin** to manage all
   - Was true with the basic plugin we built-in earlier
- How to manage them
   - Not to assign *duplicate*
   - Release when *released*
   - ...
- An easy way is to store them in a list (file)
   - And manage it in code
- Instead of managing this by ourselves, **CNI** comes with two builtin plugins in which you can outsource this task too
   - **plugin** for managing the ip-addresses locally on each host, is the host local plugin
      - It is named as **host-local plugin**
      - But we should invoke the plugin in our script
      - We could also make our script *dynamic* to support different kinds of plugins
      - The **CNI** configuration file has a section `ipam`
      ```
      "ipam": {
         "type": "<plugin-type>",
         "subnet": "<subnet>",
         "routes": [
         { "dst": "0.0.0.0/0"}         # Example of default route
         ]
      }
      ```
### How `weave` Manages Network
- by default `10.32.0.0/12`
   - Split them equally among the nodes
   - They are still more configurable with additional options



## Some Useful commands
- `/etc/cni/net.d` --> Can be looked upon to find the network configuration
- `k logs -n <nameSpace> <podName>` --> Used to find the `ipalloc-range`
- `k exec <podName> -- <command> <arg>`
