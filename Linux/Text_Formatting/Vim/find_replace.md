**NOTE**\
in `visual-line` mode, you can substitute in selected lines with `:<,>s/foo/bar/g`

# Basic
- `:s/foo/bar/g`: in line, replace foo w/ bar
- `:%s/foo/bar/g`: in file, replace foo w/ bar
- `:%s/foo/bar/gc`: in file, interactively, replace foo w/ bar
- `:20,40s/foo/bar/g`: from lines 20-40, replace foo w/ bar

# Newlines, line-ends
- `:s/foo/\rfoo/g`: in line, replace foo w/ newline-foo
- `:s/$/\\/g`: in line, add `\` to line-end

# Weird Text
- `:%s/[^\x00-\x7F]/g`: in file, replace non-ascii with space
