# Microsoft Defender Introduction

## Overview

- Nothing important

## Breaking down microsoft defender

### Introudction

### Putting the defender suite into perspective

- Phishing email
- Insiders
- Defender components
  - Defender for o365
  - Defender for identity
    - DC sync and DC shadow attack
    - Azure AD identy protection
  - Defender for endpoint
  - Defender for cloud apps
  - Insider risk management protection
- All the above events and components can be in a single place called as **Sentinel**

### Microsoft Defender for Identity

- Works primarily with AD
  - Using some log sources and pushed to Online Defender for Identity
- ALso ties into MS 365 Defender Suite
  - This would enable to enrich the detection with detections from Endpoints, office, and more
  - For example you can get a full flow of an identity being compromised, starting from an Ednpoint
- Key Points: 
  - Monitor and Protect Identities
    - Permissions and Group Memberships
    - **Behavioural baseline** for users
      - This is used in combination with the threat intelligence to give you reports about suspicious activities and behaviours
  - Identify suspicious behaviour
    - Reconnaissance (enuerating AD)
    - Lateral movement paths
      - How a non-privilleged could lead to a privilleged account being compromised
    - Domain dominance
      - Specifically related to domain Sync, or domain shadow attack
  - Clear insights
    - Incident Information --> Full info
      - Who was involved, what was involved, lateral path that led to the compromise
    - Timeline

### Microsoft Defender for Endpoint

- Diverse support for OSes
- Basically a script that turns on the functionality to stream events to the cloud Defender for Endpoint
  - Once there, everything takes place there for analysis, intelligence and etc..
- Ties in with MS 365 Defender
- Key Points:
  - Endpoint Protection and Response
    - Detect, investigate, and respond
    - Advanced Hunting
      - Hunt for data on endpoint state
    - Automated investigation and remediation
      - Can be tuned according to the business needs
    - Attack surface reduction, Thread and Vulnerability Management (TVM) and more
- Cloud Analytics
  - Device Learning
    - Big data, and unique optics
  - Behavioural Signals
- Threat intelligence
  - MS threat experts and more
  - Identify Attackers Tools, techniques and procedures (TTPs)
  - Alert timeline

### Microsoft Defender for Cloud Apps

- Typical deployment
  - Various deployment modes, to support the organizations
    - For example Endpoints, and alongside them firewall data and proxy logs can also be used
- All above data can be fed to the Defender for cloud Apps
  - It can also connect to other cloud apps -- Can be done using app connectors
- Can track what your users are doing
  - As an example, you can see all the cloud apps that your users are using
    - You can create policies to deem specific apps as sanctioned or unsanctioned
- Key Points
  - Visibility
    - Cloud services --> all types of them
    - Risk Ranking --> for all these cloud services
    - Identify users --> The ones that are using thses cloud services
  - Data Security
    - Identify and control dlp
    - Respond to sensitivity labels
  - Threat protection
    - Adaptive access control
    - User and entity behavioural analysis
  - Compliance
    - Cloud governance
    - Data residency and compliance

### Microsoft Defender for Office 365

- Typical Deployment
  - Email addresses
    - Filtering out bad email and only sending non-malicious email to the end user
  - Protection policies
    - Are not only limited to email, can be deployed to Sharepoint, teams, outlook
- Key Points
  - Threat protection
    - Policies that concern things like attachements
    - Links to scan
    - Anti-phishing protection
  - Investigation and response with automation
    - Threat explorers
      - Currently trending threats and info about the threat, like target orgs, and so on
    - Threat trackers
      - How threats move along and how they would affect our org
      - Enabling us to deploy countermeasure
    - Automated Investigation and Remediation
    - Attack simulation training

### Microsoft Sentinal

- Birds eye view across your organization
- A single solution that would give you:
  - Attack detection
  - Threat visibility
  - Proactive Hunting
  - Ability to have threat response
- Centralized data collection
  - Data Connectors
  - On-premise and multi-cloud
- Detecting and responding to threats
  - Threat intelligence
    - Can be leveraged across all the datasets that you bring in for better detection capability
    - Built-in detection Rules
    - Hunting
      - KQL querries to querry all different data sets that you have
    - Incident Management
      - Orchestration and Automation

### Summary
  - Identity
  - Endpoints
  - Cloud Apps
  - O365
  - Sentinal
    f
