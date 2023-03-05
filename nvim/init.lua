require("plugins")
require("plugins-on")

local options = {
-- General
	history		=	10000,

-- UI
	number		=	true,
	relativenumber	=	true,
	cursorline	=	true,
	t_Co		=	256,
	background	=	"dark",
	termguicolors	=	true,
	ruler		=	true,	-- 显示光标位置
	showmode	=	true,
	showcmd		=	true,
	wrap		=	true,	-- 自动折行
	linebreak	=	true,	-- 特殊符号才触发折行
	scrolloff	=	5,	-- 垂直滚动时距离上下边界的距离


-- Edit
	autoindent	=	true,
	smartindent	=	true,
	cindent		=	true,

	tabstop		=	4,
	shiftwidth	=	4,
	softtabstop	=	4,
	expandtab	=	false,	-- 不要使用空格代替tab
	autochdir	=	true,	-- 自动切换目录

-- Matching
	showmatch	=	true,	-- 显示成对匹配符号
	hlsearch	=	true,
	ignorecase	=	true,
	smartcase	=	true,
	incsearch	=	false,	-- 不要每输入一个字符都跳转

-- Mouse
	mouse		=	"",	-- dafault is 'nvi', bad

-- Tags
	tags		=	"tags",

-- Misc
	encoding	=	"utf-8",
	fileencoding	=	"utf-8",
}

local options_special = {
	"colorscheme gruvbox",
}


for key, value in pairs(options) do
	vim.o[key] = value
end


-- 指定python3路径, 在使用虚拟环境时也能正常使用Vim
vim.g['python3_host_prog'] = '/usr/bin/python3'

for _, value in pairs(options_special) do
	vim.cmd(value)
end

vim.api.nvim_create_autocmd("BufReadPost",{
	command = [[
		if line("'\"") > 0 && line("'\"") <= line("$") |
		exe "normal! g`\"" |
		endif
	]]
})

vim.o["path"] = "."
vim.o["path"] = vim.fn.getcwd() .. "/**," .. vim.o["path"];


-- Quite ugly... Though works well... 后期一定会改进的...
-- https://vi.stackexchange.com/questions/41405/how-to-extract-filename-of-w-command-in-vims-autocmd
vim.cmd([[
	function! CorrectWritePath()
	  if getcmdtype() != ':'
		return "\<CR>"
	  endif

	  if matchstr(getcmdline(), '^w\%[rite]!\?\>') == ''
		return "\<CR>"
	  endif

	  let l:cmdline = getcmdline()

	  " Parse the cmd line
	  let l:newcmdline = l:cmdline
	  let l:good = v:true
	  if matchstr(l:cmdline, ']') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, ']', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '[') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '[', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '`') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '`', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '=') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '=', '\', 'g')
		let l:good = v:false
	  endif

	  if l:good
		return "\<CR>"
	  else
		return "\<C-u>" . l:newcmdline  
	  endif
	endfunction
]])
vim.cmd([[cnoremap <expr> <CR> CorrectWritePath()]])


