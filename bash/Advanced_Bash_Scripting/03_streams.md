# Streams

## Overview

- 3 standard streams with a process in linux
  1. *stdin* --> 0
  2. *stdout* --> 1
  3. *stderr* --> 2

## Stdout and Stderr

- Not all commands generate *stdout* like `mv` commands
- Redirection symbol `>` only redirects *stdout* by default
  - Can use the **file descriptor** for *stderr* to redirect that also, which is `2`

```bash
ls -z > stdout.txt 2> stderr.txt
```

## File Descriptors

- File descriptors are integers that can be used to reference a logical artifact in our OS, such as an actual text file

## `/dev/null` Redirection to File Descriptors

- `2>&1` Redirect the *stderr* to a file descriptor 1
  - Redirecting both forms of output to the same location
- If you put a file descriptor number before the redirection command, will catch the stream and redirect it somewhere
- Whatever comes after redirection will be used as the destination for the output
- If we use an `&` symbol before the redirection symbol `&>`, it will act as a wildcard, and catches both *stdout* and *stderr*
- If we use an `&` symbol after the redirection symbol `>&`, it will mix both streams into a single stream
- `&>` and `>&` might look similar, but there are some key differences
  1. Adding it to the left `&>`, equals to mixing both streams of data into the same pipe
  2. Adding it to the right `>&`, means conducting both streams to the same place, but keeping them in seperate piplines
- This is useful if we want to conduct both *stdout* and *stderr* into the same file
- Looking at the example `ls -z 2>&1 > file.txt`
  - We take the *stderr* `2>&` and push it into the file descriptor *stdout* `1`
  - It is similar to `ls -z > file.txt 2>&1`
    - Here we put the file descriptor redirections at the end

## Input

- *stdin* or file descriptor `0`
- Redirecting input from a file using is treated as *stdin* while redirecting using the another command should be specified using *stdout*, since it is ouptut of another command
  - In the example below while we try to catch the output of the `echo` using the `0` file descriptor it won't work, since it is not `0` but `1`

```bash
cloud_user@b5f70ee6f11c:~$ echo "output" | test -t 0 && echo "output received"
cloud_user@b5f70ee6f11c:~$ echo "output" | test -t 1 && echo "output received"
output received
```

- we can assing a file descriptor to a file `exec 3<> file.txt`; `3` is the file descritpor here for the file `file.txt`
- The following is a good example on how to use the file descriptors

```bash
cloud_user@b5f70ee6f11c:~$ echo "Juan Carlos@kodekloud.com" > email_file.txt
cloud_user@b5f70ee6f11c:~$ cat email_file.txt
Juan Carlos@kodekloud.com
cloud_user@b5f70ee6f11c:~$ exec 3<> email_file.txt
cloud_user@b5f70ee6f11c:~$ read -n 4 <&3
cloud_user@b5f70ee6f11c:~$ echo -n "." >&3
cloud_user@b5f70ee6f11c:~$ cat email_file.txt
Juan.Carlos@kodekloud.com
cloud_user@b5f70ee6f11c:~$ exec 3>&-
cloud_user@b5f70ee6f11c:~$ cat email_file.txt
Juan.Carlos@kodekloud.com
```


## HereDocs

- what happens when we have a script that should automatically handle the process of creating a multi-line text file
- Working with multiline docs
- Heredocs work by sending input streams to other commands, programs or scripts
- For example the following **heredoc** sends a stream of data to the cat command

```bash
cat << EOF
line1
line2
line3
EOF
```

- heredocs can also be redirected to a file using named pipes, EX:

```bash
cat > file.txt <<EOF
line1
line2
line3
EOF
```

- heredocs with the commands that take standard input
- They work by `<<` and right after it comes the ***token***
  - Token can be anything as long as the beginning and the ending are the exact same match
  - Traditionally it is `EOF` and `EOL`

### HereStrings

- Similar version of heredocs
- Can only be passed through a single line
- The syntax differs as it uses 3 redirection symbols instead of two `cat <<< "Hello World"`

## Pipes

- Two classifications
  1. **Named** pipes
    - they are `<>`
    - like `sort < abc.txt > abc_sorted.txt`
  2. **Anonymous** Pipe
    - `|`
  - Pipes have a mechanism to ignore output produced by standar error (`stderr`)

## Pipe Fail

- `stderr` will get sent to the terminal, but `stdout` will be shown once the Pipe chain is finished
- The good practice is to stop the chain of execution as soon as it enters a `stderr`
- Can use `set -o pipefail` to return a non-zero if a command returns a non-zero status
- Can use the `|| exit 80` to exit the script if the command on it's left produces non-zero exit code


## Exit Code

## xargs

- Pipe aguments from another command to make complext automations possible
- Works like a bucket, where output from previously piped command is stored, then this can be used in conjunction with a command that actually doesn't process input, but requires a value to complete its functionality
- An example could be `cat file.txt | xargs echo` --> Here the output of the `cat file.txt` is put on the atmost right position of the `echo` command
- A very unique characteristic of `xargs` is to imaginarilly add a value to the right of a command
- Some examples of the commands which require positional arguments is `ls, rm, echo & mkdir`

## Eval

- As `eval echo "Hello!!"'`
- Equall to a process evaluating a math expression
- Can help with easier reusing and modification like

```bash
#!/bin/bash

cmd="ls -l"

eval $cmd
```

- This `eval $cmd` can be used wherever you like to
- Some security considerations with this:
  1. Code Injection
  2. Security Vulnerabilities
  3. Debugging
  4. Poor readibility

## `Printf`

- Like `echo`
- `echo` comes as a built-in command mostly, so it does not require a process ID to run, rather can run with the shell process ID itsefl
  - So `echo` is faster
- But `printf` gives more formating options
- An example: 

```bash
#!/bin/bash

course=" Advanced shell Scription course."
printf "Hello, woelcome to the %s\n" ${course}
```

- Here, the `%s` is the placeholder for the vaiable coming after it
  - The `\n` creates a new line after the text is output
- Can use `%d` for integers; `%f` --> Floating point nubmers, `%s` --> string
