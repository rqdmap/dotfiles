-- Todo
return {
	-- {
	-- 	'Sirver/ultisnips',
	-- 	config = function()
	-- 		vim.g.UltiSnipsSnippetDirectories={'UltiSnips', os.getenv("HOME")..'/.config/nvim/mySnips'} -- 配置自己补全目录
	-- 	end
	-- }, 
	
	'honza/vim-snippets',

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "1.*",
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},
}
