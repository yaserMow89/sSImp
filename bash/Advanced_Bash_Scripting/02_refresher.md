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
