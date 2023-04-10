-- Todo
return {
	'iamcco/mathjax-support-for-mkdp',
	{
		'iamcco/markdown-preview.vim',
		keys = "<F9>",
		ft = 'markdown',
		config = function()
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
		end
	}
}
