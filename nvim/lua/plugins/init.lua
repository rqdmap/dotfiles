return {
	'folke/lazy.nvim',

-- UI
	{
		'nvim-lualine/lualine.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons'
	},

	"ellisonleao/gruvbox.nvim",

	-- file explorer tree
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = 'nvim-tree/nvim-web-devicons', 
		-- tag = 'nightly' -- optional, updated every week. (see issue #1193)
	},

	-- tagbar
	'majutsushi/tagbar',

	'Valloric/MatchTagAlways',

	-- 为Rofi提供语法高亮
	'Fymyte/rasi.vim',

	-- 直接显示源码对应的颜色
	'ap/vim-css-color',

	-- bufferline
	{'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},

-- Edit
	-- 代码块补全
	-- 'Sirver/ultisnips',
	-- vim.g.UltiSnipsSnippetDirectories={'UltiSnips', os.getenv("HOME")..'/.config/nvim/mySnips'} -- 配置自己补全目录
	-- 'honza/vim-snippets',
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	-- follow latest release.
	-- 	version = "1.*",
	-- 	-- install jsregexp (optional!).
	-- 	build = "make install_jsregexp"
	-- },
		

	-- 切换模式时切换输入法
	'lilydjwg/fcitx.vim',
	-- vim.o.ttimeoutlen=10		-- 直接挂钩响应速度, 但调小后不知道会有什么负面作用

	-- 表格模式
	{
		'dhruvasagar/vim-table-mode',
		keys = {
			"<leader>tm"
		},
		config = function()
			-- 关闭TableMode的默认映射, 其将只保留<leader>tm的映射
			vim.g['table_mode_disable_tableize_mappings'] = 1
		end
	},




	-- 注释
	require("plugins.comment")

-- MISC
	-- -- AW计时器
	-- 'ActivityWatch/aw-watcher-vim'

	-- -- copilot
	-- 'github/copilot.vim'

-- Progr-- amming Languages Support
	-- -- nvim-lspconfig
	-- 'neovim/nvim-lspconfig'
	-- 
	-- -- [C++]
	-- -- 更好的高亮
	-- 'octol/vim-cpp-enhanced-highlight'
	-- -- completion
	-- 'xavierd/clang_complete'
	-- vim.g.clang_use_library=1
	-- vim.g.clang_library_path='/usr/lib/libclang.so'


	-- -- [Rust]
	-- 'simrat39/rust-tools.nvim'
	-- 'rust-lang/rust.vim'


	-- -- [LaTeX]
	-- 'lervag/vimtex'
	-- vim.g.tex_flavor = 'latex'
	-- vim.g.vimtex_texcount_custom_arg= ' -ch -total'
	-- vim.g.vimtex_compiler_latexmk_engines = {
	-- 	['_']                = '-xelatex',
	-- 	['pdflatex']         = '-pdf',
	-- 	['dvipdfex']         = '-pdfdvi',
	-- 	['lualatex']         = '-lualatex',
	-- 	['xelatex']          = '-xelatex',
	-- 	['context (pdftex)'] = '-pdf -pdflatex=texexec',
	-- 	['context (luatex)'] = '-pdf -pdflatex=context',
	-- 	['context (xetex)']  = '-pdf -pdflatex="texexec --xtx"'
	-- }
	-- vim.g.vimtex_quickfix_mode = 0
	-- vim.g.vimtex_view_method = 'zathura'
	-- vim.g.vimtex_view_general_viewer = 'zathura'
	-- vim.api.nvim_create_autocmd(
	-- 	"FileType",
	-- 	{
	-- 		pattern = "tex",
	-- 		command = "map <buffer> <silent>  <leader>lw :VimtexCountWords! <CR><CR>"
	-- 	}
	-- )

	-- -- [Markdown]
	-- 'iamcco/mathjax-support-for-mkdp'
	-- 'iamcco/markdown-preview.vim'
	-- vim.g.mkdp_path_to_chrome = 'google-chrome-stable'
	-- vim.api.nvim_create_autocmd(
	-- 	"FileType",
	-- 	{
	-- 		pattern = "markdown",
	-- 		command = [[
	-- 			nmap <silent> <F9> <Plug>MarkdownPreview
	-- 			imap <silent> <F9> <Plug>MarkdownPreview
	-- 			nmap <silent> <F0> <Plug>StopMarkdownPreview
	-- 			imap <silent> <F0> <Plug>StopMarkdownPreview
	-- 		]]
	-- 	}
	-- )
}
