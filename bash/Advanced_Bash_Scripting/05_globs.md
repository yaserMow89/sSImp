# Globs

## Overview

- Global variable or global patterns
- Short hand pattern
  - Can't be developed into a complex pattern like a regular expression can
  - What is **Shorthand**?
    - Method of writing rappidly by substituting characters, abbreviations or symbols for letters
  - Can match occurences of strings and values in various scenarios
- An eye for identifying patterns in strings


## Globs - Question Mark

- Question Mark symobl (`?`) for pattern matching
- Wildcard to match any single char in a string
- When using the `?` glob in isolation, the matching strings need to have the same length
- Looking at the following files we can get all the ones ending with `ail` by replacing it with `?`
  - `ail rail hail tail mail 4ail Document.doc bar sail foo foobar`
    - would be `ls ?ail`; gives us `4ail  fail  hail  mail  rail  sail  tail`

## Globs - Star

- Matches any string of zero or more characters

## Globs - Escape

- `\` is used as escape char in many languages
- If you try to create a file with the name `?ail` it won't be created, cause of the `?`
  - It has a special meaning in the shell context
- can be resovled by using the escape char (`\`), and the question mark is treated as a normal character
- If you have a dir and a file has name like `?ail` and then you have files like `ail rail hail tail mail 4ail Document.doc bar sail foo foobar` also in the dir
  - How can you list the `?ail` file?
    - You should escape the `?` at the beginning of the name and treat it literally
      - `ls \?ail` would do that
  - Of course you can also use `ls "?ail"` to treat the name literally
    - Wrapping the strings in **double quotes** also treats them literally

## Globs -Mixed

- Only examples and nothing to be added here

## Globs - Square Brackets (`[]`)

- Assume you have `FileA FileB FileC FileD FileE FileF` and you only want the first three, how can you get this?
- Squre bracket chars creates a Glob that matches any single char within the square bracket
- Also allow range of values to match (called **Creating Character Class**)
  - You can do `File[A-C]` for a range
- Negated **Character Class** can also be created
  - Let's say that you only want to match `FileA FileB FileC FileD FileE FileF` the `FileE FileF`
    - Of course Ranged Character Class can be used, but we can do it using antoher method also
    - Another method is to use **carrot** char and negate `ls File[^A-D]`
      - Exclamation (`!`) can also be used instead of `^` to create **Negated Character Class**
  - To get specific files we can list them all within the square brackets, like `ls File[ADE]` will give `FileA FileD FileE`
- Squre brackets are **Case Sensitive** but we can make a combination of Upper and Lower cases also
  - Like `File[aA-eE]` will get both lower and upper case
    - It should in ascending order - meaning lowercase should come prior to uppercase
- Number can also be used
  - Like `File[1-3]`
- Can also be used multiple times to match single positional chars in a given string
  - Like `File[A-D][1-4]`
    - Here the alphabet is matched and also the number
- Why we can use Globs for a command like `ls`, but not for a command like `touch`
  - Globs are for **Pattern Matching**, using Globs is meant to return a match
