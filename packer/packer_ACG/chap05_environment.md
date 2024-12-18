# Environment

## Packer plugins

- More functionality for **Builders**, **Provisioners** and **Post-processros**
- Download --> build --> place it in the proper directory with proper name
   - name should follow this rule
      - `packer-<TYPE>-<NAME>`
      - `<TYPE>` could be either of the followings:
         - Builder
         - Provisioner
         - Post-Processor
      - `<NAME>`
         - Actual name
