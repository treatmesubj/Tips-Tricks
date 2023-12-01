# [superuser.com](https://superuser.com/a/300364)

Use visual block mode `(Ctrl+v)` to select one set of lines, then either `y` or `d` them.

Then, if you selected the foo, bar, baz lines use visual block mode again to select the first column of the comment lines and then `Shift+p` them into place (or if you selected the comment lines, select the last column of the foo bar baz lines and `p` them into place.

Getting the hang of positioning might take a bit of practice, but when you've got the knack you'll be flying. When you've got a block selected you can also use `Shift+A` to append e.g. spaces to the block (when appending, the new text will only appear in the top line, but when you hit esc it will magically appear in all the selected lines). Similarly, `Shift+i` will do the same at the beginning of the selected block on each line.

You'll need to clean up the empty lines afterwards though.

There's also a great [vimcasts](http://vimcasts.org/episodes/selecting-columns-with-visual-block-mode/) episode showing these techniques in more detail.

