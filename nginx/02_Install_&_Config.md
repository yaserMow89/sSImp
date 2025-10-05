## 1 Install and Config Introduction

## 02 Nginx Overview

- Main config file
- Structure:
  1. Global Settings
    - Entire nginx server
      - User privileges
      - Number of worker processes
      - Rate limiting settings
  2. Events Block
    - Connections
    - Event Model
  3. HTTP Block
    - Web traffic
    - Server blocks (v-host)
      - Multiple websites (v-hosts) on a server
    - Http optimization
    - Security groups
  4. Server Block
    - How nginx handles requests
    - Essentially configuring nginx
    - Using ip address or server_name to response with the correct server (website)



```config
user www-data;                  # User to run the nginx as
worker_processes auto;          # Number of worker processes, auto will adjust with respect to CPU cores
pid /run/nginx.pid;             # Location of the PID --> Nginx master process

events {
  worker_connections 1024;      # Controls network connections, total connections = worker_processes * worker_connections
}

http {

}

server {
  listen 80;                    # Port nginx should listen on, can be 80 or 443 or something else
  server_name example.com www.example.com; # handles the domain or subdomain, how nginx would know what content to serve

  root /var/www/example.com;    # Directory where the website's files would be
  index index.html;

  location / {
    try_files $uri $uri/ =404;  # Root of the domain, try_files would look for files in the root directory and if not found then returns a 404
  }
}
```

- Nginx Modules
  - Many moduels and many directives for each of them

### Directory Structure and Important Configuration Files

- `/etc/nginx/nginx.conf` --> Universal across distros
- `/etc/nginx/sites-available` --> configuration for each v-host or website
- `/etc/nginx/sites-enabled` --> symlink to the files in `sites-available`, should be done manually
- `/etc/nginx/conf.d` --> Additional configs
- `/var/www` --> Actual sites for most *debian* based
- `/etc/nginx/mime.types` --> Define MIME types for file extensions, helps server to understand different file formats
- `/etc/nginx/nginx.pid` --> Stores the process ID
- `/var/log/nginx/` --> Access and error logs

### Nginx Commands

- `nginx -h`
- `nginx -v` --> version info
- `nginx -V` --> detaild build of all configs
- `nginx -t` --> Checks configs for any issues, primarily for syntax
- `nginx -T` --> Sharing configs
- `nginx -s` --> Signal to the master process, stop, quit, reload, reopen
  - For example: `nginx -s reload`

## Installation and Configuration

- Package managers
- `apt`
- `yum`
- `brew`
- `choco`
- :)

## Demo: Nginx Install & Config

- `apt install nginx`
- A good practice to keep the sites configuration in the `/etc/nginx/sites-available` file

## Demo: First Website with Nginx

- Curling with host headers `curl --header "Host: helloworld.com" localhost

## Firewall and Ports

## Summary
