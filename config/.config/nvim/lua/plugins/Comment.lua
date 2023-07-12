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
		})

		vim.cmd([[nmap <C-_> <Plug>(comment_toggle_linewise_current)]])
		vim.cmd([[xmap <C-_> <Plug>(comment_toggle_linewise_visual)]])

		-- --------------------------------------------
		-- 针对不同的语言可以设置自己想要的注释符号: --
		-- --------------------------------------------
		-- local ft = require('Comment.ft')
		-- ft
		--  -- Set only line comment
		--  .set('yaml', '#%s')
		--  -- Or set both line and block commentstring
		--  .set('javascript', {'//%s', '/*%s*/'})
		--
		-- -- 2. Metatable magic
		--
		-- ft.javascript = {'//%s', '/*%s*/'}
		-- ft.yaml = '#%s'
		--
		-- -- Multiple filetypes
		-- ft({'go', 'rust'}, ft.get('c'))
		-- ft({'toml', 'graphql'}, '#%s')
	end
}
