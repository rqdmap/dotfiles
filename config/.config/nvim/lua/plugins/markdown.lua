-- Todo
return {
	{
		'iamcco/markdown-preview.vim',
		ft = 'markdown',
		config = function()
			vim.g.mkdp_path_to_chrome = 'google-chrome-stable --new-window'
			vim.g.mkdp_auto_close = 0

			local restart = function()
				if vim.fn.exists(':MarkdownPreviewStop') ~= 0 then
					vim.cmd('MarkdownPreviewStop')
				end
				vim.cmd('MarkdownPreview')
			end

			vim.keymap.set('n', '<leader>mm', restart)
		end
	}
}
