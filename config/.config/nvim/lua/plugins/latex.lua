-- Todo
return {
	{
		'lervag/vimtex',
		ft = 'tex',
		config = function()
			vim.g.tex_flavor = 'latex'
			vim.g.vimtex_texcount_custom_arg= ' -ch -total'
			vim.g.vimtex_compiler_latexmk = {
				['build_dir'] = '',
				['callback'] = 1,
				['continuous'] = 1,
				['executable'] = 'latexmk',
				['options'] = {
					'-verbose',
					'-file-line-error',
					'-synctex=1',
					'-interaction=nonstopmode',
					'-8bit',
					'--shell-escape',
					'-pvc',
				}
			}

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
			-- vim.api.nvim_create_autocmd(
			-- 	"FileType",
			-- 	{
			-- 		pattern = "tex",
			-- 		command = "map <buffer> <silent>  <leader>lw :VimtexCountWords! <CR><CR>"
			-- 	}
			-- )
		end
	},
}
