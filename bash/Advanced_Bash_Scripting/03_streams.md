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
