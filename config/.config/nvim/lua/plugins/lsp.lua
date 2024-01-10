-- Todo
return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
			{
				-- keymaps = {
				-- 	-- Keymap to expand a package
				-- 	toggle_package_expand = "<CR>",
				-- 	-- Keymap to install the package under the current cursor position
				-- 	install_package = "i",
				-- 	-- Keymap to reinstall/update the package under the current cursor position
				-- 	update_package = "u",
				-- 	-- Keymap to check for new version for the package under the current cursor position
				-- 	check_package_version = "c",
				-- 	-- Keymap to update all installed packages
				-- 	update_all_packages = "U",
				-- 	-- Keymap to check which installed packages are outdated
				-- 	check_outdated_packages = "C",
				-- 	-- Keymap to uninstall a package
				-- 	uninstall_package = "X",
				-- 	-- Keymap to cancel a package installation
				-- 	cancel_installation = "<C-c>",
				-- 	-- Keymap to apply language filter
				-- 	apply_language_filter = "<C-f>",
				-- },
				'williamboman/mason.nvim',
				build = ":MasonUpdate"
			},
		},
		config = function()
			-- Default configuration is GOOD
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = true
			})

			-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require('lspconfig')

			lspconfig.lua_ls.setup{}

			-- https://www.reddit.com/r/neovim/comments/xt4f7g/how_to_set_ccls_offset_encoding_in_astrovim/
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
			lspconfig.ccls.setup {
				init_options = {
					cache = {
						directory = ".ccls-cache";
					};
				},
			}
			local notify = vim.notify
			vim.notify = function(msg, ...)
				if msg:match("warning: multiple different client offset_encodings") then
					return
				end
				notify(msg, ...)
			end

			-- lspconfig.pylyzer.setup{}
			-- [<python-lsp-server/CONFIGURATION.md at develop · python-lsp/python-lsp-server>](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md)
			require'lspconfig'.pylsp.setup{
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								-- ignore = {'E302'},
								maxLineLength = 120
							}
						}
					}
				}
			}
			-- lspconfig.pyright.setup{
			-- 	settings = {
			-- 		python = {
			-- 			analysis = {
			-- 				autoSearchPaths = true,
			-- 				diagnosticMode = "workspace",
			-- 				useLibraryCodeForTypes = false
			-- 			}
			-- 		}
			-- 	}
			-- }

			lspconfig.bashls.setup{}

			lspconfig.dotls.setup{}

			--Enable (broadcasting) snippet capability for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.cssls.setup {
				capabilities = capabilities,
			}

			lspconfig.html.setup {
				capabilities = capabilities,
			}

			lspconfig.quick_lint_js.setup{}

			-- To configure typescript language server,
			-- add a tsconfig.json or jsconfig.json to the root of your project.
			lspconfig.tsserver.setup{}

			lspconfig.jsonls.setup {
				capabilities = capabilities,
			}

			lspconfig.texlab.setup{}

			-- IMPORTANT: If you want all the features jdtls has to offer,
			-- **nvim-jdtls** is highly recommended.
			lspconfig.jdtls.setup{}

			lspconfig.marksman.setup{}
			-- require'lspconfig'.zk.setup{}  -- No single file support

			lspconfig.rust_analyzer.setup{}
			lspconfig.gopls.setup{}

			lspconfig.sqlls.setup{}

			lspconfig.vuels.setup{}
		end
	},
	{
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		-- enabled = false,
		dependencies = {
			{"nvim-tree/nvim-web-devicons"},
			{"nvim-treesitter/nvim-treesitter"}
		},
		config = function()
			require("lspsaga").setup({
				finder = {
					max_height = 0.5,
					min_width = 30,
					force_max_height = false,
					keys = {
						jump_to = 'p',
						expand_or_jump = 'o', -- Do NOT execute
						vsplit = 'v',
						split = 's',
						tabe = 't',
						tabnew = 'r',
						quit = { 'q', '<ESC>' },
						close_in_preview = '<ESC>',
					},
				},
				definition = {
					edit = "<C-c>o", -- Do NOT execute
					vsplit = "<C-c>v",
					split = "<C-c>s",
					tabe = "<C-c>t",
					quit = "q",
				},
				code_action = {
					num_shortcut = true,
					show_server_name = true,
					extend_gitsigns = true,
					keys = {
						quit = "q",
						exec = "<CR>",
					},
				},
				lightbulb = {
					enable = false,
					enable_in_insert = true,
					sign = false,
					sign_priority = 40,
					virtual_text = true,
				},
				diagnostic = {
					on_insert = false,
					on_insert_follow = false,
					insert_winblend = 0,
					show_code_action = true,
					show_source = true,
					jump_num_shortcut = true,
					max_width = 0.7,
					max_height = 0.6,
					max_show_width = 0.9,
					max_show_height = 0.6,
					text_hl_follow = true,
					border_follow = true,
					extend_relatedInformation = false,
					keys = {
						exec_action = 'o',
						quit = 'q',
						expand_or_jump = '<CR>',
						quit_in_show = { 'q', '<ESC>' },
					},
				},
				outline = {
					win_position = "left",
					win_with = "",
					win_width = 35,
					preview_width= 35,
					show_detail = true,
					auto_preview = true,
					auto_refresh = true,
					auto_close = true,
					custom_sort = nil,
					keys = {
						expand_or_jump = 'o',
						quit = "q",
					},
				},
				ui = {
					-- This option only works in Neovim 0.9
					title = true,
					-- Border type can be single, double, rounded, solid, shadow.
					border = "single",
					winblend = 0,
					expand = "",
					collapse = "",
					code_action = "💡",
					incoming = " ",
					outgoing = " ",
					hover = ' ',
					kind = {},
				},
			})
			local keymap = vim.keymap.set
			keymap("n", "<Leader>T", "<cmd>Lspsaga outline<CR>")
			-- 使用浮窗查看对应的定义, 不如 <C-]>, 注释掉
			-- keymap("n", "<Leader>D", "<cmd>Lspsaga peek_definition<CR>")
			-- keymap("n", "<Leader>D", "<cmd>Lspsaga lsp_finder<CR>")
			keymap("n", "<Leader>a", "<cmd>Lspsaga code_action<CR>")
			keymap("n", "<Leader>ew", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
			keymap("n", "<Leader>eb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
			keymap("n", "<Leader>ee", "<cmd>Lspsaga show_line_diagnostics<CR>")
			keymap("n", "<Leader>e]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
			keymap("n", "<Leader>e[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
			keymap("n", "<Leader>S", "<cmd>Lspsaga term_toggle<CR>")
			-- Many LSP not support yet?
			keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
			keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
			-- keymap("n", "<Leader>h", "<cmd>Lspsaga hover_doc<CR>")

			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<Leader>et', function()
				if(vim.diagnostic.is_disabled()) then
					vim.diagnostic.enable()
				else
					vim.diagnostic.disable()
				end
			end)
		end,
	},
}
