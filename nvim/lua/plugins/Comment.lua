return {
	'numToStr/Comment.nvim',
	keys = {
		{"<C-_>", "<Plug>(comment_toggle_linewise_current)", mode = "n"},
		{"<C-_>", "<Plug>(comment_toggle_linewise_visual)", mode = "x"}
	},
	config = function()
		require("Comment").setup({
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			---Lines to be ignored while (un)comment
			ignore = nil,
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = false,
			---Function to call before (un)comment
			pre_hook = nil,
			---Function to call after (un)comment
			post_hook = nil,
		})
		vim.cmd([[nmap <C-_> <Plug>(comment_toggle_linewise_current)]])
		vim.cmd([[xmap <C-_> <Plug>(comment_toggle_linewise_visual)]])

		-- 为当前buffer设置默认注释字符串的格式
		-- https://github.com/numToStr/Comment.nvim#%EF%B8%8F-filetypes--languages
		vim.bo.commentstring = '#%s'
	end
}
