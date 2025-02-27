# Conventions

## Overview

## Variables

- Lower case
- Snake case, so *user address* would be `user_address`
- Descriptive
- Sinlge letter is ok
- Constants
  - readonly modifier
  ```bash
  readonly FILE="file.txt"
  ```
- Variables to be used outside of their script, you should `export` them
```bash
export my_var='123'
```

## Functions

- Always lower cases
- Snake cases
- () at the end of the name
- {} on the same line and
- Alwasy a space between paranthesis and curly braces

## Expanding

- $ shows that following character or characters hold a value that can be  accessed or utilized
```bash
#!/bin/bash
var="Value of var"
echo ${var}
```

- Comparing it to

```bash
#!/bin/bash
var="Value of var"
echo $var
```

- Both of the above will have the same output if we run them
- So what is the difference
- If you look at the following example it would be much clear

```bash
#!/bin/bash
height=170
echo "Your height is $heightcm"     # This will provide an error, since heightcm is not expandable and can not be accessed

echo "Your height is ${height}cm"   # This won't provide an error, since the height is accessible'
```
- Without the curly braces there is not delimiter as to where the name of the variable beggins and ends
- So usualy we expand the variables using curly braces
- Use double quotes `""` to expand variables, in order to prevent variable splitting
  - So it is about **IFS** special character. It defaults to *tab*, *space* or *line breaks*
  - Any var or element containing one of the above, will be considered a different element
  - It depends on you, whether you like these characters to be considered or ignored

```bash
#!/bin/bash

var="one two three"

for element in ${var}; do
  echo ${var}
done

# The above would print:
# one
# two
# three

# If we want to avoid splitting them and have them as a single element
for element in "${var}"; do
  echo ${var}
done
# This will print them as one element,
# one two three
```

- So if you would like treat a variable as a list then you should avoid using the quotes

```bash
#!/bin/bash
readonly SERVERS="server1 server2 server3"

for server in ${SERVERS}; do
  echo "${server}.myservers.com"
done

# But if we do the same loop with double quotes it would ignore the special characters IFS, as below

for server in "${SERVERS}"; do
  echo "${server}.myservers.com"
done
# This will print out server1 server2 server3.myservers.com
```
