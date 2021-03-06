" ~/.vimrc
"
" The ordering for a lot of these settings doesn't make a lot of sense, but
" I've discovered that if I start moving stuff around things can get out of
" whack.

" fancy vim
set nocompatible
set updatetime=1000

" color-y displayish settings
colorscheme default
set t_Co=256
set background=light

" one place for vim swap files
set directory=~/.vim/

" load up plugins via vundle
if filereadable(expand("~/.vundle"))
  source ~/.vundle
endif

syntax enable
filetype plugin indent on


" remap <Leader> to spacebar
let mapleader = " "
set timeout timeoutlen=500

" undo text highlighting
nnoremap <Leader><Space> :nohl<CR>

" toggle pastemode
nnoremap <Leader>pt :set invpaste<CR>

" toggle line-numbers
nnoremap <Leader>ln :set invnumber<CR>

" toggle relative line-numbers
nnoremap <Leader>rn :set invrelativenumber<CR>

" easy way to toggle spell checking
nnoremap <Leader>s :set invspell<CR>

" toggle list characters
nnoremap <Leader>l :set invlist<CR>

" OPEN ALL THE TABS
set tabpagemax=9001

" highlight search real-time search
set hlsearch
set incsearch

" ignore case when searching
" unless you use a capital letter, then don't ignore case
set ignorecase
set smartcase

" how to represent invisible characters
set listchars=tab:→\ ,extends:→,precedes:←,trail:·,eol:¬
set list

" have some sensible defaults
set encoding=utf-8
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set showcmd
set showmode
set modelines=5
set showmatch
set matchtime=5
set scrolloff=3
set ruler
set nofoldenable

" vim command-line tab-completion
set wildmenu
set wildmode=list:longest

" remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" set filetypes
autocmd BufRead,BufNewFile *.md set ft=markdown

" disable netrw --------------
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
" ----------------------------

" vimdiff --------------------
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=black
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=grey ctermfg=black
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black
" ----------------------------

" spell-checking -------------
highlight SpellCap cterm=undercurl ctermbg=grey ctermfg=black
highlight SpellBad cterm=undercurl ctermbg=red ctermfg=black
highlight SpellRare cterm=undercurl ctermbg=cyan ctermfg=black
" ----------------------------

" pop-up menu ----------------
highlight Pmenu term=reverse ctermbg=darkgrey ctermfg=white
highlight PmenuSel cterm=bold term=reverse ctermbg=lightgrey ctermfg=black
" ----------------------------

" line numbers ---------------
highlight clear LineNr
highlight LineNr ctermfg=cyan
" ----------------------------

" list characters ------------
highlight SpecialKey ctermfg=yellow
" ----------------------------

" load plugin settings if ~/.vundle is found
if filereadable(expand("~/.vundle"))

    " vim-airline ----------------
    set noshowmode
    set laststatus=2
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    " ----------------------------

    " ctrlp ----------------------
    let g:ctrlp_open_multiple_files = 'tj' " open multiple files in additional tabs
    let g:ctrlp_show_hidden = 1 " include dotfiles and dotdirs in ctrlp indexing

    let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': ['<c-t>'],
                                  \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'] } " remap <cr> to open file in a new tab
    " ----------------------------

    " vim-json -------------------
    let g:vim_json_syntax_conceal = 0
    " ----------------------------

    " vim-gitgutter --------------
    highligh clear SignColumn
    nnoremap <Leader>gg :GitGutterToggle<CR>
    " ----------------------------

    " vim-table-mode -------------
    let g:table_mode_corner = '|'
    " ----------------------------
endif

" functions ------------------
" ----------------------------

" create parent directories on save
" http://stackoverflow.com/a/4294176/336520
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
