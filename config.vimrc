" Configuration file for vim

set modelines=0		" CVE-2007-2438

if v:version < 700
    echoerr 'This _vimrc requires Vim 7 or later.'
    quit
endif


" don't check file type first before plug-in setup
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo

Plugin 'bufexplorer.zip'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
Plugin 'anyakichi/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'kien/ctrlp.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-commentary'
Plugin 'twe4ked/vim-colorscheme-switcher'


call vundle#end()

" Use different indent setting for different file type
filetype plugin indent on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" or access for more details https://github.com/VundleVim/Vundle.vim
" Put your non-Plugin stuff after this line


" Define map <Leader>
let mapleader = ","
let maplocalleader = ","

" Get current directory
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" Pass the header comment, and jump to the first effective line
func! GotoFirstEffectiveLine()
    let l:c = 0
    while l:c<line("$") && (
                \ getline(l:c) =~ '^\s*$'
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*Comment.*"
                \ || synIDattr(synID(l:c, 1, 0), "name") =~ ".*PreProc$"
                \ )
        let l:c = l:c+1
    endwhile
    exe "normal ".l:c."Gz\<CR>"
endf

" Find matched quote and highlight
func! MatchingQuotes()
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap " ""<left>
    inoremap ' ''<left>
endf

" Get current date 
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf

"Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>

" ============
" Environment
" ============

set history=500                "keep 500 lines of command line history 
set clipboard=unnamed

" line settings
set linebreak
set nocompatible
set textwidth=80
set wrap

" TAB settings
set tabpagemax=9
set showtabline=2

" Console bell
set noerrorbells
set novisualbell
set t_vb= "close visual bell

set number  " show line numbers
set ruler   " show the cursor's position
set rulerformat=%15(%c%V\ %p%%%)

" Show command in status bar
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]
set ls=2        " always show status bar
set wildmenu    " command line completion

" Search Option
set hlsearch    " highlight search terms
set magic       " set magic on, for regular expressions
set showmatch   " show matching bracets when text indicator is over them
set mat=2       " how many tenths of a second to blink
set incsearch   " do incremental searching
set ignorecase  " ignore case during searches
set smartcase   " if using UPPER case in SEARCH mode, ignore setting 'ignorecase'

" TAB and indent settings
set tabstop=4   " insert 4 spaces whenever the tab key is pressed
set expandtab   " use spaces instead of tabs
set smarttab
set shiftwidth=4    " set indentation to 4 spaces
set softtabstop=4   

" Show invisible chars
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set nolist          " set invlist/list/nolist

" Display incomplete commands
set showcmd 
set showmode

" Root permission on a file inside VIM
cmap w!! w !sudo tee >/dev/null %

set autoindent  " start new line at the same indentation level
set smartindent 

set autoread    " auto re-load file when it is changed outside VIM

" In INSERT mode, use <BS>、<Del> <C-W> <C-U>
" Set backspace=2 " more powerful backspacing
set backspace=indent,eol,start

" Mouse can be used in all modes
set mouse=a

" Backup and swap settings
"set nobackup
"set noswapfile

" Auto complete
set complete=.,w,b,k,t,i
set completeopt=longest,menu

" Code fold by (markder/syntax,etc.)
" set foldmethod=marker " !!! this setting will hit performance issue

" Set the command bar height
set cmdheight=1         

" highlight current line
set cursorline

" =====================
" Multi language environment 
"   default is UTF-8 
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    " Language messages zh_CN.utf-8

    if has('win32')
        language english
        let &termencoding=&encoding
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " do not use Unicode signature

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" Persistent undo, Vim7.3 new feature
if has('persistent_undo')
    set undofile

    " set the directory of saving the undo files
    if has("unix")
        set undodir=/tmp/,~/tmp,~/Temp
    else
        set undodir=d:/temp/
    endif
    set undolevels=1000
    set undoreload=10000
endif


" =========
" AutoCmd
" =========
if has("autocmd")
    
    " fill the bracket automatically
    func! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END

    " Autocmd for different file type
    " Auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,javascript exe AutoClose()
    au FileType php,javascript exe MatchingQuotes()
    au FileType ruby set et sw=2 ts=2 sts=2
    au FileType ruby compiler ruby

    " Don't write backup file if vim is being called by "crontab -e"
    au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
    " Don't write backup file if vim is being called by "chpass"
    au BufWrite /private/etc/pw.* set nowritebackup nobackup

    " Auto Check Syntax
    au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)

    " When .vimrc is edited, reload it
    au BufWritePost .vimrc source ~/.vimrc 

    " JavaScript 
    au FileType html,javascript let g:javascript_enable_domhtmlcss = 1
    au BufRead,BufNewFile *.js setf jquery

    " Add Dict for different languages
    if has('win32')
        let s:dict_dir = $VIM.'\vimfiles\dict\'
    else
        let s:dict_dir = $HOME."/.vim/dict/"
    endif
    let s:dict_dir = "setlocal dict+=".s:dict_dir

    au FileType php exec s:dict_dir."php_funclist.dict"
    au FileType css exec s:dict_dir."css.dict"
    au FileType javascript exec s:dict_dir."javascript.dict"

    " Format JavaScript file
    au FileType javascript map <f12> :call g:Jsbeautify()<cr>
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS

    " Support ActionScript file format
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.as setf actionscript 

    " Support CSS3 file format
    au BufRead,BufNewFile *.css set ft=css syntax=css3

    " Support Object-C file format
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.m,*.h setf objc

    " Smali syntax supports
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.smali set filetype=smali

    " Ardunio Support
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.pde,*.ino set filetype=arduino

    " Transfer <enter> to UNIX format for specified file format
    au FileType php,javascript,html,css,python,vim,vimwiki set ff=unix

    " Save editing state
    au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
    au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif

    " Highlight current line
    au InsertLeave * se nocul
    au InsertEnter * se cul

    " set current directory as the working directory
    autocmd BufEnter * lcd %:p:h

