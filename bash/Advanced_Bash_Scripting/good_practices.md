# Good practices

## Strict mode

- Bash is not robust
- Change the default behavior of bash using some flags
- `set -e`
  - Ending script upon facing error
- `set -u`
  - In bash attempting to expand a non-existing var in bash will result in an empty string
  - `set -u` can help preventing this behavior
    - If an empty var is being expanded script will exit
- `set -o pipefail`
  - In pipes a standard error goes directly to the terminal
    - Skipping other commands in the pipe
  - To mitigate the issue of pipes being masked in the script this flag can be used
  - However proper error handling in bash would require more than this for pipes
    - Individual error handling needs to be done on each line

## no-op Command

- It is **Dry-run**
- `:` is the way to do it, like in the following

```bash
#!/usr/bin/env bash

if [[ "$1" = "start" ]]; then
  :
else
  echo "Something else"
fi
```

## Comments

- Documentation
- Better to have

```bash
#!/usr/bin/env bash
#
# Script usage
# Exit codes
# Author
```

## Logging

- With **timestamps** and **functions**
- For efficient logging with date, we can have a log function

```bash
#!/usr/bin/env bash

log() {
  echo $(date -u +"%Y-%m-%dT%H:%M:%SZ") "${@}"
}
```


-
