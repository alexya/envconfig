
" The modelines variable sets the number of lines (at the beginning and end of each file) vim checks for initializations.
set modelines=0		" CVE-2007-2438

" Define map <Leader>
let mapleader = " "
let maplocalleader = " "

" install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'      " NERDTree and related plugins
Plug 'jistr/vim-nerdtree-tabs'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'preservim/nerdcommenter'  " toggle comment tool

Plug 'airblade/vim-rooter'      " change the work dir to project root

Plug 'tpope/vim-fugitive'       " run git command/operation in vim
Plug 'airblade/vim-gitgutter'   " show git diff in the current buffer

Plug 'yssl/QFEnter'             " quick-fix 窗口快捷键
Plug 'skywind3000/vim-preview'  " 预览代码
Plug 'edkolev/promptline.vim'   " 生成 bash path color
Plug 'edkolev/tmuxline.vim'     " 生成 tmuxline color
Plug 'dense-analysis/ale'       " asynchronous Lint Engine
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'   " sa, sd and sr to add, del and replace a word's surranding

Plug 'junegunn/vim-easy-align'  " align the text
Plug 'vim-airline/vim-airline'  " statusbar
Plug 'vim-airline/vim-airline-themes'
"Plug 'itchyny/lightline.vim'


Plug 'reedes/vim-colors-pencil'   " pencil color theme
Plug 'andbar-ru/vim-unicon'       " unicon color theme
Plug 'chriskempson/base16-vim'    " base16 color theme(s)
Plug 'NLKNguyen/papercolor-theme' " paper color theme
Plug 'tomasiser/vim-code-dark'    " vscode dark color theme

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'plasticboy/vim-markdown'                                           " markdown highlight syntax
Plug 'mbbill/undotree'                                                   " popup a tree to show the undo history
Plug 'neoclide/coc.nvim', {'branch': 'release'}                          " Coc for LSP
Plug 'liuchengxu/vista.vim'                                              " tag plugin
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " If you have nodejs and yarn
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }           " fuzzy find

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'matze/vim-move'                                                    " move line(s) up and donw


" the Plugins which I am not sure how to use
" Plug 'sbdchd/neoformat' " format the buffer with the tool such a prettier, etc.

call plug#end()

" ============
" Custom Functions
" ============
" Get current directory
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf
command! Dir :echo expand('%:p')
command! Cp let @+ = expand('%:p')



let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:ruby_host_prog    = '/Users/yangzh/.rvm/rubies/ruby-2.4.1/bin/ruby'

" ============
" Standard Environment
" ============

" syntax settings
filetype indent plugin on
syntax enable
syntax on
set t_Co=256
set termguicolors

set lazyredraw
set nocompatible

let g:left_sep=""
let g:left_alt_sep=""
let g:right_sep=""
let g:right_alt_sep=""

" encoding settings
set encoding=utf8           " No need to set explicitly under Neovim: always uses UTF-8 as the default encoding.
set fileencoding=utf-8      " use utf-8 to create a new file
set fileencodings=utf-8,gbk " use utf-8 or gbk to open a file
let &termencoding=&encoding

" keep 500 lines of command line history
set history=500

" do not override system clipboard
set clipboard=

" set the location of the column mark highlight
" set colorcolumn=80

" keep undo history
set undofile
set undodir=~/.vim/undodir

" 设置分割线
set fillchars=vert:│,stl:\ ,stlnc:\ 
set list lcs=tab:\ \ ,conceal:\|

" line settings
set linebreak
set textwidth=80
set wrap

" TAB settings
" set tabpagemax=9
set showtabline=0

" disable console bell
set noerrorbells
set novisualbell

set nowrap

set relativenumber
set number  " show line numbers
set ruler   " show the cursor's position
" set rulerformat=%15(%c%V\ %p%%%)

" Show command in status line
set ch=1
set stl=\ [File]\ %t%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]

set ls=2        " always show status bar
set wildmenu    " command line completion

