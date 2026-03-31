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
  - These configs are related to NTLM loggin, security group modifications and so forth
    - Policies can be explained by the **Explain** tab on them
    - Advanced Audit policy configuration
      - Multiple policies are activated here, and basically they will provide us with logs for events
      - Policies here are specifically for Defender for Identity
    - Local Policies 
      - 3 policies related to NTLM traffic
    - Auditing should also be enabled on the domain from the domain properties

### Enable SAM Remote Calls (SAM-R)

- Assume a help desk user's acocunt is compromised on a machine by a hacker
  - Attacker can escalate priviliges, since it is a help desk's device 
  - This is referred to as **LATERAL Movement Attack**
  - Microsoft Defender for Identity can detect these types of attacks
    - Additional options on a group policy are required to detect this
    - This group policy won't be assigned to the DC

### Installing the sensor

- Defender for Identity
- Sensor should be installed on the domain controller, and can be downloaded from the Security.microsoft.com

### Advanced configuration: Entity Tags

- Why?
  - Detections rely on them
    - Sensitive groups in the org
      - You can configure defender for identity specifically for these groups
- Types:
  - Sensitive
    - High valued assets
    - Lateral Movement for objects
    - Default groups included
      - Admins, server operators, backup operators and etc..
  - Honeytoken
    - Trap for malicious actors
    - Authentication attemps
  - Exchange
    - Only Exchange Servers

### Advanced Configuration: part 1

- After sensor installation it will be visible in the defender
  - Settings --> Identities
    - The installed sensor should already be visible there
- Settings for the sesnor and customizations are to be found here

### Advanced Configuration: part 2

- More settings related to the Defender for Identity

### Summary

- Summarizing everything

## Managing Defender for Identity

### Module Introduction

- Security recommendations
  - Related to security posture
- Detection capabilities
- Overview of Alerts

### Overview of Security Posture Assessments

- Detection on known misconfigruations
- Active Monitoring
- Accurate reports

### Managing Security Posture Assessments

- Focusing on the secure score for the identity
- Can be filtered based on different criteria, can see ranks, score impact and other details
- 

### Overview of Alerts

- Reconnaissance
- Persistence and privilege escalation
- Credential Access
- Lateral Movement

### Working with Alerts

- Export an alert
  - As a CSV file, can be worked with as a raw file
- Can track back alerts to the main incidents
- Tuning can be done on the alerts
- Alerts can be linked to incidents
- Creating new incidents
- Alerts history
- Incidents can be investigated from here also
- Assets related to the incident can also be interacted with
- Microsoft Defender Experts

### Troubheshooting

- Log files
  - Sensors
  - Sensor updates
  - Deployment Logs
- Known issues
  - Access to the internet
  - Other not very important issues

### Module Summary

- Security posture assessments
- Detection Capabilities
- Overview of Alerts
- Mitigate Threats Using Microsoft 365 Defender
- SECURITY ALERT LAB by Microslop
