# Vim Macro
## Create Macro
1. `qa` to start recording macro
    - strike-through a single line: `SHIFT+_`, `f `, `a`, `~~`, `ESC`, then, `SHIFT+A`, `~~`, `ESC`
2. `q` to stop recording macro
## Use Macro
1. select some lines in visual mode
2. use macro on each line: `:'<,'>normal @a`

