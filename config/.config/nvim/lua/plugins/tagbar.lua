-- deprecated
return {
	'majutsushi/tagbar',
	version = 'v3.0.0',
	enabled = false,
	init = function()
		-- Tagbar相关配置
		vim.cmd([[nnoremap <silent> <Leader>tt :TagbarToggle<CR>]])
		vim.g['tagbar_position'] = 'leftabove vertical'
		vim.g['tagbar_width'] = 30
		vim.g['tagbar_autofocus'] = 0
		vim.g['tagbar_sort'] = 0
		vim.g['tagbar_compact'] = 1
		-- vim.g['tagbar_show_tag_linenumbers'] = 3
		vim.g['tagbar_indent'] = 1
	end
}

