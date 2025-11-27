# Introduction to awk

- Easily can parse structured data in a tabular format
- Column based syntax with numbers
- Since it is a programming language by it's own, it does not follow Bash's conventions like other command line tools
  - Domain specific language
- Uses spaces as the default separator
- Can also be used in a script format by using a shebang declaration

```bash
#!/usr/bin/awk -f

BEGIN {
  print "Hello, Worold!"
}
```

## awk-print

- Expects input in one of the following forms
  - File
  - Pipe
  - Keyboard
- The single quotes aren't part of awk command
  - Used by shell to prevent variable expansion
  - Can use double quotes
- The `{}` are called action block
  - By closing the action block in `''` we tell shell to treat the entire block as a single passage
- for passing a file it should go all the way to the right of the command, can also be seen on it's description

```bash
╰─ awk                                                                                                                     ─╯
usage: awk [-F fs] [-v var=value] [-f progfile | 'prog'] [file ...]
```

- What is next to the print statement inside the action block is called an *Expression*
- String literal can also be used as an expression
  - Prints the expression the same number of times, as number of lines contained in the input file
- Can also pass multiple expression separated by comma
- Curely braces are called action block
- something like `$1` is a positional value

## Built-in variables

- We have action block and expressions inside it, the expression can have positional values in turn like `$1`
  - Positional values refer to specific values related to the input data
- Space is awks default field separator
- Three more varialbes
  1. `NR` Number of records in a file
  2. `NF` Number of fields
  3. `FILENAME`
- **NR**
  - Generates a count number for the output -- Goes per line retunred
  - Like doing the following

  ```bash
  df -h | awk '{ print NR, $1, $4 }'
  ## output
  # 1 Filesystem Avail
  # 2 overlay 92G
  # 3 tmpfs 64M
  # 4 shm 64M
  # 5 /dev/disk/by-label/data-volume 92G
  # 6 tmpfs 2.9G
  # 7 tmpfs 2.9G
  # 8 tmpfs 2.9G
  ```

  - You can see the **Number of records at the left side of the report
    - The location for this can be controlled simply with the location of positional value
  - We can filter a specific line also with the help of this variable
    - Like getting line number 7 from the above example would be like

    ```bash
    df -h | awk ' NR == 7 { print NR, $1, $4 }'

    ## output
    # 7 tmpfs 2.9G
    ```
- **NF** --> Number of fields
  - Columns are assigned to this variable

  ```bash
  df -h | awk '{ print NF }'

  ## output
  # 7
  # 6
  # 6
  # 6
  # 6
  # 6
  # 6
  # 6
  ```

    - Interstingly the first line generates 7 columns, one more compared to other rows
      - Because it is actually 7 columns
- Both of the above vars can be concatenated with other tools in awk,

```bash
df -h | awk '{ print "Number of columns in line: " NR " is: " NF }'

## output
# Number of columns in line: 1 is: 7
# Number of columns in line: 2 is: 6
# Number of columns in line: 3 is: 6
# Number of columns in line: 4 is: 6
# Number of columns in line: 5 is: 6
# Number of columns in line: 6 is: 6
# Number of columns in line: 7 is: 6
# Number of columns in line: 8 is: 6
```

- **FILENAME** --> Holds the name of the file being processed
  - Processing text passed by pipes, this would be printed as empty

## Option -F

- Used to specify field separator
- Goes as this `awk -F "fs" '<ACTION BLOCK>`
- Field separator should be enclosed by quotes (preferrebly double)

## Option -v

- Declare a variable before executing the action block or program; allowing the variable to be reused
- This provides the *utility* and *flexibility* that vars provide in any other programming language
- A simple example would be `awk -v var="Hello World!" ' BEGIN { print var }'`
  - First declared and then used
- `-v` flag comes right after `awk` command and `-F` flag
- `BEGIN` is also used here
  - This means a block of code should be executed before starting to process any inputs
  - Have we not put it there, it would be waiting for the input
    - Shall you type anything here, the actual value of the is printed out
- A good example would be like the following:

