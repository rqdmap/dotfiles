-- Todo
return {
	'dhruvasagar/vim-table-mode',
	keys = {
		"<leader>tm"
	},
	config = function()
		-- 关闭TableMode的默认映射, 其将只保留<leader>tm的映射
		-- vim.g['table_mode_disable_tableize_mappings'] = 1
	end
}
