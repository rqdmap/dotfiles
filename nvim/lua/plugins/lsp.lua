-- Todo
return {
	'neovim/nvim-lspconfig',
	config = function()
		require'lspconfig'.jedi_language_server.setup{}
	end
}