```bash
awk -F "|" -v var="Employee name is: " '{ print var, $2 }' employees.txt

## The output would be:
# Employee name is:  Kriti
# Employee name is:  Rajasekar
# Employee name is:  Debbie
# Employee name is:  Enrique
# Employee name is:  Feng
# Employee name is:  Andy
# Employee name is:  Mark
# Employee name is:  Jing

## Assuming your employees.txt file is:
# 1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
# 2|Rajasekar|Vasudevan|Finance|Senior Accountant|rajasekar.vasudevan@company.com|75000
# 3|Debbie|Miller|IT|Software Developer|debbie.miller@company.com|80000
# 4|Enrique|Rivera|Marketing|Marketing Specialist|enrique.rivera@company.com|65000
# 5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
# 6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
# 7|Mark|Crocker|HR|HR Manager|mark.crocker@company.com|85000
# 8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
```

- Take the following example which would get the list of users earning more than 90000

```bash
## employees.txt is:
# 1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
# 2|Rajasekar|Vasudevan|Finance|Senior Accountant|rajasekar.vasudevan@company.com|75000
# 3|Debbie|Miller|IT|Software Developer|debbie.miller@company.com|80000
# 4|Enrique|Rivera|Marketing|Marketing Specialist|enrique.rivera@company.com|65000
# 5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
# 6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
# 7|Mark|Crocker|HR|HR Manager|mark.crocker@company.com|85000
# 8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000

awk -F "|" -v high_salary="90000" -v text="employee earning more than 9000 is:" -v text_two=" And they are earning: " '$7 >= high_salary { print text $2 text_two $7 }' employees.txt

## Output would be
# employee earning more than 9000 is:Feng And they are earning: 90000
# employee earning more than 9000 is:Andy And they are earning: 95000
# employee earning more than 9000 is:Jing And they are earning: 100000
```

## Option Files

- `awk` commands can be saved to a file and run from it, like other bash scripts
- Writing awk programs in the terminal can quickly become hard to work with
- The command `awk 'BEGIN { print "Hello, World!" }'` can be written into a file like this

```bash
# name would be like hello.awk
#!/usr/bin/env awk -f       # For good practice

BEGIN {
  print "Hello, World!"
}
```

  - Program block is no longer closed in single quotes
  - For good practice we have also used a **shebang**
    - `-f` is needed for running awk from a file
- Bash constructs like globbing, command substitution expansions, and command line utilities are **not** available here
- We can combine awk programs into bash scripts (*hybrid*)
  - A couple of things should be done:
    - **Shebang** should be bash
    - `awk` declaration should be placed
    - Single quotes will be there
      - To turn awk program block into a literal string

    ```bash
    #!/usr/bin/env bash

    awk ' BEGIN {
      print "Hello, World!"
    }'
    ```

      - And this can be run like a normal bash script
- The script can be run using `awk -f` or like bash --> make them executable and then run them
- Another difference would be that you won't use `-v` for declaring a variable in an `awk` script, but not in hybrid model
- Can have multiple block with curly braces in an awk script
  - Normally `BEGIN` block is good for initializations
  - Action block for execution

## Bash-Hybrid

- Take the following command which would return employees with highest and lowest salaries

```bash
## employees.txt is:
# 1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
# 2|Rajasekar|Vasudevan|Finance|Senior Accountant|rajasekar.vasudevan@company.com|75000
# 3|Debbie|Miller|IT|Software Developer|debbie.miller@company.com|80000
# 4|Enrique|Rivera|Marketing|Marketing Specialist|enrique.rivera@company.com|65000
# 5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
# 6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
# 7|Mark|Crocker|HR|HR Manager|mark.crocker@company.com|85000
# 8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
#
## The command is
awk -F "|" -v high_salary=90000 -v low_salary=65000 ' $7 >= high_salary || $7 <= low_salary {print $2, $3, $7 }' employees.txt

## Output would be
# Kriti Shreshtha 60000
# Enrique Rivera 65000
# Feng Lin 90000
# Andy Luscomb 95000
# Jing Ma 100000
```

  - Now we are going to convert this into a hybrid bash script

```bash
#!/usr/bin/env bash


awk -F "|" -v high_salary=90000 -v low_salary=65000 -v up_header="=====Needs to be adjusted down=====" -v down_header="=====Needs to be adjusted up=====" '
$7 >= high_salary {
	if (!printed_up_header){

		print up_header
		printed_up_header = 1
	}
	print $2, $3, $7
}
$7 <= low_salary {
	if (!printed_down_header) {

		print down_header
		printed_down_header = 1
	}
	print $2, $3, $7
}' employees.txt

## Output would be
# =====Needs to be adjusted up=====
# Kriti Shreshtha 60000
# Enrique Rivera 65000
# =====Needs to be adjusted down=====
# Feng Lin 90000
# Andy Luscomb 95000
# Jing Ma 100000
```
















-
