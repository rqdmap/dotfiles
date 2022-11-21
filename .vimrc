" --------------------------------------------------------------------
" General
" --------------------------------------------------------------------
set history=500		" 历史记录条数
set number		" 显示行号

" --------------------------------------------------------------------
" Colors
" --------------------------------------------------------------------
syntax on		" 语法高亮
set cursorline		" 光标所在行高亮
set t_Co=256		" 启用256色
set background=dark
" colorscheme gruvbox

" --------------------------------------------------------------------
" Vim UI
" --------------------------------------------------------------------
set ruler 		" 在状态栏显示光标位置
set showmode		" 在底部显示当前处于的模式
set showcmd		" 在底部显示键入的指令
set wrap		" 自动折行
set linebreak		" 特点符号(如空格等)才触发折行
set scrolloff=5		" 垂直滚动时, 光标距离顶部/底部的距离
set tw=80
set formatoptions=tcqmM

" --------------------------------------------------------------------
" Encoding
" --------------------------------------------------------------------
set encoding=utf-8	" 编码格式
set fileencoding=utf-8

" --------------------------------------------------------------------
" Layout
" --------------------------------------------------------------------
set autoindent		" 按下回车后,缩进与上一行一致
set smartindent		" 为 C 程序提供自动缩进
set cindent		" C 风格缩进

set tabstop=8		" Tab显示的空格数
set shiftwidth=8	" 每一级缩进的空格数
set softtabstop=8	" 统一缩进
set noexpandtab		" 不要使用空格代替Tab


" --------------------------------------------------------------------
" Matching
" --------------------------------------------------------------------
set showmatch 		" 显示成对匹配符号
set hlsearch		" 不要高亮搜索结果
set ignorecase		" 忽视大小写
set smartcase		" 智能大小写敏感


" --------------------------------------------------------------------
" Edit
" --------------------------------------------------------------------
set autochdir		" 自动切换工作目录

" 保存上次光标所在的位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" --------------------------------------------------------------------
" Tags
" --------------------------------------------------------------------
set tags=tags;

" --------------------------------------------------------------------
" Required by fcitx.vim plugin
" --------------------------------------------------------------------
set ttimeoutlen=10

" --------------------------------------------------------------------
" Plugins
" --------------------------------------------------------------------
call plug#begin()


Plug 'lervag/vimtex'
let g:tex_flavor = 'latex'
let g:vimtex_texcount_custom_arg=' -ch -total'
" "映射VimtexCountWords！\lw 在命令模式下enter此命令可统计中英文字符的个数
au FileType tex map <buffer> <silent>  <leader>lw :VimtexCountWords!  <CR><CR>

"这里是LaTeX编译引擎的设置，这里默认LaTeX编译方式为-xelatex,
"vimtex提供了magic comments来为文件设置编译方式
"例如，我在tex文件开头输入 % !TEX program = xelatex   即指定-xelatex （xelatex）编译文件
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \ 'pdflatex'         : '-pdf',
    \ 'dvipdfex'         : '-pdfdvi',
    \ 'lualatex'         : '-lualatex',
    \ 'xelatex'          : '-xelatex',
    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
    \ 'context (luatex)' : '-pdf -pdflatex=context',
    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
    \}

let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'


" 代码块补全
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


" 存储&恢复插入模式的输入模式, 进入普通模式后切换到英文
Plug 'lilydjwg/fcitx.vim'

Plug 'Fymyte/rasi.vim'


Plug 'ap/vim-css-color'

Plug 'rkulla/pydiction'
" filetype plugin on
let g:pydiction_location = '/home/rqdmap/.vim/plugged/pydiction/complete-dict'
let g:pydiction_menu_height = 8

Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'
nmap <silent> <F8> <Plug>MarkdownPreview        " for normal mode
imap <silent> <F8> <Plug>MarkdownPreview        " for insert mode
nmap <silent> <F9> <Plug>StopMarkdownPreview    " for normal mode
imap <silent> <F9> <Plug>StopMarkdownPreview    " for insert mode
let g:mkdp_path_to_chrome = "google-chrome-stable"

call plug#end()

" --------------------------------------------------------------------
" Autocmds
" --------------------------------------------------------------------
"
" 自动运行 polybar_run 预览, 调试用
" autocmd	BufWritePost config.ini !polybar_run
" autocmd	BufWritePost .Xresources !xrdb %

