-- Todo

return {
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'rqdmap/cmp-cmdline',
	'hrsh7th/cmp-nvim-lsp',
	'saadparwaiz1/cmp_luasnip',
	{
		'hrsh7th/nvim-cmp',
		dependencies = "onsails/lspkind.nvim",
		config = function()
			local utils = require("utils")
			local words_before_cursor = utils.words_before_cursor

			local luasnip = require("luasnip")
			local cmp = require("cmp")
			local cmp_buffer = require("cmp_buffer")

			local lspkind = require('lspkind')

			local source_buffer = {
					name = 'buffer' ,
					option = {
						get_bufnrs = function()
							local is_small_buf = function(index, buf)
								local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
								return byte_size <= 1024*1024 -- 1 Megabyte max
							end
							local all_bufs = vim.api.nvim_list_bufs()
							return vim.fn.filter(all_bufs, is_small_buf)
						end,

						-- keyword_length = 
						-- keyword_pattern = 
						indexing_interval = 10,
						indexing_batch_size = 100,
						max_indexed_line_length = 1024
					}
			}

			local source_path = {
				name = 'path',
				option = {
					trailing_slash = false,
					label_trailing_slash = false,
					-- get_cwd = function() Something.. end
				}
			}

			local source_cmdline = {
				name = 'cmdline',
				option =  {
					ignore_cmds = {
						"Man",
						"!",
					}
				}
			}

			local comparator_helper = function(is_something)
				local comparator = function(entry1, entry2)
					if is_something(entry1) and not is_something(entry2) then
						return true
					elseif not is_something(entry1) and is_something(entry2) then
						return false
					end
				end
				return comparator
			end

			local is_luasnip_exact = function(entry)
				local name = entry.source.name
				if name == 'luasnip' and entry.exact then return true end
				return false
			end

			local is_ai_source = function(entry)
				local name = entry.source.name
				if name == 'codeium' or name == 'copilot' then return true end
				return false
			end

			local is_field_kind = function(entry)
				local kind = entry:get_kind()
				local CompletionItemKind = require("cmp.types").lsp.CompletionItemKind
				if kind == CompletionItemKind.Field then return true end
				return false
			end

			local not_text_kind = function(entry)
				local kind = entry:get_kind()
				local CompletionItemKind = require("cmp.types").lsp.CompletionItemKind
				if kind ~= CompletionItemKind.Text then return true end
				return false
			end

			-- 由于nvim-cmp带有的模糊查找功能, 一些*子序列*的优先级可能会超过*前缀*序列
			-- 因而使用 KMP 检查 ** 最长公共前后缀的长度** 以此排序
			local cmp_prefix = function(entry1, entry2)
				local foo = require("utils").longest_common_prefix_suffix
				-- local foo = require("utils").prefix_cnt
				local words = words_before_cursor()
				if words == nil then return end

				local cnt1 = foo(entry1.completion_item.label .. words)
				local cnt2 = foo(entry2.completion_item.label .. words)
				if(cnt1 > cnt2) then return true
				elseif(cnt2 > cnt1) then return false end
			end

			-- Read The Fucking Manual
			cmp.setup({
				enabled = function ()
					return true
					-- disable completion in comments
					-- local context = require 'cmp.config.context'
					-- if vim.api.nvim_get_mode().mode == 'c' then
					-- 	return true
					-- else
					-- 	return not context.in_treesitter_capture("comment")
					-- 		and not context.in_syntax_group("Comment")
					-- end
				end,

				performance = {
					debounce = 50,
					throttle = 50,
					fetching_timeout = 50,
				},

				mapping = cmp.mapping.preset.insert({
					['<Esc>'] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() ~= nil then
							cmp.abort()
						else
							fallback()
						end
					end),

					['<Cr>'] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() ~=nil then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Select,
							})
						else
							fallback()
						end
					end),

					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						-- elseif luasnip.locally_jumpable() then
							-- luasnip.jump(1)
						else
							fallback()
						end
					end, {"i", "s"}),

					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable() then
							luasnip.jump(-1)
						end
					end, {"i", "s"}),

					['<C-l>'] = cmp.mapping(function()
						if luasnip.locally_jumpable() then
							luasnip.jump(1)
						end
					end, {"i", "s"}),

					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable() then
							luasnip.jump(-1)
						else
							fallback()
						end
    				end),

					['<C-b>'] = cmp.mapping.select_prev_item({count = 4}),
					['<C-f>'] = cmp.mapping.select_next_item({count = 4}),

					['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
					['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down

					['<C-p>'] = cmp.mapping(function()
						cmp.complete()
					end),
				}),

				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},

				completion = {
					-- Describes: Set trigger for autocomplete, not used so far.
					-- Params: cmp.TriggerEvent[] | false
					-- autocomplete = false
				},
				preselect = cmp.PreselectMode.None,
				formatting = {
					expandable_indicator = false,
					-- ItemField = { },
					-- format = 
					format = lspkind.cmp_format({
						mode = 'symbol_text',
						maxwidth = 50,
						ellipsis_char = '...',
						elide_long_lines = true,
					}),
				},

				matching = {
					disallow_fuzzy_matching = false,
					disallow_fullfuzzy_matching = false,
					disallow_partial_fuzzy_matching = false,
					disallow_partial_matching = false,
					disallow_prefix_unmatching = false
				},

				sources = cmp.config.sources({
					{ name = "codeium" },
					{ name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					source_buffer,
					source_path,
				}),

				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},

				sorting = {
					comparators = {
						comparator_helper(is_luasnip_exact),
						comparator_helper(is_ai_source),
						cmp_prefix,
						comparator_helper(is_field_kind),
						comparator_helper(not_text_kind),
						cmp.config.compare.kind,
						cmp.config.compare.length,

						-- cmp.config.compare.locality,
						-- cmp.config.compare.score,
						-- cmp.config.compare.sort_text,
						-- cmp.config.compare.order,
						-- cmp.config.compare.offset,
						-- cmp.config.compare.scopes,
						-- cmp.config.compare.recently_used,
					}
				}
			})


			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				-- Provided By `cmp.mapping.preset.cmdline`
				-- <C-z>:		complete | select_next_item 
				-- <Tab>:		complete | select_next_item 
				-- <S-Tab>:		complete | select_prev_item 
				-- <C-n>, <C-p>, <C-e>, <C-p>
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					source_buffer,
				},
				sorting = {
					comparators = {
						cmp_prefix,
						function(...) return cmp_buffer:compare_locality(...) end,
					}
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					source_cmdline
				}),
				completion = {
					autocomplete = false
				},
				sorting = {
					comparators = {
						cmp_prefix,
						function(...) return cmp_buffer:compare_locality(...) end,
					}
				}
			})
		end
	}
}
