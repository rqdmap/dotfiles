-- Todo
return {
	"zbirenbaum/copilot.lua",
	-- event = "InsertEnter",
	config = function()
		require('copilot').setup({
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "<M-r>",
					open = "<M-p>"
				},
				layout = {
					position = "right", -- | top | left | right
					ratio = 0.3
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-e>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = 'node', -- Node.js version must be > 16.x
			server_opts_overrides = {},
		})
	end
}
