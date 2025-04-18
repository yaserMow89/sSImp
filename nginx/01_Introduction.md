
## 02 Webservers

- Apache --> a new process for each request

## 03 Nginx introduction

- Best for serving static content

## 04 Nginx archeticture

- Event driven archeticture (assynchronous processing)
- Event handling in nginx
  1. Incoming request (HTTP/HTTPS)
  2. Event loop
    - Logs the request and checks for new requests, without blocking
    - Will continue to work continuesly
  3. Processing event
    - If it is paused by waiting for some data, pauses the request and moves on to the next event
  4. Response Sent
- Worker process
  - Each request is handeled by a worker process
  - Operating within the event driven model
  - Each runs independently
  - Each worker process has an *event loop* to manage incoming connections
- Master process
  - Oversees the worker processes
  - Restarting the worker
  - Assigning the configuration
  - Managing and controlling the life-cycle of the worker processes

##  05 Nginx Use cases

- Load Balancing
  - Makes sure traffic is handeled properly
- Caching
  - You really need an EXPLANATION this also!!!
- Reverse/Forward Proxy
  - Reverse proxy
    - Same as loadbalancer, but with the difference that it works as the middle man, between server and the customer, while loadbalancer makes sure that the load is distributed evenly across a fleet of servers
    - An LB should have more than one backend, while reverse can also work with only one
  - Forward proxy
    - Same as Reverse proxy, with the only difference that forwards the outgoing traffic rather than incoming traffic
    - Can be used for online identity protection, blocking access to certain content, and etc..

## 06 Summary
