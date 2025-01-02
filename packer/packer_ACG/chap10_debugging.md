# Debugging

## The `-debug` Flag

- Should be placed in a specific place right after `build` and before the file name, like this `packer build -debug my_build.json`
- With the debug flag it will stop at every single step and would wait for the user to press *Enter* to continue to the next phase of the build process
- It will give you the chance to login to the remote device and figure out the issue

## The Breakpoint provisioner

- Adding an automatic stop on the build process at the point which we define the provisioner

```json
{
   "type": "breakpoint",
   "note": "Confirm Salt Provisioner"
}
```