endif


" =========
" GUI
" =========
if has('gui_running')
    " Only show menu
    set guioptions=mcr

    " Highlight current line
    set cursorline

    if has("win32")
        " Windows compatible settings
        source $VIMRUNTIME/mswin.vim

        " F11 maximize (comment the following, as they need 3rd party Dlls)
        " nmap <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        " nmap <Leader>ff :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " Maximize window automatically
        " au GUIEnter * simalt ~x

        " Set transparency for windows 
        " au GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 250)
        set lines=50 columns=120

        " Font setting
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h12:cANSI'
        if has("multi_byte")
            exec 'set guifontwide='.iconv('NSimSun', &enc, 'gbk').':h12'
        endif
    endif

    " Under Mac
    if has("gui_macvim")
        set anti

        set guifont=Monaco:h16
        set guifontwide=Lantinghei\ SC\ Extralight:h16

        " Set transparency and size of window
        set transparency=5
        set lines=50 columns=150

        " Using full screen of MacVim
        let s:lines=&lines
        let s:columns=&columns

        func! FullScreenEnter()
            set lines=999 columns=999
            set fu
        endf

        func! FullScreenLeave()
            let &lines=s:lines
            let &columns=s:columns
            set nofu
        endf

        func! FullScreenToggle()
            if &fullscreen
                call FullScreenLeave()
            else
                call FullScreenEnter()
            endif
        endf

        set guioptions+=e
        " Shortcut to switch full screen
        nmap <f11> :call FullScreenToggle()<cr>
        nmap <Leader>ff  :call FullScreenToggle()<cr>

        " I like TCSH :^)
        set shell=/bin/tcsh

        " Set input method off
        set imdisable

        " Set QuickTemplatePath
        let g:QuickTemplatePath = $HOME.'/.vim/templates/'

        " If it is an empty file, set working directory to ~/Desktop/
        lcd ~/Desktop/
    endif

    " Under Linux/Unix etc.
    if has("unix") && !has('gui_macvim')
        set guifont=Monaco:h14 " Courier\ 12\ Pitch\ 14
    endif
endif

" =============
" Key Shortcut
" =============
nmap <C-t>   :tabnew<cr>
nmap <C-p>   :tabprevious<cr>
nmap <C-n>   :tabnext<cr>
nmap <C-k>   :tabclose<cr>
nmap <C-Tab> :tabnext<cr> 

" Insert mode shortcut
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-d> <Delete>

" Shortcut keys for plug-ins
nmap <C-d> :NERDTree<cr>
nmap <C-e> :BufExplorer<cr>
nmap <f2>  :BufExplorer<cr>

" Insert current date when press F4 under INSERT mode
imap <f4> <C-r>=GetDateStamp()<cr>

" Shortcut to show plug-ins window
nmap <Leader>ca :Calendar<cr>
nmap <Leader>mr :MRU<cr>
nmap <Leader>nt :NERDTree<cr>
nmap <Leader>be :BufExplorer<cr>

nmap <Leader>find :CtrlP<cr>
nmap <Leader>tag  :TagbarToggle<cr>

" Shortcut to goto the first efficitve line
nmap <Leader>gff :call GotoFirstEffectiveLine()<cr>

" Press Q, directly exit
nmap Q :x<cr>


" =================
" Plugin Configure
" =================
" Javascript in CheckSyntax
if has('win32')
    let g:checksyntax_cmd_javascript  = 'jsl -conf '.shellescape($VIM . '\vimfiles\plugin\jsl.conf')
else
    let g:checksyntax_cmd_javascript  = 'jsl -conf ~/.vim/plugin/jsl.conf'
endif
let g:checksyntax_cmd_javascript .= ' -nofilelisting -nocontext -nosummary -nologo -process'

" VIM HTML plug-in 
let g:no_html_toolbar = 'yes'

" Don't show VimWiki menu
if has('gui_running')
    let g:vimwiki_menu = ""
endif

" Don't let NERD* plugin add to the menu
let g:NERDMenuMode = 0

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Airline settings
map <silent> <leader>al :AirlineToggle<cr>

" vim-colorscheme-switcher: switch colors as following
autocmd VimEnter * :silent! SetColors solarized desert

" vim-color-Solarized: switch background by a Function Key, e.g. F4
call togglebg#map("<F4>")

" =============
" Color Scheme
" =============
if has('syntax')
    if has('gui_running')
        " colorscheme zenburn/Solarized/desert
        colorscheme Solarized
        set background=dark

        " Set default color
        au BufNewFile,BufRead,BufEnter,WinEnter * colo Solarized " zenburn

        " Use different color setting when open different file type
        au BufNewFile,BufRead,BufEnter,WinEnter *.wiki colo desert
    else 
        " Solarized or desert
        colorscheme desert
        set background=dark
    endif

    setlocal synmaxcol=400

    " Open syntax on/highlight
    syntax on
endif

nnoremap <Leader>less :w <BAR> !lessc % > %:t:r.css<CR><space>
" vim: set et sw=4 ts=4 sts=4 fdm=marker ft=vim ff=unix fenc=utf8:
