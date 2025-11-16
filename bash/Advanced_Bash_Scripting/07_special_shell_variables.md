# Special Shell Variables

## Overview

- Special tools at your disposal


## Special Shell - Question Mark (`?`)

- Exit code
  - 1 --> General error
  - 2 --> Misuse of shell built-ins
  - 126 --> Cannot execute
  - 127 --> command not found
  - 130 --> Terminated by Ctrl+C
- Only stores for the last command

- An issue is redirecting the output of the script to dev null and then having `exit 0` at the end of it
  - With this return code for the script would be zero while there has been an error in the script

  ```bash
  #!/usr/bin/env bash

  name="John"

  ehco "${name}"

  exit 0
  ```

  - Running the above script with the ` 2&1>/dev/null` would have an exit code of 0, though there is an error (typo) in it
  - A script should be stopped if a condition is not met (guard clausing)
    - The script should be aborted if something does not go as planned
- `set -e` is going to stop the script if any commands return non-zero exit status code
- Generic terminate function
  - Terminates function and selects appropriate exit status


## Hashtag

- `$#` number of arguments passed to a script or function
- Can be used for either
  - Checking the number of args
  - Or performing an action based on that number

```bash
#!/usr/bin/env bash

echo "$#"

## Output would be 0
## Since no args are passed to the script
## But if we pass an arg it will return 1
```

- A usecase example could be that we need a min number of args for our script
  - A gaurd clause can be used to make sure this happens

## IFS

- IFS --> Internal Field separator
- Env Variable
- ***Special shell vars*** Vs ***Env Vars***
  - The values of special shell vars are dynamic and they change along with our usage of shell and the command line
    - They are generally used to store information that can be used to customize the behavior of the shell or scripts
  - Env Vars are more static in nature, primary used to access global configuration settings
- Elements in shell are seperated by space, tab, or line breaks
- There are certain special chars in shell that represent space
- However if we receive an input separated with colon, we would need to change the default seperator (IFS) to turn into
- Lets look at the example below

```bash
#!/usr/bin/env bash

elements="element1:element2:element3"

for i in ${elements}; do
  echo "${i}"
done

## The output would be
# element1:element2:element3
```

- To fix this we can re-assign the value of IFS inside our script

```bash
#!/usr/bin/env bash

IFS=":" # Here we are reassigning the value for IFS
elements="element1:element2:element3"

for i in ${elements}; do
  echo "${i}"
done

## This time the output would be
# element1
# element2
# element3
```

- IFS only works on expanded vars, not on hard coded vars and values that don't go through the expansion process
- We can use `set -- ${var}` to separate the values of a var into args
  - As in they are different elements of a list of vars
  - This works only if the seperator of those elements is in the IFS env var
- How to **restore `IFS`** to ***default***?
  - The simplest way would be to `IFS=$' \t\n`
- What happens if `IFS` is assigned to empty string or null value?
  - No field or word splitting will be performed

## Args

- Command line args were accessed using their numeric reference so far
- What if there is a more convnient process?
- `$@` and `$*` are going to help us with this
  - They group all the args together
- Differences?

```bash
#!/usr/bin/env bash

echo "The number of args passed: $#"
echo "All args: $@"

for arg in "$@"; do
  echo "Arg: ${arg}"
done

## Running it will get us this:
# ./first.sh arg1 arg2 arg3
# The number of args passed: 3
# All args: arg1 arg2 arg3
# Arg: arg1
# Arg: arg2
# Arg: arg3
```

  - With each arg in `$@` the loop performs an iteration

- On the contrary with `$*` the loop would only repeat once

```bash
#!/usr/bin/env bash

echo "The number of args passed: $#"
echo "All args: $*"

for arg in "$*"; do
  echo "Ar: ${arg}"
done

## The output for this will be
# ./second.sh first second third
# The number of args passed: 3
# All args: first second third
# Ar: first second third
```

- So `$@` keeps them iteratable, yet grouped
  - You are interacting with args as individual items
- While `$*` keeps them like a sigle entity that can't be iterated, and can't be accessed by its individual values
  - The args are treated as one entity

## pid

- `$$` and `$!` store info about the processes executed by the scripts or commands
  - Info on process IDs or commands initiated by us
  - Only for command line initiated tasks
- Starting a terminal will associate a tty to it
- Any command has a life cycle
- `$!`
  - Keeps track of the last process ID in the background
- `$$`
  - info about the current shell's process id
  - For a subshell it only returns the value of the parent shell

## Zero (`$0`)

- Two use cases
  1. Get the name of the script being executed
  2. Get the absolute path of a directory where a script is being executed
- Stores the name of the script with it's path, whether it is absolute or relative
- Usefull for usage messages within the scripts
  - The following script would be a good example

  ```bash
  #!/usr/bin/env bash
  set -e

  readonly INVALID_CL_ARG_NUM="155"

  terminate() {
      local -r msg="${1}"
      local -r code="${2:-150}"
      echo "${msg}" >&2
      exit "${code}"
  }

  usage() {

  cat <<USAGE
  Usage: special-shell.sh [arg]
     This script reads the contents from a file using a filereader binary
     Arguments:
         filename: An existing non-empty file

  USAGE
  }

  if [[ $# -ne 1 || ! -s "${1}" ]]; then
      usage
      terminate "Pass a single command line argument as a file that exists and is non-empty" "${INVALID_CL_ARG_NUM}"
  fi

  /usr/local/bin/filereader "${1}"

  exit 0
  ```

## Underscore

- Special Shell variable
- Perform an operation on the last argument
- Like in the below example

```bash
ls test

cp $_ /tmp
```

  - Here the the `test` file is in the `$_` variable and we have copied it into the `/tmp`
- This only stores the **last** argument of a command
  - In case no arguments, it will be empty

## Dash

- Reflection of the options or flags of the current shell
  - Can tweak the behavior of the shell
- Might be different from system to system
- Some of these configs are:
  - `h` --> Remember the location of commands
  - `B` --> Perform brace expansion
  - `e` --> Exit immediately if a command exits with a non-zero status code; This is actually the `set -e` flag on the scripts
  - `H` --> Enable history situation
  - `i` --> Interactive shell
  - `m` --> Job control is enabled
  - `u` --> Treat unset vars as error when performing parameter expansion
