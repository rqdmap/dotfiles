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

-- Edit

	-- 切换模式时切换输入法
	'lilydjwg/fcitx.vim',
	'rlue/vim-barbaric',

-- MISC
	-- AW计时器
	{
		'ActivityWatch/aw-watcher-vim',
	},


	'nathangrigg/vim-beancount',
}
