-- Todo
return {
	'akinsho/bufferline.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function()
		require('bufferline').setup {
			options = {
				mode = "buffers",
				numbers =  "buffer_id" ,
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local s = ""
					if vim.diagnostic.is_disabled() then
						return s
					end
					if diagnostics_dict["error"] ~= nil then
						s = s .. " " .. diagnostics_dict["error"]
						return s
					end
					if diagnostics_dict["warning"] ~= nil then
						s = s .. " " .. diagnostics_dict["warning"]
						return s
					end
					if diagnostics_dict["hint"] ~= nil then
						s = s .. " " .. diagnostics_dict["hint"]
						return s
					end
					return s
				end
			}
		}
	end
}

