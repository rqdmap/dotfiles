-- Todo
return {
	-- 高亮
	{
		'octol/vim-cpp-enhanced-highlight',
		ft = 'cpp',
	},

	-- completion
	{
		'xavierd/clang_complete',
		ft = 'cpp',
		config = function()
			vim.g.clang_use_library=1
			vim.g.clang_library_path='/usr/lib/libclang.so'
		end
	}
}
