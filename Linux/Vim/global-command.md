```
:h :g | only
```

# delete regex match lines
```
:g/word/d
```
## delete non-regex match lines
```
:g!/word/d
```

# within regex match lines, find-replace regex
```
# replace first in each line
:g/stacktrace/s/error/errorMessage
# replace all in each line
:g/stacktrace/s/error/errorMessage/g
```

# within regex match lines, run a normal command
```
:g/TODO/normal A  # please do this
```
