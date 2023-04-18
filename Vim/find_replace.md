# Basic
- `:s/foo/bar/g`: in line, replace foo w/ bar
- `:%s/foo/bar/g`: in file, replace foo w/ bar
- `:%s/foo/bar/gc`: in file, interactively, replace foo w/ bar
- `:20,40s/foo/bar/g`: from lines 20-40, replace foo w/ bar

# Newlines
- `:s/foo/\rfoo/g`: in line, replace foo w/ newline-foo

# Weird Text
- `:%s/[^\x00-\x7F]/g`: in file, replace non-ascii with space
