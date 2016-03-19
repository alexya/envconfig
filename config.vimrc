" Configuration file for vim
set modelines=0		" CVE-2007-2438

" using pathogen plugin to manage plug-ins
execute pathogen#infect()

" This config is learned from mingcheng
if exists("alexya") 
    finish
endif
let g:alexya = 1

if v:version < 700
    echoerr 'This _vimrc requires Vim 7 or later.'
    quit
endif

" 定义 <Leader> 为逗号
let mapleader = ","
let maplocalleader = ","

" 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" 跳过页头注释，到首行实际代码
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

" 匹配配对的字符
func! MatchingQuotes()
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap " ""<left>
    inoremap ' ''<left>
endf

" 返回当前时期
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endf

" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endf

" From an idea by Michael Naumann
func! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

"Fast reloading of the .vimrc (the following fails to work as 's' will enter
"into INSERT mode)
"map <silent> <leader>ss :source ~/.vimrc<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>


" ============
" Environment
" ============
" 保留历史记录
set history=500
set clipboard=unnamed

" 行控制
set linebreak
set nocompatible
set textwidth=80
set wrap

" 标签页
set tabpagemax=9
set showtabline=2

" 控制台响铃
set noerrorbells
set novisualbell
set t_vb= "close visual bell

" 行号和标尺
set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" 命令行于状态行
set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]
set ls=2 " 始终显示状态行
set wildmenu "命令行补全以增强模式运行

" Search Option
set hlsearch    " Highlight search things
set magic       " Set magic on, for regular expressions
set showmatch   " Show matching bracets when text indicator is over them
set mat=2       " How many tenths of a second to blink
set incsearch
set ignorecase  " ignore lower and uppercase when searching

" 制表符
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" 状态栏显示目前所执行的指令
set showcmd 

" 缩进
set autoindent
set smartindent

" 自动重新读入
set autoread

" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start

" 设定在任何模式下鼠标都可用
set mouse=a

" 自动改变当前目录
if has('netbeans_intg')
    set autochdir
endif

" 备份和缓存
"set nobackup
"set noswapfile

" 自动完成
set complete=.,w,b,k,t,i
set completeopt=longest,menu

" 代码折叠
set foldmethod=marker

" =====================
" 多语言环境
"    默认为 UTF-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    "language messages zh_CN.utf-8

    if has('win32')
        language english
        let &termencoding=&encoding
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" 永久撤销，Vim7.3 新特性
if has('persistent_undo')
    set undofile

    " 设置撤销文件的存放的目录
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
    filetype plugin indent on

    " 括号自动补全
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

    " Auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,javascript exe AutoClose()
    au FileType php,javascript exe MatchingQuotes()

    " Don't write backup file if vim is being called by "crontab -e"
    au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
    " Don't write backup file if vim is being called by "chpass"
    au BufWrite /private/etc/pw.* set nowritebackup nobackup

    " Auto Check Syntax
    au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)

    "When .vimrc is edited, reload it
    au BufWritePost .vimrc source ~/.vimrc 

    " JavaScript 语法高亮
    au FileType html,javascript let g:javascript_enable_domhtmlcss = 1
    au BufRead,BufNewFile *.js setf jquery

    " 给各语言文件添加 Dict
    if has('win32')
        let s:dict_dir = $VIM.'\vimfiles\dict\'
    else
        let s:dict_dir = $HOME."/.vim/dict/"
    endif
    let s:dict_dir = "setlocal dict+=".s:dict_dir

    au FileType php exec s:dict_dir."php_funclist.dict"
    au FileType css exec s:dict_dir."css.dict"
    au FileType javascript exec s:dict_dir."javascript.dict"

    " 格式化 JavaScript 文件
    au FileType javascript map <f12> :call g:Jsbeautify()<cr>
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS

    " 增加 ActionScript 语法支持
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.as setf actionscript 

    " CSS3 语法支持
    au BufRead,BufNewFile *.css set ft=css syntax=css3

    " 增加 Objective-C 语法支持
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.m,*.h setf objc

    " smali syntax supports
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.smali set filetype=smali

    " Ardunio Support
    au BufNewFile,BufRead,BufEnter,WinEnter,FileType *.pde,*.ino set filetype=arduino

    " 将指定文件的换行符转换成 UNIX 格式
    au FileType php,javascript,html,css,python,vim,vimwiki set ff=unix

    " 保存编辑状态
    au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
    au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
