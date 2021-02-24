
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

" NERDTree and related plugins
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'airblade/vim-rooter'                        " change the work dir to project root

Plug 'tpope/vim-fugitive'                         " run git command/operation in vim
Plug 'airblade/vim-gitgutter'                     " show git diff in the current buffer

Plug 'yssl/QFEnter'                               " quick-fix 窗口快捷键
Plug 'skywind3000/vim-preview'                    " 预览代码
Plug 'edkolev/promptline.vim'                     " 生成 bash path color
Plug 'edkolev/tmuxline.vim'                       " 生成 tmuxline color
Plug 'dense-analysis/ale'                         " linting
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'                     " sa, sd and sr to add, del and replace a word's surranding

Plug 'junegunn/vim-easy-align'                    " align the text
Plug 'vim-airline/vim-airline'                    " statusbar
Plug 'vim-airline/vim-airline-themes'
Plug 'reedes/vim-colors-pencil'                   " pencil color theme
Plug 'andbar-ru/vim-unicon'                       " unicon color theme
Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'

Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'neoclide/coc.nvim', {'branch': 'release'}   " Coc for LSP

Plug 'plasticboy/vim-markdown'                    " markdown highlight syntax
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " If you have nodejs and yarn

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' } " fuzzy find
Plug 'mbbill/undotree'

Plug 'sbdchd/neoformat' " format the buffer with the tool such a prettier, etc.

" Initialize plugin system
call plug#end()

" Get current directory
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf


" Fast editing of .vimrc
noremap <silent> <leader>ee :<C-U>tabnew $MYVIMRC <bar> tcd %:h<cr>

" ============
" Standard Environment
" ============

filetype indent plugin on
syntax enable
syntax on
set t_Co=256
set termguicolors

let g:left_sep=""
let g:left_alt_sep=""
let g:right_sep=""
let g:right_alt_sep=""

set fileencoding=utf-8                  "使用utf-8新建文件
set fileencodings=utf-8,gbk             "使用utf-8或gbk打开文件
let &termencoding=&encoding

" No need to set explicitly under Neovim: always uses UTF-8 as the default encoding.
set encoding=utf8

set history=500                "keep 500 lines of command line history 
set clipboard=unnamed

" line settings
set linebreak
set textwidth=80
set wrap

" TAB settings
set tabpagemax=9
set showtabline=2

" Console bell
set noerrorbells
set novisualbell

set relativenumber
set number  " show line numbers
set ruler   " show the cursor's position
" set rulerformat=%15(%c%V\ %p%%%)

" Show command in status bar
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
set tabstop=2   " insert 2 spaces whenever the tab key is pressed
set expandtab   " use spaces instead of tabs
set smarttab
set shiftwidth=2    " set indentation to 2 spaces
set softtabstop=2

" Show invisible chars
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set nolist          " set invlist/list/nolist

set diffopt=vertical                    " vertical diff window
set wildignore=*.swp,*.bak,*.pyc,*.obj,*.o,*.class
set wildignore+=*.so,*.swp,*.zip        " MacOSX/Linux
set wildignore+=*.exe                   " Windows
set tags=./.tags;,.tags
set ttimeout
set ttimeoutlen=100
set hidden
set nobackup
set nowritebackup
set updatetime=300
set autowriteall                        " auto save

" Display incomplete commands
set showcmd 
set showmode

set autoindent  " start new line at the same indentation level
set smartindent 

set autoread    " auto re-load file when it is changed outside VIM

" In INSERT mode, use <BS>、<Del> <C-W> <C-U>
" Set backspace=2 " more powerful backspacing
set backspace=indent,eol,start

" Mouse can be used in all modes
set mouse=a

" Auto complete
set complete=.,w,b,k,t,i
set completeopt=longest,menu

" Set the command bar height
set cmdheight=1

" highlight current line
set cursorline
autocmd InsertEnter * set nocul
autocmd InsertLeave * set cul

" set font
" set guifont=DroidSansMono\ Nerd\ Font:h11

" =============
" Key Shortcut, mappings
" =============

" Move the focus to diff window
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

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

" move the cursor to the end of the selected text after yank
vmap <C-y> ygv<Esc>
" vmap y y`]  " or you can use map, both of them are the same function

" Get current date 
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf
" Insert current date when press F4 under INSERT mode
imap <f4>=GetDateStamp()<cr>

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
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 1
let g:Lf_MruMaxFiles = 128
let g:Lf_StlSeparator = { 'left': g:left_sep, 'right': g:right_sep, 'font': '' }
" let g:Lf_StlColorscheme = 'gruvbox_material'
" let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

noremap <leader>mr :<C-U><C-R>=printf("Leaderf! mru %s", "")<CR><CR>
noremap <leader>lm :<C-U><C-R>=printf("Leaderf! mru %s", "")<CR><CR>
noremap <leader>lb :<C-U><C-R>=printf("Leaderf! buffer %s", "")<CR><CR>
noremap <leader>lc :<C-U><C-R>=printf("Leaderf! colorscheme %s", "")<CR><CR>
noremap <leader>lt :<C-U><C-R>=printf("Leaderf! bufTag %s", "")<CR><CR>
noremap <leader>ll :<C-U><C-R>=printf("Leaderf! %s", "")<CR>
noremap <leader>lr :<C-U><C-R>=printf("Leaderf! rg -e %s", "")<CR>
noremap <leader>rg :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>
" noremap <C-f> :<C-U><C-R>=printf("Leaderf! rg -e %s", expand("<cword>"))<CR><CR>

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
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z' ]
      \ ]

" let g:airline_solarized_bg='light' " if you want to use solarized color theme,
let g:airline_theme = 'luna'
noremap <leader>at :<C-U><C-R>=printf("AirlineTheme %s", "")<CR>
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
autocmd CursorHoldI * silent! call CocAction('showSignatureHelp')
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm  <Plug>(coc-format-selected)

"}
