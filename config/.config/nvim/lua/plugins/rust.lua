-- Todo
return {
	{
		'rust-lang/rust.vim',
		ft = 'rust',
	},
	-- {
	-- 	'simrat39/rust-tools.nvim',
	-- 	-- ft = 'rust',
	-- 	config = function()
	-- 		local rt = require("rust-tools")
	-- 		rt.setup({
	-- 			server = {
	-- 				on_attach = function(_, bufnr)
	-- 					vim.keymap.set("n", "<Leader>r", rt.runnables.runnables, { buffer = bufnr })
	-- 				end,
	-- 			}
	-- 		})
	-- 	end
	-- },
}
