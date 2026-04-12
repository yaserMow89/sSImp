# Implementing and Managing Defender for Endpoint

### Overview

## Planning and Deploying Defender for Endpoint

### Module Introduction

### Getting Started

- Licensing
  - Various options
    - Plan 1 & plan 2
      - Plan 1
        - Basic protection capabilities
      - Plan 2
        - Advanced Hunting
        - Automated Investigation and Response
        - Vuln management capabilities
      - Only on Windows (This is not true anymore)
    - Defender for Business
    - Defender for Vulnerability management add-on
- Hardware
  - Windows
  - Servers

### Getting Started with the Configuration: part 1

- Live reponse and Live Response for Servers

### Getting Started with the Configuration: part 2

- Licenses
- Email notifications
  - Alerts
  - Vulnerabilities
- Auto Remediation

### Working with Roles and Permissions

- RBAC
  - AD secruity Groups
- Adding role

### Configuring Device Groups

- Group devices
- Can be grouped based on different elements, like name, os, tag, domain and etc..
- User groups can be granted administrative rights on these groups
  - Better for scopping

### Architecture and Deployment Methods

- Clound Native
- Co-Managed
  - On-prem and Cloud based
- On-prem
  - Local script
  - GPO
- Linux
  - Automate

### Endpoint Onboarding Process (Skipped)

- Can be found in Endpoint settings in Defender portal

### Onboarding Using a Local Script (Skipped)

### Onboarding Using a Group Policy (Skipped)

### Defender for Endpoint key features

- Core vuln management
- Attack surface reduction
- Next-Gen Protection
- Endpoint Detection and Response
- Automated Investigation & Remediation
- Microsoft Threat Experts

### Vulnerability Management

- Discovery & Monitoring
  - Baseline Assessments
    - Center For Internet Security (Benchmark)
  - Software Visibility
  - Vulnerabilities
  - Network Share Assessment
  - Authenticated Scans
    - Scan unmanaged Devices
  - Threat Analytics
  - Browser & Digital Certificate Assessments
  - Hardware and Firmware Assessment
- Risk Based Prioritization
  - Emerging Threats
- Remediation and Tracking
  - Ivolve IT
  - Block Unwanted Apps

### Working with Vulnerability Management

- Remediation
  - Creating Intune Tickets
- Overview
- Exception

### Attack Surface Reduction

- Enable admins to focus on things that they should be focusing on
- Protects against
  - Software Behavior
  - Executables
  - Obfuscated or suspicious scripts
- Requirements
  - OS related requirements are in place
  - Defender is in Active mode
- Plan
  - Identify Business Unit
  - Identify Champions
    - Lab mice :)
  - Inventory of Business Apps
  - Define ASR (Attack Surface Reduction) Rules reporting
  -  Deployment Rings
- Test
  - Audit mode
  - Understand Reports
  - Assess impact
  - Exclusions
- Apply
  - Block Mode
  - Understand Reports
  - Assess imapct and Revert if required

### Creating Attack Surface Reduction Policies

- None found
- 

### Next Generation Protection

- Augmenting detection capabilities with enahnced functionalities
  - Behavior based, Heuristic Protection
    - Near instant Detection
    - Machine Learning
    - File and process behavioral monitoring
  - Cloud Delivered Protection
    - Microsoft Advanced Protection Service

### Automated Investigation and response

- Supported OS
  - Not all
- Automation Levels
  - Full or Semi-Automation
  - Leverage **Device-Groups**
- Tracked in Action Center

### Workign with Automated Investigation and Response

- Done based on **Device-Groups**
- Can be done without **Device-Groups** using the **Ungrouped devices**
- **Action Center**
  - Can be for tracking the actions

### Module Summary

- Skipped

## Leveraging the Execution Lab to Enhance Your Skills (RETIRED)

### Module Introduction

- Evaluation Lab
  - Creating Lab
  - Running Simulations
- Challenges
- Cumbersome env
- Track Activities
- Eliminate Complexities
- Easy to Deploy
- Centralized Results

### Setting up the evaluatoin Lab

## Manage Defender for Endpoint

### Module Introduction

### Managing Incidents and Alerts

- Ask Defender Experts
  - Review and provide feedback by MS experts
- **Restrict App Execution**
  - All apps that are not from Microsoft
- **Collect Investigation Package**
- **Live Response Sessoin**
  - Interact with Endpoint directly from the defender portal
  - `help` can give you a list of all available commands
  - Also can upload a file with this session
- **User account** actions
  - Many things like having all the related incidents

### Troubheshooting Overview

- Onboarding
  - Logs for this: Event Viewer --> Windows Logs --> Application --> WDATPOnboarding
- Troubhleshooting mode can be enabled for devices
  - All details are visible under the timeline


### Module Summary
