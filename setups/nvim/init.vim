

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Install Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let hasplugins=1
" If vim-plug is not installed, do it first
if (!filereadable(expand("$HOME/.config/nvim/autoload/plug.vim")))
    echo " -- Installing vim-plug -- "
    echo ""
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let hasplugins=0
endif

call plug#begin('~/.local/share/nvim/plugged')

    Plug 'morhetz/gruvbox'                " Color theme
    Plug 'vim-airline/vim-airline'        " airline is a better status line and a tab-bar for nvim.
    Plug 'vim-airline/vim-airline-themes' " airline themes
    Plug 'tpope/vim-surround'             " faster edits for surrounding whatever
    Plug 'jiangmiao/auto-pairs'           " Autoclose brackets and what not...  
    Plug 'tpope/vim-repeat'               " Support for repeating plugin executions with '.'
    Plug 'Shougo/deoplete.nvim'           " Autocomplete
    Plug 'kien/ctrlp.vim'                 " ctrl-p is a fuzzy file finder.
    Plug 'junegunn/vim-easy-align'        " Helps aligning txt

    " Maybies...
    "Plug 'benekastah/neomake'             " Asynchronous syntax checking
    "Plug 'scrooloose/nerdtree'            " List files
    "Plug 'rust-lang/rust.vim'             " Rust Lang
    "Plug 'Valloric/YouCompleteMe'         " Autocomplete
    "Plug 'takac/vim-hardtime'             " Help drop bad vim habits
    "Plug 'mileszs/ack.vim'                " Ag, faster grep
    "Plug 'dhruvasagar/vim-table-mode'     " Tables Support =D
    "Plug 'airblade/vim-gitgutter'         " airline git mods
    "Plug 'ervandew/supertab'              " Tab completion
    "Plug 'tpope/vim-vinegar'              " Explore files

call plug#end()

if hasplugins == 0
    echo "Installing Plugins, please ignore key map error messages"
    echo ""
    :PlugInstall
    :q
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax enable
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
    set background=dark             " dark background prepared highlight.
    colorscheme base16-default
else
    set background=dark             " dark background prepared highlight.
    colorscheme gruvbox
endif

set so=7
set history=700                 " Sets how many lines of history VIM has to remember
set cursorline  				" highlight current line
set laststatus=2                " Show status bar
set number                      " Show line numbers.
set relativenumber              " show line number relative to current position
set completeopt=menuone,longest,preview
set hls                         " Highlight search matches.
set incsearch                   " find as you type search
set noignorecase
"set ignorecase                  " case insensitive search
"set smartcase                   " case sensitive when uc present
set wildmenu                    " show list instead of just completing
set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
set foldenable                  " auto fold code
set foldmethod=indent           
set foldlevelstart=99           " folding nesting level
set foldnestmax=10              " 10 nested fold max
set mouse=a
set showmatch                   " show matching brackets/parenthesis
set magic                       " For regular expressions turn magic on
set clipboard=unnamedplus       " Use X clipboard
filetype plugin indent on
filetype on
set encoding=utf8
set ffs=unix,mac,dos
set autoread
set backup             " keep a backup file (restore to previous version)
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload
"set lazyredraw


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmd
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Autoconverts fileformat to unix.
autocmd BufRead,BufNewFile * if &modifiable | :set ff=unix | endif

" Autoremove unwanted chars. Potentially problematic!
" autocmd BufWritePre <buffer> :call Tydiup()

" Autocreate dir to file on save, if it does not exist
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CMD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":Difforig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Formating
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ai "Auto indent
set si "Smart indent
set nowrap                      " wrap long lines
set hidden                      " Allow buffer not in windows, to remain in memory. A.k.a switch between unsaved buffers
set shiftwidth=4                " use indents of 4 spaces
set tabstop=4                   " an indentation every four columnsvmap <C-c> "+yi
set expandtab                   " tabs are spaces, not tabs" copy and paste shortcuts.
set softtabstop=4               " let backspace delete indentvmap <C-x> "+c
"set iskeyword+=-
"set iskeyword+=_
"set list
"set listchars=tab:>.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
"set listchars=tab:▸\ ,eol:¬
" No more autoinserting comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key mapping
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = ","
let g:mapleader = ","

" Toggle between normal and relative numbering.
nnoremap <leader>q :call NumberToggle()<cr>

" Replace current word
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

"clearing highlighted search
nmap <silent> <leader>/ :nohlsearch<CR>

" Stupid shift key fixes
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q


" Exit insert-mode with jj
imap jj <ESC>

" copy and paste shortcuts.
"vmap <C-c> "+yi
"vmap <C-x> "+c
"vmap <C-v> c<ESC>"+p
"imap <C-v> <ESC>"+pa

" disable freaking ex mode
nnoremap Q <nop>

" allow quit via single keypress (Q)
map Q :qa<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" get off my lawn
nnoremap <left> :echoe "use h"<cr>
nnoremap <right> :echoe "use l"<cr>
nnoremap <up> :echoe "use k"<cr>
nnoremap <down> :echoe "use j"<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Easier buffer switching
map <Leader>a :bprev<Return>
map <Leader>s :bnext<Return>
map <Leader>d :bd<Return>

" Close the current buffer
map <leader>bd :Bclose<cr>
" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove<cr>

"Easyly split windows
"nnoremap <leader>v <C-w>v<C-w>l
"nnoremap <leader>s <C-w>s

" Increment numbers
vnoremap <C-a> :call Incr()<CR>

" Better block identation
vnoremap < <gv
vnoremap > >gv

" Easier folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.cache/nvim'
    let topdir = parent . '/' . prefix . '/'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory',
                \ 'undo': 'undodir' }

    if exists("*mkdir")
        if !isdirectory(topdir)
            call mkdir(topdir)
        endif
    endif


    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . '/' . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

function Tydiup()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")

    " Do the business:
    " If vim opens ff=mac in ff=unix mode, this will remove all line ends.
    %s/\r//eg

    %s/\s\+$//e
    %s/\_s*\%$/\r/e

    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Increment numbers
function! Incr()
  let a = line('.') - line("'<")
  let c = virtcol("'<")
  if a > 0
    execute 'normal! '.c.'|'.a."\<C-a>"
  endif
  normal `<
endfunction

" Autocreate parent dirs when saving file.
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins Configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline
let g:airline#extensions#tabline#enabled = 2
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'
let g:airline_theme= 'base16'

" Deoplete.
let g:deoplete#enable_at_startup = 1
" tab and ctrl-space keys ...
imap <expr><tab>   pumvisible() ? "\<C-n>" : "\<tab>"
imap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"
"inoremap <expr> <C-Space> deoplete#mappings#manual_complete()
"imap <C-@> <C-Space>

" NeoMake
"let g:neomake_airline = 1
"autocmd! BufWritePost * Neomake " Run it every filesave

" YouCompleteMe
"let g:ycm_global_ycm_extra_conf = '~/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
"let g:ycm_key_list_select_completion = ['<u>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
"let g:ycm_key_invoke_completion = '<C-Space>'

" NerdTree
"map <leader>n :NERDTreeToggle<CR>

" Ack
"if executable('ag')
"  let g:ackprg = 'ag --vimgrep'
"endif

" table mode
"let g:table_mode_corner_corner="+"
"let g:table_mode_corner="|"
"let g:table_mode_header_fillchar="="
":TableModeToggle

" Hardtime
"let g:hardtime_showmsg = 1
"let g:hardtime_default_on = 1 
"let g:hardtime_allow_different_key = 1
"let g:hardtime_maxcount = 4
"let g:hardtime_timeout = 1000

" Easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
