return {
	'folke/lazy.nvim',

-- UI
	{
		"ellisonleao/gruvbox.nvim",
		init = function()
			vim.cmd([[colorscheme gruvbox]])
		end
	},

	'Valloric/MatchTagAlways',

	-- 为Rofi提供语法高亮
	'Fymyte/rasi.vim',

	-- 直接显示源码对应的颜色
	'ap/vim-css-color',

	-- .ron高亮
	'ron-rs/ron.vim',

	-- 图片预览
	{
		'adelarsq/image_preview.nvim',
		config = function()
			require("image_preview").setup()
		end
	},

	-- 切换模式时切换输入法
	{
		'lilydjwg/fcitx.vim',
		enabled = function()
			local hostname = vim.api.nvim_call_function('hostname', {})
			return hostname == 'ArchLinux'
		end,
	},

	-- AW计时器
	{
		'ActivityWatch/aw-watcher-vim',
		enabled = function()
			local hostname = vim.api.nvim_call_function('hostname', {})
			return hostname == 'ArchLinux'
		end,
	},

	'nathangrigg/vim-beancount',

	{
		'glacambre/firenvim',
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end
	}


}
