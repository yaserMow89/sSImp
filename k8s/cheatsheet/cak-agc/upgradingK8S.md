Upgrading k8s using `kubeadm`
============================

## Upgrading the *control-plane* node:
1.  `kubectl drain <nodeName> --ignore-daemonsets`
2.
```
sudo apt update
sudo apt install -y --allow-change-held-packages kubeadm=<desiredVersion>
```
3.  `sudo kubeadm upgrade plan <desiredVersion>`
   - Creates a plan of different internal components that need to be upgraded
   - Spits out a command for upgrading
4.  Use the command given in the previous step to upgrade
5. Repeat step 2 for `kubectl` & `kubelet` also
6. `sudo systemctl daemon-reload`
7. `sudo systemctl restart kubelet`
8. `kubectl uncordon <nodeName>`

## Upgrading the *worker* nodes:
1. on the control-plane drain the worker node
2. go on the worker node
3. repeat the 2 step in the previous section
4. `sudo kubeadm upgrade node`
5. Do step 5 in the previous section
6. Do step 6 and 7 in the previous section
7. get on the control-plane node and do step 8 in the previous section, for the worker node
- The same set of steps applies to every node, which needs upgrading
