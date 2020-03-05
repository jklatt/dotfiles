" Expanding ensures that we can use environment variables here; else
" I will have to provide different versions depending on the OS.
let g:python3_host_prog = expand('$HOME/.virtualenvs/nvim/bin/python3')
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
