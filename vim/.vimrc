""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc from Bastian Rieck
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This configuration makes heavy use of `Plug`. Care has been taken to
" make it platform-independent.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug initialisation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible " no `vi` compatibility
filetype off     " no file type detection while setting up everything

" Perform automated installation of `plug` if it is not installed
" already
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'                                     " status line
Plug 'vim-voom/VOoM'                                             " outline tool
Plug 'tpope/vim-fugitive'                                        " git integration
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}  " fuzzy file finder
Plug 'junegunn/fzf.vim',                                         " fzf vim integration
Plug 'lervag/vimtex'                                             " LaTeX integration
Plug 'kshenoy/vim-signature'                                     " display marks

" I want the most recent version of these highlighting directives
" available in order to fix some issues.
Plug 'tpope/vim-markdown'

" Themes (most recent at the bottom)
Plug 'altercation/vim-colors-solarized'
Plug 'sickill/vim-monokai'
Plug 'morhetz/gruvbox'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'dracula/vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" language server setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'prabirshrestha/async.vim' " support package for asynchronous communication
Plug 'prabirshrestha/vim-lsp'   " main language server support package

" Highlight everything just like you would highlight a spelling error in
" the text somewhere.
highlight link LspErrorHighlight SpellCap
highlight link LspWarningHighlight SpellBad
highlight link LspInformationHighlight SpellBad
highlight link LspHintHighlight SpellBad

" The purpose of these lines is to add stuff to the *sign column* rather
" than as virtual text.
let g:lsp_signs_enabled           = 1
let g:lsp_signs_error             = {'text': '✗'}
let g:lsp_signs_warning           = {'text': '☡'}
let g:lsp_signs_hint              = {'text': '!'}
let g:lsp_virtual_text_enabled    = 0
let g:lsp_diagnostics_echo_cursor = 1  " show issues *under* the cursor

au User lsp_setup call lsp#register_server({
  \ 'name': 'pyls',
  \ 'cmd': {server_info->[$HOME.'/.vim/run_pyls.sh']},
  \ 'whitelist': ['python'],
  \ 'workspace_config': {
  \   'pyls': {
  \      'plugins': {
  \         'pyflakes': {'enabled': v:true},
  \         'pydocstyle': {'enabled': v:true},
  \         'pylint': {'enabled': v:false}
  \      }
  \   }
  \ }
  \ })

if executable('clangd')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd', '-background-index']},
    \ 'whitelist': ['c', 'cc', 'cpp', 'h', 'hh', 'hpp'],
    \ })
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" asynchronous completion setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'    " buffer text
Plug 'prabirshrestha/asyncomplete-file.vim'      " files and paths
Plug 'prabirshrestha/asyncomplete-ultisnips.vim' " snippets integration
Plug 'prabirshrestha/asyncomplete-lsp.vim'       " language server support
Plug 'yami-beta/asyncomplete-omni.vim'           " omni-completion (helpful for LaTeX)

let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion  = 1
let g:asyncomplete_auto_popup        = 1

" Forces a refresh of the completion options whenever CTRL + SPACE is
" being pressed.
imap <c-space> <Plug>(asyncomplete_force_refresh)

" Permits closing the completion window using the return key.
inoremap <buffer> <expr> <CR>  pumvisible() ? asyncomplete#close_popup() . "" : "\<CR>"
inoremap <buffer> <expr> <C-n> pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
inoremap <buffer> <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"

" Close the window once completion has been performed
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Buffer registration
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
  \ 'name': 'buffer',
  \ 'whitelist': ['*'],
  \ 'completor': function('asyncomplete#sources#buffer#completor'),
  \ 'config': {
  \    'max_buffer_size': -1,
  \  },
  \ }))

" File and path registration
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
  \ 'name': 'file',
  \ 'whitelist': ['*'],
  \ 'blacklist': [],
  \ 'priority': 10,
  \ 'completor': function('asyncomplete#sources#file#completor')
  \ }))

" Omni-completion registration: permit this only for selected file types
" because I do not want to clutter up everything.
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
  \ 'name': 'omni',
  \ 'whitelist': ['tex'],
  \ 'blacklist': ['*'],
  \ 'completor': function('asyncomplete#sources#omni#completor')
  \  }))

" Snippets registration
if has('python3')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
      \ 'name': 'ultisnips',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))
endif

" Ensures that insertion of matches only happens *after* one of them has
" been selected. Moreover, show preview window whenever possible.
set completeopt+=noinsert,menuone,noselect,preview

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings (plugin-independent)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on

