"--------------------------------------
" enable jump
" CTRL-O, CRTL-I , :jump
"--------------------------------------
"
"man page ==>  K
"man 2 open ==> 2K
"--------------------------------------

set nocompatible
set wrapscan      "stop searching at end of file

"
" Determine what we have
"

let s:OS = 'linux'

let os = substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
    let s:OS = 'osx'
endif

let s:plugins=isdirectory(expand('~/.vim/bundle/vundle', 1))

"
" Setup folder structure
"

if !isdirectory(expand('~/.vim/undo/', 1))
    silent call mkdir(expand('~/.vim/undo', 1), 'p')
endif

if !isdirectory(expand('~/.vim/backup/', 1))
    silent call mkdir(expand('~/.vim/backup', 1), 'p')
endif

if !isdirectory(expand('~/.vim/swap/', 1))
    silent call mkdir(expand('~/.vim/swap', 1), 'p')
endif

"
" Custom Functions
"

" Remove trailing whitespace
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<cr>
        normal `z
        retab
    endif
endfunction

" Function to hide all the text except for the text selected in visual mode.
" This is great for highlighting parts of the code. Just call the function
" again to deselect everything.
function! ToggleSelected(visual) range
    highlight HideSelected ctermfg=bg ctermbg=bg
                         \ guifg=bg guibg=bg gui=none term=none cterm=none

    if exists('g:toggle_selected_hide')
        call matchdelete(g:toggle_selected_hide)

        unlet g:toggle_selected_hide
        redraw

        if !a:visual
            return
        endif
    endif

    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]

    let pattern = '\%^\|\%<'.lnum1.'l\|\%<'.col1.'v\|\%>'.lnum2.'l\|\%>'.col2.'v'
    let g:toggle_selected_hide = matchadd('HideSelected', pattern, 1000)

    redraw
endfunction

" Check if a colorscheme exists
" http://stackoverflow.com/a/5703164
function! HasColorScheme(scheme)
    let basepath = '~/.vim/bundle/'

    for plug in g:color_schemes
        let path = basepath . '/' . plug . '/colors/' . a:scheme . '.vim'
        if filereadable(expand(path))
            return 1
        endif
    endfor

    return 0
endfunction

nnoremap <space><space> :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

"
" Global Settings
"

" The default 20 isn't nearly enough
set history=9999

" Show the numbers on the left of the screen
set number

" Show the column/row
set ruler

" Highlight only the lines that go past 80 characters
highlight ColorColumn ctermbg=green guibg=green
call matchadd('ColorColumn', '\%82v', 100)

" Pretty colors are fun, yayyy
syntax on

" Show the matching when doing a search
set showmatch

" Allows the backspace to delete indenting, end of lines, and over the start
" of insert
set backspace=indent,eol,start

" Ignore case when doing a search as well as highlight it as it is typed
set ignorecase smartcase
set hlsearch " display searching character
set incsearch

" Don't show the startup message
set shortmess=I

" Show the current command at the bottom
set showcmd

" Disable beeping and flashing.
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Use smarter defaults
set smartindent
set smarttab

" Use autoindenting
set autoindent

" The tabstop look best at 4 spacing
set tabstop=4
set softtabstop=4
set shiftwidth=4

" I have been converted to the dark side, I will use spaces to indent code
" from here on out
set expandtab

" Buffer Settings
set hidden

" Better completion
set completeopt+=longest,menuone,preview

" Turn on persistent undo
" Thanks, Mr Wadsten: github.com/mikewadsten/dotfiles/
if has('persistent_undo')
    set undodir=~/.vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" Use backups
" Source:
"   http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim/backup//

" Use a specified swap folder
" Source:
"   http://stackoverflow.com/a/15317146
set directory=~/.vim/swap//

" The comma makes a great leader of men, heh heh
let mapleader = ','
let maplocalleader = '\'

" Show two lines for the status line
set laststatus=2

" Always show the last line
set display+=lastline

" UTF-8 THIS SHITTTTTT
set encoding=utf-8

" Enhanced mode for command-line completion
set wildmenu

" Automatically re-read the file if it has changed
set autoread

" Fold Settings

" Off on start
set nofoldenable

" Indent seems to work the best
set foldmethod=indent
set foldlevel=20

"
" Global Bindings
"

" VimFiler -> Editer
map <S-Tab> <esc><C-W>h

" Disable ex mode, ick, remap it to Q instead.
"
" Tip:
"   Use command-line-window with q:
"   Use search history with q/
"
" More info:
" http://blog.sanctum.geek.nz/vim-command-window/
nmap Q q

" Show only selected in Visual Mode
nmap <silent> <leader>th :cal ToggleSelected(0)<cr>
vmap <silent> <leader>th :cal ToggleSelected(1)<cr>

" Split the window using some nice shortcuts
nmap <leader>s<bar> :vsplit<cr>
nmap <leader>s- :split<cr>
nmap <leader>s? :map <leader>s<cr>

" Unhighlight the last search pattern on Enter
nn <silent> <cr> :nohlsearch<cr><cr>

" Control enhancements in insert mode
imap <C-F> <right>
imap <C-B> <left>
imap <M-BS> <esc>vBc
imap <C-P> <up>
imap <C-N> <down>

" Non quitting analog of ZZ
nmap zz :w<cr>

" When pushing j/k on a line that is wrapped, it navigates to the same line,
" just to the expected location rather than to the next line
nnoremap j gj
nnoremap k gk

" Use actually useful arrow keys
map <right> :bn<cr>
map <left> :bp<cr>
map <up> <nop>
map <down> <nop>

" Map Ctrl+V to paste in Insert mode
imap <C-V> <C-R>*

" Map Ctrl+C to copy in Visual mode
vmap <C-C> "+y

" Add paste shortcut
nmap <leader>P "+p

" GVim Settings
if has('gui_running')
    " Who uses a GUI in GVim anyways? Let's be serious.
    set guioptions=egirLt

    " Ensure that clipboard isn't clobbered when yanking
    set guioptions-=a

    " Let's make the fonts look nice
    if s:OS == 'osx'
        set guifont=Droid\ Sans\ Mono\ for\ Powerline:h11
    elseif s:OS == 'linux'
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
    endif
endif

" Ignore some defaults
set wildignore=*.o,*.obj,*~,*.pyc
set wildignore+=.env
set wildignore+=.env[0-9]+
set wildignore+=.git,.gitkeep
set wildignore+=.tmp
set wildignore+=.coverage
set wildignore+=*DS_Store*
set wildignore+=.sass-cache/
set wildignore+=__pycache__/
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=.tox/**
set wildignore+=.idea/**
set wildignore+=*.egg,*.egg-info
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

" Fold Keybindings
"nnoremap <space> za

"
" Custom Settings
"

" Set on textwidth when in markdown files
autocmd FileType markdown set textwidth=80

" Smarter completion in C
autocmd FileType c set omnifunc=ccomplete#Complete

" My own special flavoring to running programs
autocmd FileType asm,c,objc,scheme,sh,python,perl,javascript nn <leader>R :!deepThought.sh '%:p'<cr>

" Use 2 spaces when in Lua & Ruby
autocmd FileType lua,ruby set tabstop=2
autocmd FileType lua,ruby set shiftwidth=2

if !s:plugins

" Bootstrap Vundle on new systems
" Borrowed from @justinmk's vimrc
fun! InstallVundle()
    silent call mkdir(expand('~/.vim/bundle', 1), 'p')
    silent !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
endfun

" Instead of install packages, install Vundle
nmap <leader>vi :call InstallVundle()<cr>

else

" Required by Vundle
filetype off

" Vundle is the new god among plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"
" Vundle Bundles + Settings
"

Plugin 'gmarik/vundle'

" Git/GitHub plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

" File overview
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler.vim'

" Navigation
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'mileszs/ack.vim'

" Appearance
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bitc/vim-bad-whitespace'

" Buffers
Plugin 'jeetsukumaran/vim-buffergator'

" Syntax
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-markdown'

" Utilities
Plugin 'Lokaltog/vim-easymotion'
Plugin 'takac/vim-commandcaps'
Plugin 'mbbill/undotree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'benmills/vimux'
Plugin 'vim-scripts/SyntaxRange'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-repeat'

" Vim improvements
Plugin 'embear/vim-localvimrc'

" R Lang
"Plugin 'jalvesaq/VimCom'
"Plugin 'jcfaria/Vim-R-plugin'
"Plugin 'LaTeX-Box-Team/LaTeX-Box'

" Autocompletion
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-surround'
Plugin 'Valloric/YouCompleteMe'

" Snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Ruby plugins
"Plugin 'vim-ruby/vim-ruby'
"Plugin 'tpope/vim-cucumber'
"Plugin 'tpope/vim-bundler'

" Elixir plugins
Plugin 'elixir-lang/vim-elixir'

" Themes
Plugin 'freeo/vim-kalisi'
Plugin 'flazz/vim-colorschemes'

" Python
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'nvie/vim-flake8'

" color
Plugin 'reewr/vim-monokai-phoenix'

" Go Lang
Plugin 'fatih/vim-go'

let g:color_schemes = ['vim-kalisi', 'vim-colorschemes', 'vim-monokai-phoenix']

nmap <leader>t? :map <leader>t<cr>
nmap <leader>tB :VimFiler<cr>
nmap <leader>tW :cal StripTrailingWhitespace()<cr>
nmap <leader>tb :VimFilerExplorer<cr>
nmap <leader>tt :TagbarToggle<cr>
nmap <leader>tu :UndotreeToggle<cr>
nmap <leader>tw :cal ToggleWhitespace()<cr>

" Vundle mapping
nmap <leader>vl :BundleList<cr>
nmap <leader>vi :BundleInstall<cr>
nmap <leader>vI :BundleInstall!<cr>
nmap <leader>vc :BundleClean<cr>
nmap <leader>vC :BundleClean!<cr>
nmap <leader>v? :map <leader>v <cr>

" Fugitive mapping
nmap <leader>gb :Gblame<cr>
"nmap <leader>gc :Gcommit<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gg :Ggrep
nmap <leader>gl :Glog<cr>
"nmap <leader>gp :Git pull<cr>
"nmap <leader>gP :Git push<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gw :Gbrowse<cr>
nmap <leader>g? :map <leader>g<cr>

" hangul
map ㅡ m
map ㅜ n
map ㅠ b
map ㅍ v
map ㅊ c
map ㅌ x
map ㅋ z
map ㅣ l
map ㅏ k
map ㅓ j
map ㅗ h
map ㅎ g
map ㄹ f
map ㅇ d
map ㄴ s
map ㅁ a
map ㅔ p
map ㅐ o
map ㅑ i
map ㅕ u
map ㅛ y
map ㅅ t
map ㄱ r
map ㄷ e
map ㅈ w
map ㅂ q


" VimFiler options
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = [
        \ '^\.git$',
        \ '^\.cache$',
        \ '^__pycache__$',
        \ '^\.DS_Store$',
        \ '\.aux$',
        \ '\.sw[po]$',
        \ '\.class$',
        \ '\.py[co]$',
        \ '\.py[co]$',
    \ ]

autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif

call vimfiler#custom#profile('default', 'context', {
            \ 'explorer' : 1,
            \ 'safe' : 0,
            \ })


" Automatically open VimFiler whenever opened with GUI, but not terminal
if has('gui_running')
    autocmd VimEnter * VimFilerExplorer
    "autocmd VimEnter * wincmd p
endif

" Syntastic Settings
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_auto_loc_list = 2
let g:syntastic_enable_signs = 1
let g:syntastic_java_checkers = ['checkstyle', 'javac']
let g:syntastic_java_javac_delete_output = 1
let g:syntastic_java_checkstyle_conf_file = '~/bin/jars/sun_checks.xml'
let g:syntastic_java_checkstyle_classpath = '~/bin/jars/checkstyle-5.5-all.jar'
let g:syntastic_filetype_map = { 'rnoweb': 'tex'}

" UltiSnip options
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-SPACE>"
"let g:UltiSnipsExpandTrigger="<Enter>"


" CtrlP Settings

let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files --exclude-standard --others --cached'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
            \ }

" Use nearest .git dir
let g:ctrlp_working_path_mode = 'ra'

nmap <leader>p :CtrlP<cr>

" Buffer controls to go with Buffergator
nmap <leader>b? :map <leader>b<cr>
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bl :BuffergatorOpen<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bq :bp <BAR> bd #<cr>
nmap <leader>bs :CtrlPMRU<cr>

" Airline options
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'kalisi'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Whitespace settings

" Show trailing whitespace and tabs obnoxiously
"set list listchars=tab:▸\ ,trail:.
"set list

fun! ToggleWhitespace()
    ToggleBadWhitespace
    if &list
        set nolist
    else
        set list listchars=tab:▸\ ,trail:.
        set list
    endif
endfun

" Easymotion
map <space>l <Plug>(easymotion-lineforward)

let g:EasyMotion_smartcase = 1
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)
map <space>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0

" Tagbar Options
let g:tagbar_left = 0
let g:tagbar_width = 30

" Elixir + ctags + Tagbar
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records'
    \ ]
\ }


" Ack options
nmap <leader>/ :Ack!<space>
let g:ackpreview = 2
let g:ackhighlight = 1

" Undotree settings
let g:undotree_SplitWidth = 30
let g:undotree_WindowLayout = 3

" Multiple Cursors Settings
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = '<C-j>'
let g:multi_cursor_prev_key = '<C-k>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<Esc>'

" Worthless mapping
let g:vimrplugin_assign = 0

" Disable ridiculous mappings
let g:vimrplugin_insert_mode_cmds = 0

" The powers of Gitignore + wildignore combine!
" Originally written by @zdwolfe, updated by @mikewadsten
"Bundle 'mikewadsten/vim-gitwildignore'

" LaTex-Box Settings
let g:LatexBox_latexmk_async = 1
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_viewer = 'open -a Skim.app'
let g:LatexBox_viewer = 'mate-open'

"
" Buffergator Options
"

let g:buffergator_suppress_keymaps = 1
let g:buffergator_viewport_split_policy = "R"
let g:buffergator_autoexpand_on_split = 0

" Looper!
"let g:buffergator_mru_cycle_loop = 1

nmap <leader>T :enew<cr>
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
nmap <leader>kk :BuffergatorMruCycleNext<cr>

" Use extra conf file
"let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0 "DEFAULT 1

" Ignore certain filetypes
let g:ycm_filetype_blacklist = {
\ 'tagbar': 1,
\ 'qf': 1,
\ 'notes': 1,
\ 'markdown': 1,
\ 'unite': 1,
\ 'text': 1,
\ 'vimwiki': 1,
\ 'pandoc': 1,
\ 'infolog': 1,
\ 'mail': 1,
\ 'gitcommit': 1,
\}

"
" CScope bindings
"
" Cheat Sheet:
"
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls

if has("cscope")
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose

    nmap <leader>c? :ec 'Cscope reference'                       <bar> map <leader>c<cr>
    nmap <leader>cc :ec 'Find all calls to function'             <bar> cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cd :ec 'Find functions that call this function' <bar> cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ce :ec 'egrep search for the word under cursor' <bar> cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cf :ec 'Open filename under cursor'             <bar> cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>cg :ec 'Find all global definitions'            <bar> cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ci :ec 'Find files that include the filename'   <bar> cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <leader>cs :ec 'Find all references'                    <bar> cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ct :ec 'Find all instances to text'             <bar> cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cm :ec 'Cscope Make'                            <bar> exec "!mkcscope.sh start" <CR><CR>
endif

"
" Vimux Settings
"

if has('gui_running')
    let g:VimuxUseNearest = 1
    let g:VimuxRunnerType = 'window'
else
    let g:VimuxUseNearest = 0
    let g:VimuxRunnerType = 'pane'
endif

let g:VimuxPromptString = 'tmux > '

function! VimuxSetupRacket()
    call VimuxRunCommand('racket -il readline')
    call VimuxClearRunnerHistory()
endfunction

function! VimuxQuitRacket()
    call VimuxInterruptRunner()
    call VimuxCloseRunner()
endfunction

function! VimuxRunSelection() range
    let [lnum1, col1] = getpos(''<')[1:2]
    let [lnum2, col2] = getpos(''>')[1:2]

    let lines = getline(lnum1, lnum2)

    let lines[-1] = lines[-1][: col2 - 1]
    let lines[0] = lines[0][col1 - 1:]

    call VimuxRunCommand(join(lines, "\n"))
endfunction

function! VimuxRunLine()
    call VimuxRunCommand(getline('.'))
endfunction

function! VimuxRunParagraph()
    let [lnum1] = getpos("'{")[1:1]
    let [lnum2] = getpos("'}")[1:1]

    let lines = getline(lnum1, lnum2)
    let filtered = filter(lines, 'v:val !~ "^\s*;"')

    call VimuxRunCommand(join(filtered, ''))
endfunction

" Setup autocmd if Racket filetype
autocmd FileType racket call SetupVimuxRacket()

function! SetupVimuxRacket()
    set shiftwidth=2

    " Start interpretter
    nmap <silent> <localleader>ri :call VimuxSetupRacket()<cr>
    nmap <silent> <localleader>rq :call VimuxQuitRacket()<cr>
    nmap <silent> <localleader>rl :call VimuxRunLine()<cr>
    nmap <silent> <localleader>R :call VimuxRunParagraph()<cr> nmap <silent> <localleader>rp :call VimuxRunParagraph()<cr>
    vmap <silent> <localleader>R :call VimuxRunSelection()<cr>
endfunction

" End the conditional for plugins
endif

" Load plugins and indent for the filtype
" **Must be last for Vundle**
filetype plugin indent on

"
" Misc/Non Plugin Settings
"

" Paste toggle to something easy
set pastetoggle=<leader>tP

" Bind :sort to something easy, don't press enter, allow for options (eg -u,
" n, sorting in reverse [sort!])
vnoremap <leader>s :sort


function! s:MyC()
 set number
 set ts=2
 set sw=2
 set tw=0
 let c_gnu=1     " __FUNCTION__
 syn keyword cType  typeof
 set expandtab  "
 map <buffer> = :pyf /usr/local/llvm38/share/clang/clang-format.py<cr>
endfun

func! Engdic()
 let ske=expand("<cword>")
 exec "!lynx -nolist -verbose -dump -display_charset=utf-8 \" http://endic.naver.com/popManager.nhn?sLn=kr&m=search&query=".ske"\" | less "
endfunc

map <silent> ,ed :call Engdic()<cr>

au BufNewFile,BufRead *.pc,*.c,*.cc,*.h,*.hh,*.cpp call s:MyC()
command! -nargs=? MyC call s:MyC()

let &titlestring = $USER . "@" . hostname() . " " . expand("%:p")
let &titleold=$USER . "@" . hostname()

" save previous cursor position
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif
endif " has("autocmd")

" Must be loaded after all color scheme plugins
if HasColorScheme('kalisi') && s:plugins
    colorscheme kalisi
endif

if HasColorScheme('monokai-phoenix') && s:plugins
    colorscheme monokai-phoenix
endif

" Let's make it pretty
"set background=dark
"set background=light
set t_Co=256
set t_AB=[48;5;%dm
set t_AF=[38;5;%dm

colorscheme ron
"colorscheme monokai-phoenix
"colorscheme google
"colorscheme badwolf

" cscope 연동
"set csprg=/usr/local/bin/cscope
if s:OS == 'osx'
    set csprg=/opt/pkg/bin/cscope
elseif s:OS == 'linux'
    set csprg=/bin/cscope
endif

set csto=0
set cst
set nocsverb

" 특정디렉토리일때 원하는 tag 참조 방법은?
" 참조 디렉토리가 여러개일수 있도록 수정

let $CUR_PATH=$PWD
" 특정 경로일때 다른 위치의 cscope,tags 경로를 설정할때 사용
" Key로 특정 경로를 , 원하는 위치의 cscope,tags 경로를 배열로 저장

let cscope_tag_list = {
	\ 'kraken/cmd/blackpeal' : ['kraken/pkg'],
	\ 'kraken/cmd/vrouter' : ['kraken/pkg'],
	\ 'kraken.dev/cmd/blackpeal' : ['kraken.dev/pkg'],
	\ 'kraken.dev/cmd/vrouter' : ['kraken.dev/pkg'],
	\ 'tw-manager/esm_manager' : ['tw-manager/esm_icorba', 'tw-manager/esm_interface', 'tw-manager/esm_iutil'],
	\ 'pius' : ['thrift'],
	\ }

for key in keys(cscope_tag_list)

	" 현재패스의 tags 설정
	"let $full_path_name = join([$CUR_PATH, "/tags"],"")
	"if filereadable($full_path_name)
	"	let $TAGS=$full_path_name
	"endif

	"echo "1) " $CUR_PATH key

	" 동일한 경로가 포함되지 않으면 continue;
	if match($CUR_PATH, key) == -1 
		cont
	endif

	" key가 시작하는 위치
	let sindex=strridx($CUR_PATH, key)
	" key가 끝나는 위치
	let eindex=sindex + strlen(key)

	" 현재PATH와 Key의 종료 위치가 같지 않다면 Key종료 위치의 cscope 설정
	if strlen($CUR_PATH) != eindex
		let $full_path_name = join([strpart($CUR_PATH, 0, eindex), "/cscope.out"],"")
		if filereadable($full_path_name)
			"echo "2) " $full_path_name 
			"echo "Parents directory found cscope.out."
			cs add $full_path_name

	        "set tags+=$full_path_name/$TAGS
		endif

		let $full_path_name = join([strpart($CUR_PATH, 0, eindex), "/tags"],"")
		if filereadable($full_path_name)
	        set tags+=$full_path_name
			echo $TAGS
		endif
	endif

	" substring 현재경로에서 KEY의 시작위치
	let path1=strpart($CUR_PATH, 0, sindex)

	" 추가로 연관된 경로의 소스 CSCOPE 연동
	for path2 in cscope_tag_list[key]
		"echo "3) " path1 path2
		" $full_path_name는 $표시가 없으면 cs add실행되지 않음
		let $full_path_name = join([path1, path2, "/cscope.out"],"")

		" 원하는 패스의 cscope가 있으면 설정
		if filereadable($full_path_name)
			"echo "4) " $full_path_name
			"echo "Relation directory found cscope.out."
			cs add $full_path_name
	        "set tags+=$full_path_name/$TAGS
		else
			"echo "4) Not Found cscope.out! (" path2 ")."
		endif

		" 원하는 패스의 tags가 있으면 설정
		let $full_path_name = join([path1, path2, "/tags"],"")
		if filereadable($full_path_name)
	        set tags+=$full_path_name
			echo $TAGS
		"else
			"echo "Not Found tags! (" path2 ")."
		endif
	endfor

endfor

cs add $GOROOT/src/cscope.out
cs add $GOPATH/src/cscope.out

"set tags +=./tags
"set tags +=../tags
set tags +=$GOPATH/src/tags
set tags +=$GOROOT/src/tags

" find files using key 'gf'
set path +=.,./include,../include,../../include,../../../include
set path +=/usr/include;e
set path +=/usr/local/include

" Mouse
set mouse=a

" for Golang
set updatetime=100

" 저장할 때 자동으로 formatting 및 import
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_addtags_transform = "camelcase"

let g:go_autodetect_gopath = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_operators = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_test_timeout = '10s'

" quickfix 이동 및 open/close
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>
nnoremap <LocalLeader>q :call ToggleQuickfixList()<CR>

" 테스트 커버리지 검사 및 색깔 표시 토글
nnoremap <LocalLeader>c :GoCoverageToggle<CR>

" 자주 쓰는 기능들
autocmd FileType go nnoremap <Tab>b :GoBuild<CR>
autocmd FileType go nnoremap <Tab>r :GoRun<CR>
autocmd FileType go nnoremap <Tab><Tab>r :GoRun %<CR>

autocmd FileType go nnoremap <Tab>t :GoTest<CR>
autocmd FileType go nnoremap <Tab><Tab>t :GoTestFunc<CR>
autocmd FileType go nnoremap <Tab>c :GoCoverageToggle<CR>

" go language
let s:tlist_def_go_settings = 'go;g:enum;s:struct;u:union;t:type;' .
                           \ 'v:variable;f:function'

" enable auto lint test at save
"let g:go_metalinter_autosave = 1
" disable default linters
"let g:go_metalinter_autosave_enabled = []
