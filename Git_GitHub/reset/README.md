# [Pro Git - Reset-Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified)


## Commit Level

| command                   | HEAD | Index | Workdir | WD Safe? |
| ------------------------- | ---- | ----- | ------- | -------- |
| reset --soft [commit]     | REF  | NO    | NO      | YES      |
| reset [commit]            | REF  | YES   | NO      | YES      |
| reset --hard [commit]     | REF  | YES   | YES     | NO       |
| checkout <commit>         | HEAD | YES   | YES     | YES      |

## File Level

| command                   | HEAD | Index | Workdir | WD Safe? |
| ------------------------- | ---- | ----- | ------- | -------- |
| reset [commit] <paths>    | NO   | YES   | NO      | YES      |
| checkout [commit] <paths> | NO   | YES   | YES     | NO       |
