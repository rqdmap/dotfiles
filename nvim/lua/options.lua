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
	autochdir	=	false,	-- 不要切换目录, 不然ctags好像不能工作

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
	updatetime	=	500,	-- 更新时间
}

for key, value in pairs(options) do
	vim.o[key] = value
end



-- 指定python3路径, 在使用虚拟环境时也能正常使用Vim
vim.g['python3_host_prog'] = '/usr/bin/python3'

vim.o["path"] = "."
vim.o["path"] = vim.fn.getcwd() .. "/**," .. vim.o["path"];

-- 移除一些文件夹
vim.o["wildignore"] = "*/__pycache__/*"


-- 打开原生Markdown折叠支持
vim.g['markdown_folding'] = 1
-- 默认不折叠
vim.o['foldlevel'] = 1000
