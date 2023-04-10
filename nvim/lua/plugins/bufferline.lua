-- Todo
return {
	'akinsho/bufferline.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function()
		require('bufferline').setup {
			options = {
				mode = "buffers", -- set to "tabs" to only show tabpages instead
				numbers =  "buffer_id" ,
			}
		}
	end
}
