Commands - Not required for the exam
===================================


- Commands, Entry Points and Arguments in Docker

- Containers stay alive as long as they have a process to run (A Purpose to server)

## Commands in containers
- Different ways to specify
   1. **shell form**
      `CMD command param1`
   2. **json form**
      `CMD ["command", "param1"]`
- What if you want to change the input value for the `param1`
   - One option is to **override** the startup command
      `docker run <imageName> <command> <param1>`
      - This way you pass both the command and the parameter
   - **entrypoint** instruction could also be used
      - Define an entrypoint in the build file
         `ENTRYPOINT ["command"]`
- Difference between `CMD` and `ENTRYPOINT`
   - In case of `CMD` the command and parameter appended to it are replaced by the command sent while running the container
   - In cas of `ENTRYPOINT`, whatever is passed while running the container is appended to the `ENTRYPOINT` command
   - What if you want to have a default value, in case you don't get parameters passed by user and you have used `ENTRYPOINT`?
      - In this case you can use both the `ENTRYPOINT`(To run the actual command) and the `CMD` (To pass the parameter, in case user does not pass parameter)
      - This only works if both `ENTRYPOINT` and `CMD` values are passed in *JSON*
- If you want to change event the `ENTRYPOINT` you can just pass the `--entrypoint` switch while running the container
## Commands and Arguments in k8s *Pod*
   - How to pass an argument?
      - Anything passed to the docker
   - Anything appended to the docker run command or replaces the `CMD` field in container definition file, goes to the `args` property in a *pod* definition file
   - Changing the `ENTRYPOINT` for a container in pod would be done using: `command` field
   -