endif


" =========
" GUI
" =========
if has('gui_running')
    " 只显示菜单
    set guioptions=mcr

    " 高亮光标所在的行
    set cursorline

    if has("win32")
        " Windows 兼容配置
        source $VIMRUNTIME/mswin.vim

        " f11 最大化
        nmap <f11> :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>
        nmap <Leader>ff :call libcallnr('fullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " 自动最大化窗口
        au GUIEnter * simalt ~x

        " 给 Win32 下的 gVim 窗口设置透明度
        au GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", 250)

        " 字体配置
        exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h10:cANSI'
        if has("multi_byte")
            exec 'set guifontwide='.iconv('Microsoft\ YaHei', &enc, 'gbk').':h10'
        endif
    endif

    " Under Mac
    if has("gui_macvim")
        set anti

        " MacVim 下的字体配置
        set guifont=Monaco:h14
        set guifontwide=Lantinghei\ SC\ Extralight:h14

        " 半透明和窗口大小
        set transparency=5
        set lines=40 columns=120

        " 使用 MacVim 原生的全屏幕功能
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
        " Mac 下，按 <Leader>ff 切换全屏
        nmap <f11> :call FullScreenToggle()<cr>
        nmap <Leader>ff  :call FullScreenToggle()<cr>

        " I like TCSH :^)
        set shell=/bin/tcsh

        " Set input method off
        set imdisable

        " Set QuickTemplatePath
        let g:QuickTemplatePath = $HOME.'/.vim/templates/'

        " 如果为空文件，则自动设置当前目录为桌面
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

" insert mode shortcut
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-d> <Delete>

" 插件快捷键
nmap <C-d> :NERDTree<cr>
nmap <C-e> :BufExplorer<cr>
nmap <f2>  :BufExplorer<cr>

" 插入模式按 F4 插入当前时间
imap <f4> <C-r>=GetDateStamp()<cr>

" 新建 XHTML 、PHP、Javascript 文件的快捷键
nmap <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
nmap <C-c><C-p> :NewQuickTemplateTab php<cr>
nmap <C-c><C-j> :NewQuickTemplateTab javascript<cr>
nmap <C-c><C-c> :NewQuickTemplateTab css<cr>
nmap <C-c><C-r> :NewQuickTemplateTab ruhoh<cr>

" shortcut to show plug-ins window
nmap <Leader>ca :Calendar<cr>
nmap <Leader>mr :MRU<cr>
nmap <Leader>nt :NERDTree<cr>
nmap <Leader>be :BufExplorer<cr>
nmap <Leader>tt :TagbarToggle<cr>

" 直接查看第一行生效的代码
nmap <Leader>gff :call GotoFirstEffectiveLine()<cr>

" 按下 Q 不进入 Ex 模式，而是退出
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

" VIM HTML 插件
let g:no_html_toolbar = 'yes'

" 不要显示 VimWiki 菜单
if has('gui_running')
    let g:vimwiki_menu = ""
endif

" on Windows, default charset is gbk
if has("win32")
    let g:fontsize#encoding = "cp936"
endif

" don't let NERD* plugin add to the menu
let g:NERDMenuMode = 0


" =============
" Color Scheme
" =============
if has('syntax')
    if has('gui_running')
        colorscheme zenburn

        " 默认编辑器配色
        au BufNewFile,BufRead,BufEnter,WinEnter * colo zenburn

        " 各不同类型的文件配色不同
        au BufNewFile,BufRead,BufEnter,WinEnter *.wiki colo lucius
    else 
        set background=dark
        " solarized or desert
        colorscheme desert
    endif

    " 保证语法高亮
    syntax on
endif

nnoremap <Leader>less :w <BAR> !lessc % > %:t:r.css<CR><space>
" vim: set et sw=4 ts=4 sts=4 fdm=marker ft=vim ff=unix fenc=utf8:
