# Implementing and Managing Defender for Identity

## Course Overview

### Course Overview

## Planning and Deploying Defender for Identity

### Module Introduction

- Relies on logs that are coming from your on-prem AD
- These logs are fed to the Defender for Identity (Cloud)
- Defender for Identity will leverage the, threat intelligence, behavioural analysis and start working to give you actionable insights
- Will detect lateral movements, pass-the-hash, enumeration and so forth
- Part of the MS 365 Defender, so it can use other defender tools to put it's detection one step further
- Key Points
  - Monitor identities and protect identities
  - Identify and investigate suspicious behaviour
    - Reconnaissance (enumerating AD)
    - Provide clear insights

### Before you Begin

- Licensing
  - EMS E5 / A5
  - MS 365 E5 / A5 / G5
  - MS 365 Security
- Accounts
  - Directory Service Account (Read Only)
  - Permissions --> Global/security administrator
- And some other things needs to be done before doing it

### Enable the required Auditing

- Configuring correct windows even collection, in order to get all the correct alerts and log files
  - These configs are related to NTLM loggin, security groups and so forth
