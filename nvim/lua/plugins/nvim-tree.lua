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
			sort_by				= "modified",
			filters = {
				dotfiles = true
			},
			trash = {
				cmd = "trash"
			},
			update_focused_file = {
				enable = true,
				update_root = true,
				ignore_list = {},
			},
		}

		-- Nvim Tree相关配置
		vim.cmd([[nnoremap <silent> <Leader>f :NvimTreeToggle<CR>]])

	end
}

