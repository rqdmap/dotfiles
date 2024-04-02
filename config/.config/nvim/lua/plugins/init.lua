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
	require("plugins.symbols-outline"),

	'Valloric/MatchTagAlways',

	-- 为Rofi提供语法高亮
	'Fymyte/rasi.vim',

	-- 直接显示源码对应的颜色
	'ap/vim-css-color',

	-- bufferline
	require("plugins.bufferline"),

	-- .ron高亮
	'ron-rs/ron.vim',

	-- 图片预览
	{
		'adelarsq/image_preview.nvim',
		config = function()
			require("image_preview").setup()
		end
	},

-- Edit
	-- 代码块补全
	require("plugins.luasnip"),

	-- 自动补全
	require("plugins.nvim-cmp"),

	-- 切换模式时切换输入法
	{
		'lilydjwg/fcitx.vim',
		enabled = function()
			local hostname = vim.api.nvim_call_function('hostname', {})
			return hostname == 'ArchLinux'
		end,
	},

	-- 表格模式
	require("plugins.vim-table-mode"),

	-- 注释
	require("plugins.Comment"),

-- Search
	require("plugins.telescope"),

-- MISC
	-- AW计时器
	{
		'ActivityWatch/aw-watcher-vim',
		enabled = function()
			local hostname = vim.api.nvim_call_function('hostname', {})
			return hostname == 'ArchLinux'
		end,
	},

	require("plugins.copilot"),

	'nathangrigg/vim-beancount',

-- Programming Languages Support
	-- nvim-lspconfig
	require("plugins.lsp"),

	require("plugins.cpp"),
	require("plugins.rust"),
	require("plugins.latex"),
	require("plugins.markdown"),
}
