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
-
