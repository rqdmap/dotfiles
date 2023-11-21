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
				git_ignored = true,
				dotfiles = true
			},
			trash = {
				cmd = "trash"
			},
			update_focused_file = {
				enable = true,
				update_root = false,
				ignore_list = {},
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true
					}
				end
				api.config.mappings.default_on_attach(bufnr)


				local toggle_all_filter = function()
					api.tree.toggle_gitignore_filter()
					api.tree.toggle_hidden_filter()
					api.tree.toggle_custom_filter()
				end

				local map = vim.keymap.set;
				map('n', '?',		api.tree.toggle_help,		opts('Help'))
				map('n', 'L',		api.tree.expand_all,		opts('Expand all'))
				map('n', 'H',		api.tree.collapse_all,		opts('Collapse all'))
				map('n', '<C-h>',	toggle_all_filter,			opts('Toggle filter'))
			end
		}

		vim.cmd([[nnoremap <silent> <Leader>f :NvimTreeToggle<CR>]])
	end
}


