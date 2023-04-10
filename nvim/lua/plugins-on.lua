require'nvim-web-devicons'.setup {
  color_icons = true;
  default = true;
}

require('lualine').setup {
	options = {
		icons_enabled = false,
		theme = 'gruvbox',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {''},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},

	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
	extensions = {}
}


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup{
	sort_by				= "modified",
	filters = {
		dotfiles = true
	},
	trash = {
		cmd = "trash"
	},
}

-- -- OR setup with some options
-- require("nvim-tree").setup({
--   sort_by = "case_sensitive",
--   view = {
--     adaptive_size = true,
--     mappings = {
--       list = {
--         { key = "u", action = "dir_up" },
--       },
--     },
--   },
--   renderer = {
--     group_empty = true,
--   },
--   filters = {
--     dotfiles = true,
--   },
-- })


require('Comment').setup( {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    -- -Lines to be ignored while (un)comment
    ignore = nil,
    -- -LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = '<leader>cc',
        ---Block-comment toggle keymap
        block = '<leader>cb',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = '<leader>cc',
        ---Block-comment keymap
        block = '<leader>cb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = false
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
})


local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

require'lspconfig'.jedi_language_server.setup{}


-- Tagbar相关配置
vim.cmd([[nnoremap <silent> <Leader>tt :TagbarToggle<CR>]])
vim.g['tagbar_position'] = 'leftabove vertical'
vim.g['tagbar_width'] = 30
vim.g['tagbar_autofocus'] = 0
vim.g['tagbar_sort'] = 0
vim.g['tagbar_compact'] = 1
-- vim.g['tagbar_show_tag_linenumbers'] = 3
vim.g['tagbar_indent'] = 1


-- 关闭TableMode的默认映射, 其将只保留<leader>tm的映射
vim.g['table_mode_disable_tableize_mappings'] = 1

-- Nvim Tree相关配置
vim.cmd([[nnoremap <silent> <Leader>f :NvimTreeToggle<CR>]])


-- 配置快捷键操作copilot, 因为没有toggle, 所以采用这种方式
vim.cmd([[nnoremap <silent> <Leader>cp :Copilot ]])


-- 配置bufferline
require('bufferline').setup {
	 	options = {
	 		mode = "buffers", -- set to "tabs" to only show tabpages instead
	 		numbers =  "buffer_id" ,
--			close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
--			right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
--			left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
	-- 		middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
	-- 		indicator = {
	-- 			icon = '▎', -- this should be omitted if indicator style is not 'icon'
	-- 			style = 'icon' | 'underline' | 'none',
	-- 		},
	-- 		buffer_close_icon = '',
	-- 		modified_icon = '●',
	-- 		close_icon = '',
	-- 		left_trunc_marker = '',
	-- 		right_trunc_marker = '',
	-- 		--- name_formatter can be used to change the buffer's label in the bufferline.
	-- 		--- Please note some names can/will break the
	-- 		--- bufferline so use this at your discretion knowing that it has
	-- 		--- some limitations that will *NOT* be fixed.
	-- 		name_formatter = function(buf)  -- buf contains:
	-- 			  -- name                | str        | the basename of the active file
	-- 			  -- path                | str        | the full path of the active file
	-- 			  -- bufnr (buffer only) | int        | the number of the active buffer
	-- 			  -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
	-- 			  -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
	-- 		end,
	-- 		max_name_length = 18,
	-- 		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
	-- 		truncate_names = true, -- whether or not tab names should be truncated
	-- 		tab_size = 18,
	-- 		diagnostics = false | "nvim_lsp" | "coc",
	-- 		diagnostics_update_in_insert = false,
	-- 		-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
	-- 		diagnostics_indicator = function(count, level, diagnostics_dict, context)
	-- 			return "("..count..")"
	-- 		end,
	-- 		-- NOTE: this will be called a lot so don't do any heavy processing here
	-- 		custom_filter = function(buf_number, buf_numbers)
	-- 			-- filter out filetypes you don't want to see
	-- 			if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
	-- 				return true
	-- 			end
	-- 			-- filter out by buffer name
	-- 			if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
	-- 				return true
	-- 			end
	-- 			-- filter out based on arbitrary rules
	-- 			-- e.g. filter out vim wiki buffer from tabline in your work repo
	-- 			if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
	-- 				return true
	-- 			end
	-- 			-- filter out by it's index number in list (don't show first buffer)
	-- 			if buf_numbers[1] ~= buf_number then
	-- 				return true
	-- 			end
	-- 		end,
	-- 		offsets = {
	-- 			{
	-- 				filetype = "NvimTree",
	-- 				text = "File Explorer" | function ,
	-- 				text_align = "left" | "center" | "right"
	-- 				separator = true
	-- 			}
	-- 		},
	-- 		color_icons = true | false, -- whether or not to add the filetype icon highlights
	-- 		get_element_icon = function(element)
	-- 		  -- element consists of {filetype: string, path: string, extension: string, directory: string}
	-- 		  -- This can be used to change how bufferline fetches the icon
	-- 		  -- for an element e.g. a buffer or a tab.
	-- 		  -- e.g.
	-- 		  local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
	-- 		  return icon, hl
	-- 		  -- or
	-- 		  local custom_map = {my_thing_ft: {icon = "my_thing_icon", hl}}
	-- 		  return custom_map[element.filetype]
	-- 		end,
	-- 		show_buffer_icons = true | false, -- disable filetype icons for buffers
	-- 		show_buffer_close_icons = true | false,
	-- 		show_buffer_default_icon = true | false, -- whether or not an unrecognised filetype should show a default icon
	-- 		show_close_icon = true | false,
	-- 		show_tab_indicators = true | false,
	-- 		show_duplicate_prefix = true | false, -- whether to show duplicate buffer prefix
	-- 		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
	-- 		-- can also be a table containing 2 custom separators
	-- 		-- [focused and unfocused]. eg: { '|', '|' }
	-- 		separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
	-- 		enforce_regular_tabs = false | true,
	-- 		always_show_bufferline = true | false,
	-- 		hover = {
	-- 			enabled = true,
	-- 			delay = 200,
	-- 			reveal = {'close'}
	-- 		},
	-- 		sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
	-- 			-- add custom logic
	-- 			return buffer_a.modified > buffer_b.modified
	-- 		end
	 	}
}


