# `sed`

## Introduction

- used string occurences to work with the data, instead of columns * rows which was the case in `awk`
- like this command `sed 's/sample/are/g' poem.txt`
  - Will replace every `sample` with `are` in the file `poem.txt`
  - `s` --> sustitute
  - `g` --> global

## `sed` - print

- Different methods to pass input to a command in bash
- `sed` can be used to print data to the terminal
- `sed 'p'` would wait for input
  - Writing anything would appear two times
    - It is cause it prints the unprocessed and proccessed output both
      - And if the data is not modified, it is regenerated
  - `'p'` corresponds to the `{script-only-if-no-other-script}` in the `sed` command explanation
    - Meaning the char `'p'` is actually a script, or a command given to `sed`
  - We can pipe input to this as `echo "hi" | sed 'p'`
  - We can redirect from a file like `sed 'p' file_name`
  - It is within the `''` to make sure it is interpreted as a literal by the shell
  - Line number can also be defined with it `sed '2p' input_file`
  - We can use `-n` to supress the automatic printing of input lines; take the following example
  
  ```bash
  # lines.txt
  # first line
  # second line
  # third line
  # 
  # If you do
  sed '2p' lines.txt
  ## Output would be
  # first line
  # second line
  # second line
  # third line
  # 
  # But if we do
  sed -n '2p' lines.txt
  ## Output would be
  # second line
  ```

## Delete

- Deleting data from a source
- Using it simply as `sed 'd' file_name` would remove everything in the file
  - `'d'` deletes data from an input data
- `sed` operates in a non-destructive manner by default
  - To avoid this we can use the `-i` flag which stands for `in place`
    - Modfies the source file directly
- We can seperate by comma as in `sed '3,5d' file_name`
  - This will be a *range* of lines

## Find

- Can be done in conjuction with other operations in `sed`
- Searching text in `sed` works similarly to `grep`
- Script for searching text in `sed` can be defined with this syntax `'/word-to-search/'`
- Seach requires an additional command to perform an action with the search result -- Look at the example below

```bash
# employees.txt
# 1|Kriti|Shreshtha|Finance|Financial Analyst|kriti.shreshtha@company.com|60000
# 2|Rajasekar|Vasudevan|Finance|Senior Accountant|rajasekar.vasudevan@company.com|75000
# 3|Debbie|Miller|IT|Software Developer|debbie.miller@company.com|80000
# 4|Enrique|Rivera|Marketing|Marketing Specialist|enrique.rivera@company.com|65000
# 5|Feng|Lin|Sales|Sales Manager|feng.lin@company.com|90000
# 6|Andy|Luscomb|IT|IT Manager|andy.luscomb@company.com|95000
# 7|Mark|Crocker|HR|HR Manager|mark.crocker@company.com|85000
# 8|Jing|Ma|Engineering|Engineering Manager|jing.ma@company.com|100000
# 
# We can search like this
sed -n '/Manager/p' employees.txt

## Output would be
# Only prints the lines with Manager keyword from the file
```

- **Regular Expressions** also can be used
  - Like here we would only get lines with Ma as a word `sed -n '/\bMa\b/p' employees.txt`
    - `\b\b` makes sure there is a word boundary
- We can pass multiple string patters also
- `-e` flag makes sure the single quoted portion is explicitly sent as a script block
- `-e` can be used to pass multiple string samples as in this one: `sed -n -e '/\bManager\b/p' -e '/\bIT\b/p' employees.txt`
  - Here it will search for line with either `Manager` or `IT` as words
  - `-e` is optional when ther is only one script passed to the command

## Substitute

- uses `s` command inside the script
- Requires two parameters separated by `/`
  - `sed 's/original/replace/' file_name.txt`
- We can make global changes with the `g` modifier
- We can also pass a modifier to specify on which original element it should operate like `sed 's/\bIT\b/Information Technology/2' employees.txt`
  - This will only substitue in the second instance of `IT` in each line
- We can also replace a specific occurence in a specific line as here `sed -e '7 s/\bHR\b/Human Resources/1' employees.txt`
  - This will only replce the first occurance in the **7th** line
  - Lines can be also mentioned in ranges, using `,`
- Another command is `'i'` which is used for inserting text into the data
- For example the following example inserts a header at position 1 in the file
  - `sed '1iID|Name|FirstName|LastName|Job|Department|Email|Salar' employee.txt`























-
