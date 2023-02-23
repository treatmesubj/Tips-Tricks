" TODO: real nesting
" because I use 4-space tab-width, have to manually increase these matches to
" 8 spaces to acommodate 3rd nested list item
" /usr/share/vim/vim81/syntax/markdown.vim
syn match markdownListMarker "\%(\t\| \{0,8\}\)[-*+]\%(\s\+\S\)\@=" contained
syn match markdownOrderedListMarker "\%(\t\| \{0,8}\)\<\d\+\.\%(\s\+\S\)\@=" contained
