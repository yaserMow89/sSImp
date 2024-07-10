12. IAM Users and Groups Hands On
=============================

- Create User
- Create Group
- Add Tag on the User
- Permissions inherited from Group


13. IAM Policies
================
- Attaching policies at group level
- Inline policy
   - Policy attached to a use
- IAM JSON Policy
```
{
   "Version": "2012-10-17", # Usually
   "Id": "S3-Account-Permissions", # Optional
   "Statement": [
      {
         "Sid": "1", # Statement ID for the sake identification (Optional)
         "Effect": "Allow", # Could be allow or deny
         "Principal": {    # Which account/user/role this policy is applied to
            "AWS": ["arn:aws:iam::211125556118:root"] # Applied to the root account of my aws
         },
         "Action": [    # List of API calls that are either allowed or denied based on the Effect
            "s3:GetObject",
            "s3:putObject"
         ],
         "Resource": ["arn:aws:s3::::mybucket/*"]  # List of resources to which the actions are applied to
      }
   "Condition": # Optional, when this policy should be applied or not
   ]
}
```

14. IAM Policies Hands On
=========================
