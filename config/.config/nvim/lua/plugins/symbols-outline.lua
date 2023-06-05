return {
	'rqdmap/symbols-outline.nvim',
	-- 'simrat39/symbols-outline.nvim',

	dependencies = {
		'neovim/nvim-lspconfig',
	},

	config = function()
		require("symbols-outline").setup({
			-- highlight_hovered_item = true,
			-- show_guides = true,
			-- auto_preview = false,
			position = 'left',
			relative_width = false,
			width = 35,
			-- auto_close = false,
			-- show_numbers = false,
			-- show_relative_numbers = false,
			-- show_symbol_details = true,
			-- preview_bg_highlight = 'Pmenu',
			autofold_depth = nil,
			-- auto_unfold_hover = trunil,
			-- fold_markers = { '', '' },
			-- wrap = false,
			keymaps = {
				close = {"q"},
				goto_location = "<Cr>",
				focus_location = "o",
				hover_symbol = "<C-space>",
				toggle_preview = "K",
				rename_symbol = "r",
				code_actions = "a",
				fold = "h",
				unfold = "l",
				fold_all = "H",
				unfold_all = "L",
				fold_reset = "R",
			},
		})

		vim.cmd([[nnoremap <silent> <Leader>t :SymbolsOutline<CR>]])
	end
}
