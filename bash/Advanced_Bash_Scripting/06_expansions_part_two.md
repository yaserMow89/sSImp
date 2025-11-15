# Expansions Part Two

## Brace expansion

- String substitution expansion `"${variable/pattern/replacement}"` or `"${variable:start:end}"`
- Then we went to Globs `*,?` and `\`
- Brace expansion (`[]`) generate lists from a specific pattern as `file[ab]`

### Brace expansion (`{}`) VS square bracket globs (`[]`)

- Using brace expansion to produce `samplea, sampleb, samplec` would be like `sample{a..c}` can be used by command like `touch sample{a..c}`
  - The double dot notation `..` in the above brace expansion is used to specify the range of the sequence
    - Chars within the curely braces can be alphabetically ascending/descending or numericals
      - This is key difference in flexibility between brace expansion and square brackets, where only ascending order is possible
  - You can do multiple of them like `{MKT,DEV}{001..004}`
    - This would result in `MKT001, MKT002, MKT003, MKT004, DEV001, DEV002, DEV003, DEV004}`
- **Types and applications**
  - Seperating elements
    - like `echo file{1,2,3}.txt`
      - Generates a distinct string for each element specified
  - Range based expansions
    - To generate a range of values, by specifying a start and an end value; separated by two dots
    - like `echo file{1..3}.txt`
  - Nested brace epxansions
    - like `echo {1..3}{a..c}` or `echo {1,2}{a,d,z,x,y}` would result in `1a 1d 1z 1x 1y 2a 2d 2z 2x 2y`
  - Step-based brace expansion
    - Like `echo file{1..10..2}.txt` will result in `file1.txt file3.txt file5.txt file7.txt file9.txt`
    - Step can be defined in a range based brace expansion
  - Pre- and postfix with brace expansion
    - Brace expansion is combined with pre and post fix elements
    - Like `echo pre-{A..C}-post`
  - Brace expansion with commands
    - Like `for i in {1..3}; do touch "file${i}"; done`

## Command substitution

- Command substitution expansion
- We learnt about variable expansion
  - `{}` protects the boundaries of the variable
  - `""` Expand the vaule as an atomic token
- Capturing a command's output by using a specia syntax is called command substitution expansion
  - Includes the output of a command directly into a script
  - Like in following script

  ```bash
  #!/usr/bin/env bash

  file_count=$(find . -type f | wc -l)

  echo "${file_count}"
  ```

  - There is also another way for command substitution expansion, by using backticks instead of the dollar symbol and paranthesis
    - This is a ***deprecated*** method and should be avoided

  ```bash
  #!/usr/bin/env bash

  file_count=`find . -type f | wc -l)`

  echo "#{file_count}"
  ```

- The following example

```bash
#!/usr/bin/env bash

if [[ -z "${1}" ]]; then
  echo "Please specify a directory"
  exit 1
fi

file_count=$(find ${1} -type f | wc -l)

echo "${file_count}"
```

- Command substitution expansion only stores `stdout`
- A new process is spawn upon a command substitution expansion

## Subshells

- Command substitution expansion runs inside a subshell
  - A separate instance of a shell that runs within the main shell
  - Allowing for execution of commands in an isolated env
  - Inherits the vars from the parent shell
- **Subshells** may be used or invoked in many different context
  - Command substitution expansion is one of the common places we can see this
- How to open a subshell?
  - Using `()`
- Subshells can run accross multiple lines, separated by semicolons or pipes depending on the usecase
  - Double and (`&&`) can be used as an and operator too, also double vertical bar (`||`)
- To see how they are using different process IDs you can run the following script

```bash
#!/usr/bin/env bash

parent_shell=$$

(
  echo "Subshell's id: $BASHPID")

echo "${parent_shell}"
```

  - In the above script
    - `$$` is a special shell variable --> Parent shell id
    - `$BASHPID` is an env variable --> Current shell id
  - Special shell variables don't get expanded with curly braces

### How to propagat values back to the main shell

- We can use tmp files for this

```bash
#!/usr/bin/env bash

tmpfile="/tmp/$$.tmp"

counter=1

echo "${counter}" > ${tmpfile}

(
  counter="$(( $(cat ${tmpfile}) +1))"
  echo "${counter}" > ${tmpfile}
)

counter=$(cat ${tmpfile})

echo "${counter}"

unlink "${tmpfile}" ## --> Removes a single file
```