set nocompatible   " Don't give a d*mn about vi-compatibility
set cursorline     " Show me the line
set number         " Numbered lines
set autoindent     " Automatic indentation
set smartindent    " Syntax-based indentation
set modeline       " Permit reading modeline configuration options
set vb             " visual bell
set t_vb=          " no effect for the visual bell
set encoding=utf-8 " Default encoding
set wildmenu       " Improved menu for completions etc.
set bg=dark        " Choose a dark background always
set noshowmode     " Do not show mode because `lightline` does it
set shortmess+=c   " Removes messages arising from the completion engine
set title          " Set terminal title
set mouse=a        " Automated use of the mouse
set mmp=50000      " More memory for patterns

" Ignore many files in the wildmenu; this is also picked up and
" respected by some plugins.
set wildignore+=*/tmp/*,*.aux,*.so,*.o,*.swp,*.zip

" Make backspace key behave normally and permit deleting stuff at the
" beginning of a line. This is *not* the default in all distributions
" so I am setting it here.
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map 'Alt' (or 'Option') and left/right for moving between individual
" tabs.
if has('macunix')
  nnoremap <M-b> gT
  nnoremap <M-f> gt
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-fugitive configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd BufReadPost fugitive://* set bufhidden=delete

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-lightline configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2

let g:lightline = {
  \ 'colorscheme': 'darcula',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ }

" Deactivate fancy fonts for Mac OS X
if has('macunix')
  let g:airline_powerline_fonts = 0
endif

let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
      \ }

" TODO: these are the long-form defaults used by `airline` in its current version; need to decide what to do about them.
"
" {
"   's': 'SELECT',
"   'V': 'V-LINE',
"   'ni': '(INSERT)',
"   'ic': 'INSERT COMPL',
"   'R': 'REPLACE',
"   '^S': 'S-BLOCK',
"   'no': 'OP PENDING',
"   '^V': 'V-BLOCK',
"   'multi': 'MULTI',
"   '__': '------',
"   'Rv': 'V REPLACE',
"   'c': 'COMMAND',
"   'ix': 'INSERT COMPL',
"   'i': 'INSERT',
"   'n': 'NORMAL',
"   'S': 'S-LINE',
"   't': 'TERMINAL',
"   'v': 'VISUAL'
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VOoM configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ensures semi-automated detection of the mode
let g:voom_ft_modes = {
  \ 'markdown': 'markdown',
  \ 'tex': 'latex',
  \ 'python': 'python',
  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fzf configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <C-p> :Files<Cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration for searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Handling of long lines
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wrap
set textwidth=72
set formatoptions+=qrn1 " _add_ this to the format options rather than
                        " overwriting them
set colorcolumn=80

" Disable highlighting by pressing leader+space
nnoremap <leader><space> :noh<cr>

" Jump between matching braces
nnoremap <tab> %
vnoremap <tab> %

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set undofile
set undodir=$HOME/.vim/undo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on
filetype plugin on

let c_space_errors = 1

au FileType * setl fo+=cro
au FileType gitcommit set spell spelllang=en_gb
au FileType tex       set spell spelllang=en_gb
au FileType text      set spell spelllang=en_gb
au FileType markdown  set spell spelllang=en_gb
au FileType python    set signcolumn=yes

set expandtab
set tabstop     =2
set softtabstop =2
set shiftwidth  =2

" Automatically reload the file if it has *not* been modified in the
" current buffer.
set autoread

" Check modification time whenever we (re-)gain the focus. This prevents
" working with an unspecified state or, even worse, overwriting changes.
au FocusGained * :checktime

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal handling (neovim only)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')
  " Get out of the terminal by pressing ESC
  tnoremap <Esc> <C-\><C-n>

  " Send ESC if pressing `CTRL+V`
  tnoremap <C-v><Esc> <Esc>

  " Disable spelling and numbers, and enter insert mode automatically
  " for each terminal.
  autocmd TermOpen * startinsert | setlocal nospell nonumber
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theming
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('termguicolors')
  if v:version > 800 ||  has('nvim')
    set termguicolors
  endif
endif

set background=dark
colors dracula

" Some additional options for theming; this makes it possible to easily
" switch between themes if necessary.
let g:palenight_terminal_italics=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType markdown nnoremap <buffer> <silent> <leader>D :!pandoc % -o %:r.docx<CR>
autocmd FileType markdown nnoremap <buffer> <silent> <leader>P :!pandoc % --pdf-engine=xelatex -o %:r.pdf<CR>
