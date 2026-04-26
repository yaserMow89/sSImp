# Core Concepts

## HTTP vs STDIO for connection

- STDIO, HTTPS, and SSE
- STDIO
  - Standard input and output
  - Locally
  - inter-process communication for connecting with it
  - Application that send standard input to the MCP server
  - Local inter-process
  - One shot data flow
  - Local deve & cli tools
- HTTPS
  - Server is available publicaly or at least to other machines on the network
  - Multiple apps for a single mcp service
  - HTTPS prompt and HTTPS response
  - Similar like current day APIs
  - Individual TCP connection
  - Request-response data flow
  - short atomic tasks
- SSE
  - Server Sent Events
  - A persisten connection based on an initial request
  - For things that have to maintain connection between client and server, like chatbots
  - Single persistent
  - Streaming data flow
  - Interactive and streaming tasks

## Demo: Building Simple MCP Server
-
