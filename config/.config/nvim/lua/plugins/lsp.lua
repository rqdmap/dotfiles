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
				automatic_installation = false
			})

			-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

			local lspconfig = require('lspconfig')

			lspconfig.lua_ls.setup{}

			-- https://www.reddit.com/r/neovim/comments/xt4f7g/how_to_set_ccls_offset_encoding_in_astrovim/
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
			-- lspconfig.ccls.setup {
			-- 	init_options = {
			-- 		cache = {
			-- 			directory = ".ccls-cache";
			-- 		};
			-- 	},
			-- }
			local notify = vim.notify
			vim.notify = function(msg, ...)
				if msg:match("warning: multiple different client offset_encodings") then
					return
				end
				notify(msg, ...)
			end

			-- lspconfig.pylyzer.setup{}
			-- [<python-lsp-server/CONFIGURATION.md at develop · python-lsp/python-lsp-server>](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md)
			lspconfig.pylsp.setup{
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								ignore = {'E731', 'E302'},
								maxLineLength = 120
							}
						}
					}
				}
			}

			-- 支持 call graph; pylyzer 好像不支持
			lspconfig.pyright.setup{
				settings = {
					python = {
						-- [<Language Server Settings>](https://microsoft.github.io/pyright/#/settings)
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = false,
							typeCheckingMode = "off",
							-- typeCheckingMode = "strict",
						}
					}
				}
			}


			lspconfig.bashls.setup{}

			lspconfig.dotls.setup{}

			--Enable (broadcasting) snippet capability for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			lspconfig.clangd.setup {}

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

			local HOME = vim.fn.expand('$HOME')
			lspconfig.jdtls.setup{
				cmd = {
					"jdtls",
					"-configuration", HOME .. "/.cache/jdtls/config",
					"-data", HOME .. "/.cache/jdtls/workspace",
					"--jvm-arg=-javaagent:" .. HOME .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
				},
				settings = {
					java = {
						format = {
							settings = {
								url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
								profile = "GoogleStyle"
							}
						}
				-- 		configuration = {
				-- 			-- 使 jdtls 了解你的 Maven 配置，
				-- 			-- 这里指定 settings.xml 路径
				-- 			updateBuildConfiguration = "interactive",
				-- 			maven = {
				-- 				userSettings = "/Users/rqdmap/Applications/apache-maven-3.9.7/conf/settings.xml"
				-- 			}
				-- 		},
					}
				}
			}
			-- lspconfig.java_language_server.setup{}

			lspconfig.marksman.setup{}
			-- require'lspconfig'.zk.setup{}  -- No single file support

			lspconfig.rust_analyzer.setup({
				settings = {
					['rust-analyzer'] = {
						inlayHints = {
							-- closingBraceHints = {
							-- 	enable = true;
							-- 	minLines = 0;
							-- }
						}
					}
				},
				on_attach = function(client, bufnr)
					vim.lsp.inlay_hint.enable(bufnr)
				end
			})
			lspconfig.gopls.setup{}
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
				code_action = {
					num_shortcut = true,
					show_server_name = true,
					extend_gitsigns = true,
					keys = {
						quit = "q",
						exec = "<CR>",
					},
				},
				-- definition = {
				-- 	edit = "<C-c>o", -- Do NOT execute
				-- 	vsplit = "<C-c>v",
				-- 	split = "<C-c>s",
				-- 	tabe = "<C-c>t",
				-- 	quit = "q",
				-- },
				finder = {
					max_height = 0.5,
					min_width = 30,
					force_max_height = false,
					keys = {
						toggle_or_open = {'o', '<CR>'},
						vsplit = 'v',
						split = 's',
						tabe = 't',
						tabnew = 'r',
						quit = { 'q', '<ESC>' },
						close_in_preview = '<ESC>',
					},
				},
				callhierarchy = {
					keys = {
						edit = {'o', '<CR>'},
						vsplit = 'v',
						split = 's',
						tabe = 't',
						tabnew = 'r',
						quit = { 'q', '<ESC>' },
						close_in_preview = '<ESC>',
					},
				},
				lightbulb = {
					enable = false,
					enable_in_insert = false,
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
					-- win_width = 50,
					auto_preview = false,
					detail = false,
					auto_close = true,
					close_after_jump = false,
					layout = 'normal',   -- or 'float'
					max_height = 0.5,	 -- height of outline float layout
					left_width = 0.3,	 -- width of outline float layout left window
					-- auto_resize = true,

					keys = {
						jump = {'<CR>', 'o'},
						-- expnd_or_jump = {'t'},
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
			-- Callhierarchy
			keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
			keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

			-- Code Action
			keymap("n", "<Leader>a", "<cmd>Lspsaga code_action<CR>")

			-- -- Definition
			-- keymap("n", "<Leader>d", "<cmd>Lspsaga peek_definition<CR>")
			-- keymap("n", "<Leader>d", "<cmd>Lspsaga goto_type_definition<CR>")

			-- Diagnostic
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			keymap("n", "<Leader>ew", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
			keymap("n", "<Leader>eb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
			keymap("n", "<Leader>ee", "<cmd>Lspsaga show_line_diagnostics<CR>")
			keymap("n", "<Leader>e]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
			keymap("n", "<Leader>e[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
			vim.keymap.set('n', '<Leader>et', function()
				if(vim.diagnostic.is_disabled()) then
					vim.diagnostic.enable()
				else
					vim.diagnostic.disable()
				end
			end)

			-- Finder
			keymap("n", "<Leader>d", "<cmd>Lspsaga finder<CR>")

			-- Float Terminal
			keymap("n", "<Leader>S", "<cmd>Lspsaga term_toggle<CR>")

			-- Hover
			keymap("n", "<Leader>h", "<cmd>Lspsaga hover_doc<CR>")

			-- Outline
			-- keymap("n", "<Leader>t", "<cmd>Lspsaga outline<CR>")
		end,
	},
}
