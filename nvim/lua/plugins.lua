-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
-- Packer can manage itself
	use 'wbthomason/packer.nvim'

-- UI
	use 'nvim-tree/nvim-web-devicons'

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}


	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional, for file icons
		},
		-- tag = 'nightly' -- optional, updated every week. (see issue #1193)
	}


-- Edit
	-- 代码块补全
	use 'Sirver/ultisnips'
	use 'honza/vim-snippets'
	vim.g.UltiSnipsSnippetDirectories={'UltiSnips', os.getenv("HOME")..'/.config/nvim/mySnips'} -- 配置自己补全目录

	-- 切换模式时切换输入法
	use 'lilydjwg/fcitx.vim'
	vim.o.ttimeoutlen=10		-- 直接挂钩响应速度, 但调小后不知道会有什么负面作用

	-- 为Rofi提供语法高亮
	use 'Fymyte/rasi.vim'

	-- 直接显示源码对应的颜色
	use 'ap/vim-css-color'

-- MISC
	use 'Valloric/MatchTagAlways'



-- Programming Languages Support
	-- [C++]
	-- 更好的高亮
	use 'octol/vim-cpp-enhanced-highlight'
	-- completion
	use 'xavierd/clang_complete'
	vim.g.clang_use_library=1
	vim.g.clang_library_path='/usr/lib/libclang.so'


	-- [LaTeX]
	use 'lervag/vimtex'
	vim.g.tex_flavor = 'latex'
	vim.g.vimtex_texcount_custom_arg= ' -ch -total'
	vim.g.vimtex_compiler_latexmk_engines = {
		['_']                = '-xelatex',
		['pdflatex']         = '-pdf',
		['dvipdfex']         = '-pdfdvi',
		['lualatex']         = '-lualatex',
		['xelatex']          = '-xelatex',
		['context (pdftex)'] = '-pdf -pdflatex=texexec',
		['context (luatex)'] = '-pdf -pdflatex=context',
		['context (xetex)']  = '-pdf -pdflatex="texexec --xtx"'
	}
	vim.g.vimtex_quickfix_mode = 0
	vim.g.vimtex_view_method = 'zathura'
	vim.g.vimtex_view_general_viewer = 'zathura'
	vim.api.nvim_create_autocmd(
		"FileType",
		{
			pattern = "tex",
			command = "map <buffer> <silent>  <leader>lw :VimtexCountWords! <CR><CR>"
		}
	)

	-- [Markdown]
	use 'iamcco/mathjax-support-for-mkdp'
	use 'iamcco/markdown-preview.vim'
	vim.g.mkdp_path_to_chrome = 'google-chrome-stable'
	vim.api.nvim_create_autocmd(
		"FileType",
		{
			pattern = "markdown",
			command = [[
				nmap <silent> <F9> <Plug>MarkdownPreview
				imap <silent> <F9> <Plug>MarkdownPreview
				nmap <silent> <F0> <Plug>StopMarkdownPreview
				imap <silent> <F0> <Plug>StopMarkdownPreview
			]]
		}
	)

end)

