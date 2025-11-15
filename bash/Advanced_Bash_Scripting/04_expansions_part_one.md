# Expansions Part One

## Overview

- `$` is used for expansions in shell
- Special characters

## Variable expansion

- Accessing the value of a variable through the use of `$` symbol
- Variable names should have no special chars, except for `_`
- Importance of curely braces (`{}`) when doing expansion
  - Helps protecting the variables from unwanted behavior
    - Like concatinating string to the expanded value like in the example below

    ```bash
    #!/bin/bash

    height=70

    echo "Your height is $heightcm"

    echo "Your heigth is ${height}cm"

    ## Output would be:
    # Your height is
    # Your heigth is 70cm
    ```

  - Curely braces also enable us with feature that includes various operators and special characters to manipulate the variables value
    - Such as string manipulation, arithmetic operations and default values
    - In the example below, we are using the default value `Uknown` in for the variable `name`

    ```bash
    #!/usr/bin/env bash

    echo "Hello, ${name:-Uknown}"
    ```

    - String manipulation (substring variable expansion) is illustrated in the following example

    ```bash
    #!/usr/bin/env bash

    name="John Doe"

    echo "Hello, ${name:0:4}"
    ```

    - The syntax for the string manipulation is as `"${variable:start:length}"`

  - An example for substring replacement which is a type of string manipulate could be as following

  ```bash
  #!/usr/bin/env bash

  path="/home/user/file.txt"

  echo "${path/file/data}"
  ```

    - Here we have `"${variable/string_to_be_replaced/replacement_string}"`
    - In the example above the word `file` will be replaced by the word `data` in our variable

  - Can also be used to get the length of a variable as below

  ```bash

  #!/usr/bin/env bash

  name="John Doe"

  echo "${#name}"

  ```

    - Above would print the length of the variable
  - Above is called a **Length operator**

- It is good to use double quotes while expanding vars in bash
  - good for word splitting
  - Variables inside double quotes will be treated as single atomic units
    - Unless we don't want the variable to be treated as list, then we can put it inside the double quotes
    - Not putting it inside double quotes --> treated as lists
  - See example belwo to know the benifits of this

  ```bash
  #!/usr/bin/env bash

  servers="server1 server2 server3"

  for server in ${servers}; do
    echo "${server}.kodekloud.com"
  done

  ## This would print out:
  # server1.kodekloud.com
  # server2.kodekloud.com
  # server3.kodekloud.com

  # If we try the same example with double quotes
  servers="server1 server2 server3"

  for server in "${servers}"; do
    echo "${server}.kodekloud.com"
  done

  ## The output will be
  # server1 server2 server3.kodekloud.com
  ```

## Parameter - Part One

- **Patterns** are going to be discussed here
- A common patter in file systems is the use of file name extensions such as `.txt` suffix
- In shell scripting we can get an output of a vaiable other than what is assigned to it, by putting special characters inside the curely braces
- Two of these special chars are `#` and `%`
- They help remove prefix (`#`) and suffix (`%`) patterns from strings, by using the parameter expansion concept
- The `#` is used for matching prefixes and the `%` is used for matching suffixes
  - Looking at the following example you can see how `#` remove the matching prefix from the output

      ```bash
      #!/usr/bin/env bash

      greetings="Hello World"

      echo "${greetings#H}"

      ## Would print
      # ello World
      ```
    - The pattern we provide should exactly match the beginning of the string (prefix)
        - Assume we do the following

        ```bash
        #!/usr/bin/env bash

        greetings="Hello World"

        echo "${greetings#e}"

        ## Would print
        # Hello World
        ```

    - The whole pattern should match the starting script, otherwise pattern gets discarded

      ```bash
      #!/usr/bin/env bash

      greetings="Hello new World"

      echo "${greetings#Helxo}"

      ## output would be
      # Hello new World
      ```

    - It is case sensitive
  - Counter to `#` there is `%`, which removes from the end

    ```bash
    #!/usr/bin/env bash

    greetings="Hello World"

    echo "${greetings%d}"

    ## Would print
    # Hello Worl

    ## Similarly if you go like

    echo "${greetings%orld}"

    ## Would print
    # Hello W
    ```

    - The following is an example to get a list of the config files in the `/etc/` directory but without their `.conf` part
      - This might skip the files that have something after the `.conf` part

      ```bash
      #!/usr/bin/env bash

      conf_files=$(ls /etc | grep -E "*.conf")

      for file in ${conf_files}; do
       	echo "${file%.conf}"
      done
      ```

## Parameter - Part Two

- The techinque in the last part wouldn't work all the time, for example in the final example in the last part
  - we have some files in the `/etc/` directory which have the `.conf` part and have something after it also, like `.conf.d`
    - How can we get these directories also
      - It can be done using asteris `*` in combination with parameter expansion, like this:

      ```bash
      !#/usr/bin/env bash

      conf_files=$(ls /etc | grep -E "*.conf")

      for file in ${conf_files}; do
       	echo "${file%.conf*}"
      done

      ```
- We can define what is a prefix and what is a suffix in other ways also
  - Can use asterisk `*`
- Example, we can remove everything before the first space with the following:

  ```bash
  echo "${my_var#* }"
  ```

- Here we are saying remove the last word and then stop once reach a space `echo "${my_var% *}"`
- Here remove everything after letter `l` like this `echo "${my_var%l*}"`
- Now lets focus on a pitfall in linux file system
  - Take the following vars as examples

  ```bash
  my_text_file="/home/my_username/text_file.txt"
  my_python_file="/usr/bin/app.py"
  ```

  - Now having them divided like this

  | prefix                | name            | suffix        |
  |:---------------------:|:---------------:|:-------------:|
  | `/home/my_username`   |  `my_username`  | `.tx`         |
  | `/usr/bin/`           | `app`           | `.py`         |

  - To revmove the prefix from the first one for example we would do: `echo "${my_text_file#*/}"`
    - or the second one would be `echo "${my_python_file#*/}"`
  - But we won't get the desired output, in both cases only the first `/` will be **removed**
    - This happens because there is a one-to-one match between the prefix in the variable and the prefix removing pattern that we are passing in
  - In such circumstances we can use **longest prefix/suffix** remove, done by doubling the char, as in the example below
    - Instead of `echo ${my_python_file#*/}"` we can go `echo "${my_python_file##*/}"`
      - It counts everything until the last `/` as prefix
        - Anything prior to the last apperance of the `/` char would be counted as prefix
    - Mostly longest prefix removal needs a wildcard like `*` to make the removal easier - this matches zero or more chars
    - Now here to remove the suffixes for both these cases we can do `echo "${my_text_file%%.*}"` this can also be done using the shortest suffix removal method
