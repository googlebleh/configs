" au BufRead,BufNewFile *.sig setlocal filetype=sml

syntax on
set ignorecase
set smartcase
set number
set ruler
set showcmd
set incsearch

set tabstop=4
set shiftwidth=4
set expandtab

set nowrap

set backspace=indent,eol,start " backspace over everything in insert mode

colors desert

" 78 char limit
highlight OverLength ctermbg=red ctermfg=white guibg=#295929
match OverLength /\%79v.\+/
