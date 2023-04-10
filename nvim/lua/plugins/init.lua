return {
	'folke/lazy.nvim',

-- UI
	require("plugins.nvim-web-devicons"),

	require("plugins.lualine"),

	{
		"ellisonleao/gruvbox.nvim",
		init = function()
			vim.cmd([[colorscheme gruvbox]])
		end
	},

	-- file explorer tree
	require("plugins.nvim-tree"),

	-- tagbar
	require("plugins.tagbar"),

	'Valloric/MatchTagAlways',

	-- 为Rofi提供语法高亮
	'Fymyte/rasi.vim',

	-- 直接显示源码对应的颜色
	'ap/vim-css-color',

	-- bufferline
	require("plugins.bufferline"),

-- Edit
	-- 代码块补全
	require("plugins.snippets"),

	-- 切换模式时切换输入法
	'lilydjwg/fcitx.vim',

	-- 表格模式
	require("plugins.vim-table-mode"),

	-- 注释
	require("plugins.Comment"),

-- MISC
	-- AW计时器
	'ActivityWatch/aw-watcher-vim',

	require("plugins.copilot"),

-- Programming Languages Support
	-- nvim-lspconfig
	require("plugins.lsp"),

	require("plugins.cpp"),
	require("plugins.rust"),
	require("plugins.latex"),
	require("plugins.markdown"),
}
