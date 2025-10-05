# Refresher

## Overview

## Scriptflow

- Control structures could be utilized to change the order of execution
  - Loops, conditional statements and functions
- Factory analogy
- 4 main programing constructs that can alter imperative programing flow in shell scripting
  1. Conditional Statements
    - Double square brackets (`[[]]`) are used in this course over single square brackets, as they allow a wider range of condition evaluation
  2. Loops
    - `do` keyword and `done` keyword
  3. Source Code

  4. Functions

## Functions

- Two ways to declare a function

```bash
function func_name {
  ...
}

# Or

func_name() {
  ...
}
```

- They can also be one-lined

```bash
my_function () { echo "Hello I'm a function"; echo "Bye function"; }
```

- Declaring local vars inside the function
  - Using `local` keyword with a var, prevents it from being accessed outside the function

  ```bash
  my_fun() {
    local name="Bob"

    echo "${name}"
  }
  ```

  - Trying to echo `name` var outside the above function would return empty

## Command Line Arguments

- `shift` Moves the arguments down on one position
- Runngin the script below with the `./simple.sh arg1 arg2 arg3` would result in output `arg1 arg2 arg3`

```bash
#!/bin/bash
echo "${1}"
shift
echo "${1}"
shift
echo "${1}"
```

## PID

- TTY is an intermediate between a shell process and a terminal
- `tty` shows the current tty for your shell
- All the process run by a shell are child processes of it; this can be seen observing the a process run by a shell from another shell
  - Similarly processes started by a script are children of the script itself
- Difference between `&` and `nohup`
  - With the `&` the process goes to the background, but it is associated with that **tty**
  - With the `nohup` and `&` the process is disassociated from the **tty** and even if we terminat that terminal for that process, it will still keep running
- Builtin commands does not generate process id in the shell
- The default beahvior of `kill` command is `SIGTERM` which terminates the process gracefully
  - `-15` is also the same thing
  - `-KILL`, `-9` or `-SIGKILL` are the same thing
- `strace` used in Linux to debug and trace system calls made by a running process
  - common options `-T` --> Timing information; `-f` --> Trace child processes; `-p` --> Parent's shell PID


## Built-in Commands

- Prepackaged programs that are part of the shell and don't generate additional process IDs to run
- Faster than programs we execute through binaries
- Basically the commands in shell are divided into two parts
  1. Programs with Binaries --> Run through a binary that can be found somewhere in our files system
  2. Built-in commands --> Commands that come pre-packed in shell and don't generate additional shell processes when executed
- `type` command can be used to identify
- If we want to see the difference in time we can run the `time true` and see how much does it take to run the `true` built-in command and then compare it to calling the `true` command from the binary
- You can see in the below output the timing differences

```bash
cloud_user@b5f70ee6f11c:~$ time true

real	0m0.000s
user	0m0.000s
sys	0m0.000s
cloud_user@b5f70ee6f11c:~$ time /usr/bin/true

real	0m0.002s
user	0m0.000s
sys	0m0.002s
```

  - `true` command is both a built-in and also a binary on the system
- Also you can trace the PIDs of the processes to observe the beahvior in terms of generating new PIDs among built-in and binary commands
- `man builtin` or `man bash` will give you a list of available built-in commands
- `compgen -b` will also show you list of built-in commands on your shell; `compgen -k` will give you list of keywords in your shell
  - The command `time` used earlier is a keyword
  - Keywords also don't generate a separate process id

## Keywords Vs Built-ins

- **Built-ins** are prorgrams while **Keywords** are special words
- Keywords are special words to control execution structure
- `[]` is **built-in** while `[[]]` is **keyword**
  - `[]` is the same thing as `test` command, you can verify this by looking at their man pages `man test` and `man [`
- The difference is in the ranges of conditional expression which each is able to evaluate
- For example `[1 < 2 ] && echo "1 is smaller than 2"`, the `<` symbol would act as a redirection symbol; taking the input from `2` and putting it inside `1`

```bash
cloud_user@b5f70ee6f11c:~$ [ 1 < 2 ] && echo "1 is smaller than 2"
-bash: 2: No such file or directory
```

- But running the same with double square brackets would execute the `<` as a conditional structure

```bash
cloud_user@b5f70ee6f11c:~$ [[ 1 < 2 ]] && echo "1 is smaller than 2"
1 is smaller than 2
```

- Double square bracket `[[]]` support:
  - **Grouping expressions**

```bash
[[ 3 -eq 3 && ( 2 -eq 2 && 1 -eq 1 )]] && echo "3 is equal to 3"
```

  - **Pattern Matching**

  ```bash
  name=$"Bob Doe"
  [[ $name = *o* ]] && echo "Patters can be used"

  ```

  ## Guard Clause

- Nesting *if-else* statements is generally bad practice
- Guard Clause is a technique, and makes sure if the pre-conditions are not met, the script would exit
- Look at the following script
- Imporves code readability
- Reduces nesting depth for conditional clauses

```bash
#!/bin/bash
readonly FILE_PATH="/home/ym23meq/myFile"
readonly USER_NAME="ym23meq"

run_process () {
  echo "Running process"
}
if [[ "${USER_NAME" == "admin" ]]; then
  if [[ -e "${FILE_PATH}" ]]; then
    if [[ -s "${FILE_PATH}" ]]; then
      run_process
    else
      echo "File exists but empty"
    fi
  else
    echo "File does not exist"
  fi
else
  echo "User is not admin"
fi

exit 0
```

- Now the above script can be done using guard clause technique and with less complexity

```bash
#!/bin/bash
readonly FILE_PATH="/home/ym23meq/myFile"
readonly USER_NAME="ym23meq"

if [[ "${USER_NAME}" != "admin" ]]; then
  echo "User is not admin"
  exit 1                    ####################### Here if this condition is not met we know the flow will move further and it should stop here with the exit code 1
fi

if [[ ! -e "${FILE_PATH}" ]]; then
  echo "The file does not exist"
  exit 1                    ####################### Here if this condition is not met we know the flow will move further and it should stop here with the exit code 1
fi
fi

if [[ ! -s "${FILE_PATH}" ]]; then
  echo "The file is not empty"
  exit 1                    ####################### Here if this condition is not met we know the flow will move further and it should stop here with the exit code 1
fi
fi

run_process ### Here we run the function, this would only run if all the above conditions are met, if one fails then the script would fail
exit 0
```

- We can also use a one liner snippet for doing guard clauses

```bash
if [[ -z "${1}" ]] || { echo "Command line argument is not empty"; exit 1; }
```

## Shebang

- Which scripting language the shell should use to interpret the script with
- `execve`
- A better approach to declare **shebang** is using `#!/usr/bin/env bash`
  - Uses the version of bash available by default in the system
  - **Great** practice
