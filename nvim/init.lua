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

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function()
		vim.cmd(":echo 'Hello, Markdown!'")
		error(vim.fn.expand("%"))
	end
-- 	callback = function()
--     local regex_pattern = "[^=`'/]+"
--     if not vim.fn.expand("%:t"):match(regex_pattern) then
--       local choice = vim.fn.confirm("Do you really want to write to file " .. vim.fn.expand("%:t") .. "?", "&Yes\n&No", 1)
--       if choice == 2 then
--         error("write aborted")
--       end
--     end
--   end
})

