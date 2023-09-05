-- Todo
return {
	'nvim-tree/nvim-tree.lua',
	dependencies = 'nvim-tree/nvim-web-devicons',
	-- tag = 'nightly' -- optional, updated every week. (see issue #1193)
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- empty setup using defaults
		require("nvim-tree").setup{
			sort_by	= "modification_time",
			view = {
				width = 35,
			},
			filters = {
				git_ignored = false,
				dotfiles = false
			},
			trash = {
				cmd = "trash"
			},
			update_focused_file = {
				enable = true,
				update_root = false,
				ignore_list = {},
			},
		}

		local api = require("nvim-tree.api")
		vim.cmd([[nnoremap <silent> <Leader>f :NvimTreeToggle<CR>]])
		-- vim.keymap.set('n', 'l', api.node.open.edit)
	end
}

