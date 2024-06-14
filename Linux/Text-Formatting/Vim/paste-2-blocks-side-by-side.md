# paste 2 blocks side-by-side
1. Select the left block like so: `_ <S-v> 10j`
    a. then, `:right`
2. Select the right block like so: `_ <C-v> $ 10j y`
3. Go to left block, first line, last char (`gg $`)
    b. then, `<C-v> 10j P`
4. Select big block `<S-v> 10j`
    b. then, `:left`
