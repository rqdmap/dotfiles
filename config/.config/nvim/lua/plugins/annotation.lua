return {
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			 local i = require("neogen.types.template").item

			 annotation = {
				 { nil, "- $1", { type = { "class", "func" } } },
				 { nil, "- $1", { no_results = true, type = { "class", "func" } } },
				 { nil, "-@module $1", { no_results = true, type = { "file" } } },
				 { nil, "-@author $1", { no_results = true, type = { "file" } } },
				 { nil, "-@license $1", { no_results = true, type = { "file" } } },
				 { nil, "", { no_results = true, type = { "file" } } },
				 { i.Parameter, "-@param %s $1|any" },
				 { i.Vararg, "-@vararg $1|any" },
				 { i.Return, "-@return $1|any" },
				 { i.ClassName, "-@class $1|any" },
				 { i.Type, "-@type $1" },
			 }
			require('neogen').setup {
				enabled = true,
				-- Go to annotation after insertion, and change to insert mode
				input_after_comment = true,
				snippet_engine = "luasnip",
				-- Enables placeholders when inserting annotation
				enable_placeholders = true,
				-- Placeholders used during annotation expansion
				placeholders_text = {
					["description"] = "[TODO:description]",
					["tparam"] = "[TODO:tparam]",
					["parameter"] = "[TODO:parameter]",
					["return"] = "[TODO:return]",
					["class"] = "[TODO:class]",
					["throw"] = "[TODO:throw]",
					["varargs"] = "[TODO:varargs]",
					["type"] = "[TODO:type]",
					["attribute"] = "[TODO:attribute]",
					["args"] = "[TODO:args]",
					["kwargs"] = "[TODO:kwargs]",
				},
				-- Placeholders highlights to use. If you don't want custom highlight, pass "None"
				placeholders_hl = "DiagnosticHint",

				-- https://github.com/danymat/neogen/tree/main/lua/neogen/configurations
				languages = {
					-- 默认使用 Google 风格的 Python 文档字符串
					python = {
						template = {
							-- annotation_convention = "reST"
						}
					},
				},
			}
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap("n", "<Leader>q", ":lua require('neogen').generate()<CR>", opts)
		end
		-- Uncomment next line if you want to follow only stable versions
		-- version = "*" 
	}
}