" Search Option
set hlsearch    " highlight search terms
set magic       " set magic on, for regular expressions
set showmatch   " show matching bracets when text indicator is over them
set mat=2       " how many tenths of a second to blink
set is          " do incremental searching, using 'set nois' to disable incremental searching
set ignorecase  " ignore case during searches
set smartcase   " if using UPPER case in SEARCH mode, ignore setting 'ignorecase'

" TAB and indent settings
set tabstop=2    " insert 2 spaces whenever the tab key is pressed
set expandtab    " use spaces instead of tabs
set smarttab
set shiftwidth=2 " set indentation to 2 spaces
set softtabstop=2

" Show invisible chars
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" set invlist/list/nolist
set nolist

set diffopt=vertical                    " vertical diff window
set tags=./.tags;,.tags

set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class,*.so
set wildignore+=*.un~,*.pyc,*.zip,*.rar,*.dll,*.dmg,*.o,*~,*.exe
set wildignore+=*.jpg,*.png,*.jpeg,*.gif,*.svg,*.ico
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/node_modules/*,*/bower_components/*

set ttimeout
set ttimeoutlen=100

set hidden
set nobackup
set noswapfile
set nowritebackup
set updatetime=300
set autowriteall                        " auto save

" Display incomplete commands
set showcmd 
set showmode

set autoindent  " start new line at the same indentation level
set smartindent 

set autoread    " auto re-load file when it is changed outside VIM
au FocusGained,BufEnter * checktime


" 滚动时上下保留行
set scrolloff=2

syntax sync minlines=256
set synmaxcol=1000

" In INSERT mode, use <BS>、<Del> <C-W> <C-U>
" Set backspace=2 " more powerful backspacing
set backspace=indent,eol,start

" Mouse can be used in all modes
set mouse=a

" Auto complete
set complete=.,w,b,k,t,i
set completeopt=longest,menu

" Set the command bar height
set cmdheight=2

" highlight current line
set cursorline
" autocmd InsertEnter * set nocul
" autocmd InsertLeave * set cul

" set font
set guifont=Fira\ Code\ Light:h14

" =============
" Key Shortcut, mappings
" =============
" Fast editing of .vimrc
noremap <silent> <leader>ee :<C-U>tabnew $MYVIMRC <bar> tcd %:h<cr>

" Maps Alt-J and Alt-K to macros for moving lines up and down
" Works for modes: Normal, Insert and Visual
noremap ∆ <Esc>:m .+1<CR>
noremap ˚ <Esc>:m .-2<CR>
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi

" Move the focus to diff window
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nmap L $
nmap H ^
vmap L $
vmap H ^

" tab navigator
nmap <leader>tw :tabnew<cr>
nmap <leader>tp :tabprevious<cr>
nmap <leader>tn :tabnext<cr>
nmap <C-9> :tabprevious<cr>
nmap <C-0> :tabnext<cr>
nmap X :q<cr>

" Insert mode shortcut
inoremap jk <esc> 
" inoremap <C-h> <Left>
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
" inoremap <C-l> <Right>
" inoremap <C-d> <Delete>

" move the cursor to the end of the selected text after yank/copy
" vmap y y`]  " or this map can do the same
vmap <C-y> ygv<Esc>

" copy/cp the current selection to clipboard
vmap <leader>cp "*y

" Get current date 
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf
" Insert current date when press F4 under INSERT mode
"imap <f4>=GetDateStamp()<cr>

" =============
" Settings for plugins
" =============

"{vim-rooter
" To toggle between automatic and manual behaviour, use :RooterToggle.
"}


"{NERDTree
nmap <Leader>nt :NERDTreeToggle<cr>
nmap <Leader>ntt :NERDTreeTabsToggle<cr>
nmap <Leader>ntf :NERDTreeTabsFind<cr>

let NERDTreeIgnore = ['\~$', '\$.*$', '\.swp$', '\.pyc$', '#.\{-\}#$']
let s:ignore = ['.pb', '.xls', '.xlsx', '.mobi', '.mp4', '.mp3']

for s:extname in s:ignore
    let NERDTreeIgnore += [escape(s:extname, '.~$')]
endfor

let NERDTreeRespectWildIgnore     = 1
let g:NERDTreeChDirMode           = 0
"}


"Leaderf{
let g:Lf_ShortcutF = '<C-P>' " show the file finder directly
let g:Lf_ShowDevIcons = 0 " don't show the devIcon
let g:Lf_WindowPosition = 'popup' " popup mode
let g:Lf_PreviewInPopup = 1
let g:Lf_PopupWidth = 0.75
let g:Lf_PopupHeight = 0.5
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 1
let g:Lf_MruMaxFiles = 128
let g:Lf_StlSeparator = { 'left': g:left_sep, 'right': g:right_sep, 'font': '' }
" let g:Lf_StlColorscheme = 'gruvbox_material'
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

noremap <leader>mr :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>lm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>lb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>lc :<C-U><C-R>=printf("Leaderf colorscheme %s", "")<CR><CR>
noremap <leader>lt :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>ll :<C-U><C-R>=printf("Leaderf %s", "")<CR>
noremap <leader>lr :<C-U><C-R>=printf("Leaderf rg -e %s", "")<CR>
noremap <leader>rg :<C-U><C-R>=printf("Leaderf rg -e %s", expand("<cword>"))<CR><CR>
noremap <F3> :<C-U><C-R>=printf("Leaderf rg -e %s", expand("<cword>"))<CR><CR>
" noremap <C-f> :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>

let g:Lf_NormalMap = {
    \ "_":           [["<C-j>", "j"], ["<C-k>", "k"]],
    \ "File":        [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
    \ "Buffer":      [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
    \ "Mru":         [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
    \ "Tag":         [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
    \ "BufTag":      [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<CR>']],
    \ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
    \ "Line":        [["<ESC>", ':exec g:Lf_py "lineExplManager.quit()"<CR>']],
    \ "History":     [["<ESC>", ':exec g:Lf_py "historyExplManager.quit()"<CR>']],
    \ "Help":        [["<ESC>", ':exec g:Lf_py "helpExplManager.quit()"<CR>']],
    \ "Self":        [["<ESC>", ':exec g:Lf_py "selfExplManager.quit()"<CR>']],
    \ "Colorscheme": [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
    \ "Rg":          [["<ESC>", ':exec g:Lf_py "rgExplManager.quit()"<CR>']]
    \}
"}

"{vim-preview
noremap <m-u> :PreviewScroll -1<cr>
noremap <m-d> :PreviewScroll +1<cr>
inoremap <m-u> <c-\><c-o>:PreviewScroll -1<cr>
inoremap <m-d> <c-\><c-o>:PreviewScroll +1<cr>
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
noremap <m-n> :PreviewSignature!<cr>
inoremap <m-n> <c-\><c-o>:PreviewSignature!<cr>
"}

"airline{
let g:airline_powerline_fonts = 0
let g:airline_left_sep=g:left_sep
let g:airline_left_alt_sep=g:left_alt_sep
let g:airline_right_sep=g:right_sep
let g:airline_right_alt_sep=g:right_alt_sep
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z' ]
      \ ]

" let g:airline_solarized_bg='light' " if you want to use solarized color theme,
let g:airline_theme = 'base16'
noremap <leader>at :<C-U><C-R>=printf("AirlineTheme %s", "")<CR>
"}

"lightline{
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ }
"}

"promptline{
":PromptlineSnapshot! ~/.local/etc/shell_prompt.sh airline
let g:promptline_symbols = {
            \ 'left'          : g:left_sep,
            \ 'left_alt'      : g:left_alt_sep,
            \ 'right'         : g:right_sep,
            \ 'right_alt'     : g:right_alt_sep,
            \ 'dir_sep'       : " > ",
            \ 'truncation'    : "\u22EF",
            \ 'vcs_branch'    : "\u16A0 "}
if !empty(globpath(&rtp, "promptline.vim"))
    let g:promptline_preset = {
                \ 'a' : [ promptline#slices#user() ],
                \ 'c' : [ promptline#slices#cwd() ],
                \ 'y' : [ promptline#slices#vcs_branch() ]}
endif
"}

"tmuxline{
":Tmuxline airline
":TmuxlineSnapshot! ~/.local/etc/tmuxline.conf
let g:tmuxline_separators = {
            \ 'left'     : g:left_sep,
            \ 'left_alt' : g:left_alt_sep,
            \ 'right'    : g:right_sep,
            \ 'right_alt': g:right_alt_sep}
    
let g:tmuxline_preset = {
            \'a'    : '#S',
            \'win'  : '#I #W',
            \'cwin' : '#I #W #F',
            \'x'    : '%Y-%m-%d',
            \'y'    : '%H:%M:%S',
            \'z'    : "#(ip a| grep inet[^6] | awk '{print $2}' | sed 's/\\\\\\\\/.*//; s/ //' | grep -v '127.0.0.1' | grep -v '^10.0')",
            \'options': {
            \'status-justify':'left'}
            \}
