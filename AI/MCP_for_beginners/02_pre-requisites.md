# Pre-requisites

## Introduction

- Model Context Protocol
- Enhancing interactions between AI models and external data sources
- Desinged by Anthropic
- Ability Enhancement
- Why to use them
  - Cutoff dates with date fed to the LLMs
    - No access to live data sources
  - Personal or private info access
  - Contact with external systems
- Enable LLMs to access data and deliver better assistance

### Key components

- MCP Client/Host
  - Traditional Client/Server Model
  - Client
    - Acts as a messanger
- MCP Protocol
- MCP Server
    - Is talked to by the MCP Client
    - Acts as a secure gateway to the external systems
- External Services
  - Actual resource or service that the LLM needs to interact with
- MCP primitives
  - Resources
    - Data that can be red by LLM
    - MCP server can be setup to expose data
  - Tools
    - Represent actions that LLM can ask the MCP server to perform on it's behalf in the external system
  - Prompts
    - Pre-defined templates or structured interactions that the server can offer
    - Provided by the server

### The Flow

- Language Model
- Client Application
- External Services
- Examples of things that can be done by it:
  - File system interaction
  - Github interaction
  - Web search
  - Database Access

### MCP Benifits

- Standardization
- Separation of concerns
- Extensibility
- Reduced Hallucinations
- Enahnced Capabilities

## What problems does MCP solve 23:20

- Information Silos
- Integration Complexity
- Limited context
  - Cutoff dates
- Development overhead
- Scalibility barriers
- The universal connector
  - Standardized data exchange
  - Two-way communication
    - Retrive info and triger actions
  - Secure local first archeticture
    - Data just stays local
  - Developer Simplicity
- Lower maintenance as protocol absorbs API changes
- Developer Experience -- Enterprise applications
  - With MCP
    - Standardized MCP servers
    - One protocol for auth
    - Unified Context Management
    - Consistent error handling
    - Standard protocol for all internal tools
    - Seamless access to knowledege repos
    - Unified security model
    - Reduced maintenance upon updates
  - Without MCP
    - Code for each API integration
    - Custom protocol for each auth
    - Manage context sharing per integration
    - Error Handling per API
    - Proprietary connectors to data sources
    - Limited access to knowledge bases
    - Complex security integration strategies
    - High maintenance upon updates
- MCP in action
  - Claude Desktop
  - Microsoft Copilot studio
  - Enterprise assistance
    - Connect to internal knowledge bases
  - Data Analysis
  - Development Envs

## Understanding MCP Components: Tools, Resources, Prompts

- 4 main jobs
  - Keeps different software components organized
  - what software can do
  - sets rules for how programs communicate
  - Adding foundation for adding new pieces later
- 3 Main parts
  - Tools
    - Executable actoins like plugins
    - For actions
    - Doers of the MCP
    - Specific Structure
      - Clear instruction for input & output
      - Can be called using CLI
      - Can by synchronous or asynchronous
      - Special permissions to work
    - Examples: web-search, code execution, image generation, file reading, api calls, data analysis
  - Resources
    - Like memory
    - hold and share knowledge
    - trustworthy and reliable facts
    - Can be structured or unstructured
    - May be statically embedded or dynamically retrieved
    - Examples: cooking handbooks, pdf file, customer databases, API documentation
  - Prompts
    - Instructions
    - Set programs personality and tone
    - step-by-step instruction for tasks
    - create templates for common tasks
    - pre-built system directives
    - In case of MCP they are pre-processing step, to make sure what comes out of LLM is exactly what the user expects
  - They are not in all MCP servers

## Demo: Run your first MCP Tool (weather tool)

-  
-
