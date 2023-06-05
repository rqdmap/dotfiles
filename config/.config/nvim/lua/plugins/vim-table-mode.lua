-- Todo
return {
	'dhruvasagar/vim-table-mode',

	-- Changing prefix doesn't work, so I cannot spare <Leader>t for tagbar
	-- https://github.com/dhruvasagar/vim-table-mode/issues/222
	-- Disable temporarily
	enabled = false,

	keys = {
		"<leader>Tm"
	},
	init = function()
		vim.g['table_mode_map_prefix'] = '<Leade>T'
	end
}
