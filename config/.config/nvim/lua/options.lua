local options = {
	o = {
	-- General
		history					=	10000,

	-- UI
		number					=	true,
		relativenumber			=	true,
		cursorline				=	true,
		-- t_Co					=	256,
		background				=	"dark",
		termguicolors			=	true,
		ruler					=	true,				-- 显示光标位置
		showmode				=	true,
		showcmd					=	true,
		wrap					=	true,				-- 自动折行
		linebreak				=	true,				-- 特殊符号才触发折行
		scrolloff				=	5,					-- 垂直滚动时距离上下边界的距离

	-- Edit
		autoindent				=	true,
		smartindent				=	true,
		cindent					=	true,

		tabstop					=	4,
		shiftwidth				=	4,
		softtabstop				=	4,
		expandtab				=	false,				-- 不要使用空格代替tab
		autochdir				=	false,				-- 不要切换目录, 不然ctags好像不能工作

	-- Matching
		showmatch				=	true,				-- 显示成对匹配符号
		hlsearch				=	true,
		ignorecase				=	true,
		smartcase				=	true,
		incsearch				=	false,				-- 不要每输入一个字符都跳转

	-- Search	
		-- path					=	vim.fn.getcwd() .. "/**,.",	-- 使得find可以递归获取子目录下所有文件
		wildignore				=	"*/__pycache__/*",	-- 指定通配符拓展忽略的模式

	-- Mouse
		mouse					=	"",					-- dafault is 'nvi', bad

	-- Tags
		tags					=	"tags",				-- Deprecated

	-- File
		encoding				=	"utf-8",
		-- fileencoding			=	"utf-8",
		fileencodings			=	"ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1",

	-- Misc
		updatetime				=	300,				-- 更新时间
		foldlevel				=	1000,				-- 设置为大数, 使得自动展开所有等级的folder
	},
	g = {
		python3_host_prog		=	'/usr/bin/python3',	-- 设置nvim-python路径, 保证虚拟环境下也能正常使用
		markdown_folding		=	1,					-- 打开原生Markdown Folder支持
		loaded_perl_provider	=	0,					-- 关闭nvim-perl支持
		-- mapleader				=	"]",
	}
}


for field, list in pairs(options) do
	for key, value in pairs(list) do
		vim[field][key] = value
	end
end


local notify = vim.notify
vim.notify = function(msg, ...)
	if msg:match("vim.lsp.buf_get_clients() is deprecated. Run \":checkhealth vim.deprecated\" for more infor") then
		return
	end
	notify(msg, ...)
end