"}

"{ vim-markdown
let g:vim_markdown_folding_disabled = 1
"}

"{markdown-preview
let g:mkdp_open_to_the_world = 1
let g:mkdp_open_ip = 'localhost'
let g:mkdp_port = 6060
nmap <leader>md :MarkdownPreview<CR>
"}

"{ale
let g:ale_open_list = 1
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
" let g:ale_keep_list_window_open = 1
"}

"{vim-sandwitch
" let g:sandwich#recipes += [
"       \   {
"       \     'buns'        : ['{', '}'],
"       \     'motionwise'  : ['line'],
"       \     'kind'        : ['add'],
"       \     'linewise'    : 1,
"       \     'command'     : ["'[+1,']-1normal! >>"],
"       \   },
"       \   {
"       \     'buns'        : ['{', '}'],
"       \     'motionwise'  : ['line'],
"       \     'kind'        : ['delete'],
"       \     'linewise'    : 1,
"       \     'command'     : ["'[,']normal! <<"],
"       \   }
"       \ ]
"}

"{vim colors: pencil or unicon
set background=light  " light | dark
colorscheme unicon "  unicon | pencil | PaperColor 
"}

"{undotree
nnoremap <leader>un :UndotreeToggle<CR>
"}

"{coc-settings
"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" use Tab to selec the 1st item in the list, the behavior likes the VSCode
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> ]g <Plug>(coc-diagnostic-prev)
nmap <silent> [g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Show signature help while editing
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" Formatting selected code. NOTE: it seems that it can't fix Ale linting
" warnings
xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm  <Plug>(coc-format-selected)

"}

"{vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"}

"{NerdCommenter
nmap <C-_> <plug>NERDCommenterToggle
vmap <C-_> <plug>NERDCommenterToggle<CR>gv
nmap <leader>cc <plug>NERDCommenterToggle
vmap <leader>cc <plug>NERDCommenterToggle<CR>gv

" regaining the selection if you are in visual mode
" vmap <C-_> <plug>NERDCommenterToggle<CR>gv
"}

"{vim-prettier
let g:prettier#exec_cmd_async = 1
let g:prettier#partial_format=1
vnoremap <Leader>pp :PrettierPartial<CR>
nmap <Leader>py <Plug>(Prettier)
" let g:prettier#exec_cmd_path = "~/path/to/cli/prettier"
"}

"{vista
let g:vista_default_executive = 'ctags'
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 0
let g:vista#renderer#icons = {
                        \   "function": "\uf794",
                        \   "variable": "\uf71b",
                        \  }
let g:vista_executive_for = {
			\ 'javascript': 'coc',
			\ 'php': 'coc',
			\ }
nnoremap <silent><nowait> <space>ta :<C-u>Vista!!<cr>
"}
