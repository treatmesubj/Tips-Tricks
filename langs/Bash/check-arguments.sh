# checking arguments

git diff origin/main...HEAD --name-only --relative | xargs -r printf '<%s>\n'
# <file1>
# <file2>
# <file3>

# discard stderr, but notice, there was no stdout
git diff origin/main...bogus --name-only --relative 2> /dev/null | xargs -r printf '<%s>\n'

printf '<%s>\n' find . -name based
# <find>
# <.>
# <-name>
# <based>

# shell glob
printf '<%s>\n' find . -name base*
# <find>
# <.>
# <-name>
# <basement1.txt>
# <basement2.txt>
