-- Jump between buffer quickly, any
vim.cmd([[nnoremap gn :bn<CR>]])
vim.cmd([[nnoremap gp :bp<CR>]])
vim.cmd([[nnoremap gh :tabprevious<CR>]])
vim.cmd([[nnoremap gl :tabnext<CR>]])

vim.cmd([[nnoremap <Leader>ms :mksession! S<CR>]])


-- getpos of '< and '> only works well only **after** the selection is canceled !
-- [<(3) How to get the visual selection range? : neovim>](https://www.reddit.com/r/neovim/comments/oo97pq/how_to_get_the_visual_selection_range/)
local modify_to_latex = function()
	local map_table = {
		['，'] = ', ',
		['。'] = '. ',
		['．'] = '. ',
		['；'] = '; ',
		['：'] = ': ',
		['（'] = '(',
		['）'] = ')',
		['－'] = '-',
		['［'] = '[',
		['］'] = ']',
		['／'] = '/',
		['０'] = 0,
		['１'] = 1,
		['２'] = 2,
		['３'] = 3,
		['４'] = 4,
		['５'] = 5,
		['６'] = 6,
		['７'] = 7,
		['８'] = 8,
		['９'] = 9,
		['ａ'] = 'a',
		['ｂ'] = 'b',
		['ｃ'] = 'c',
		['ｄ'] = 'd',
		['ｅ'] = 'e',
		['ｆ'] = 'f',
		['ｇ'] = 'g',
		['ｈ'] = 'h',
		['ｉ'] = 'i',
		['ｊ'] = 'j',
		['ｋ'] = 'k',
		['ｌ'] = 'l',
		['ｍ'] = 'm',
		['ｎ'] = 'n',
		['ｏ'] = 'o',
		['ｐ'] = 'p',
		['ｑ'] = 'q',
		['ｒ'] = 'r',
		['ｓ'] = 's',
		['ｔ'] = 't',
		['ｕ'] = 'u',
		['ｖ'] = 'v',
		['ｗ'] = 'w',
		['ｘ'] = 'x',
		['ｙ'] = 'y',
		['ｚ'] = 'z',
		['Ａ'] = 'A',
		['Ｂ'] = 'B',
		['Ｃ'] = 'C',
		['Ｄ'] = 'D',
		['Ｅ'] = 'E',
		['Ｆ'] = 'F',
		['Ｇ'] = 'G',
		['Ｈ'] = 'H',
		['Ｉ'] = 'I',
		['Ｊ'] = 'J',
		['Ｋ'] = 'K',
		['Ｌ'] = 'L',
		['Ｍ'] = 'M',
		['Ｎ'] = 'N',
		['Ｏ'] = 'O',
		['Ｐ'] = 'P',
		['Ｑ'] = 'Q',
		['Ｒ'] = 'R',
		['Ｓ'] = 'S',
		['Ｔ'] = 'T',
		['Ｕ'] = 'U',
		['Ｖ'] = 'V',
		['Ｗ'] = 'W',
		['Ｘ'] = 'X',
		['Ｙ'] = 'Y',
		['Ｚ'] = 'Z',
		-- Remove references
		-- ['%[%s*%d+%s*]'] = '',
		-- ['%[%s*%d+%s*,%s*%d+%s*%,%s*%d+%s*%]'] = '',

		['“'] = '``',
		['”'] = "''",

		['^%%'] = "\\%%",
		['^~']  = "\\~",
		['^&']  = "\\&",
		['^_']	= "\\_",
		['^#']	= "\\#",
		['([^\\])(%%)'] = "%1\\%%",
		['([^\\])(~)']  = "%1\\~",
		['([^\\])(&)']  = "%1\\&",
		['([^\\])(_)']  = "%1\\_",
		['([^\\])(#)']  = "%1\\#",
	}
	local recursive_times = 10
	local base = "%s*%d+%s*"
	local extend = ",%s*%d+%s*"
	for _ = 1, recursive_times do
		local key = '%[' .. base .. '%]'
		map_table[key] = ''
		base = base .. extend
    end

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local text = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
	for k, v in pairs(map_table) do
		text = text:gsub(k, v)
	end
	vim.api.nvim_buf_set_lines(0, row - 1, row, true, {text})
end
vim.keymap.set('n', '<Leader>,', modify_to_latex)

local to_full = function()
	local map_table = {
		['%, ']	= '，',
		['%.$']	= '。',
		['%. ']	= '。',
		['%; ']	= '；',
		['%: ']	= '：',
		['%(']	= '（',
		['%)']	= '）',
	}

	local row = vim.api.nvim_win_get_cursor(0)[1]
	local text = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
	for k, v in pairs(map_table) do
		text = text:gsub(k, v)
	end
	vim.api.nvim_buf_set_lines(0, row - 1, row, true, {text})
end
vim.keymap.set('n', '<Leader>.', to_full)

local modified_enter = function()
	local pwd = vim.fn.getcwd()
	local filepath = vim.fn.expand('%:p')
	local fail = false
	for i = 1, #pwd do
		if pwd:sub(i, i) ~= filepath:sub(i, i) then
			fail = true
			break
		end
	end
	if fail == false then
		print(filepath:sub(#pwd + 2))
	else
		print(filepath)
	end

end

vim.keymap.set('n', '<C-g>', modified_enter)

local highlight_current_word = function()
	vim.cmd("normal! *")
	vim.cmd("normal! N")
	vim.cmd("normal! zz")
end

-- 创建一个命令来调用高亮函数
vim.keymap.set('n', '*', highlight_current_word)


local git_commit = function()
	local pwd = vim.fn.getcwd()
	local filepath = vim.fn.expand('%:p')
	local fail = false
	for i = 1, #pwd do
		if pwd:sub(i, i) ~= filepath:sub(i, i) then
			fail = true
			break
		end
	end
	if fail == true then
		print("Not in current dir")
		return
	end
	local rel_path = filepath:sub(#pwd + 2)
	local cmd = 'git add ' .. rel_path .. ' > /dev/null 2>&1; git commit -m "[ Neovim Lua 快捷保存 ]" > /dev/null 2>&1'
	print(cmd)
	os.execute(cmd)
end

vim.keymap.set('n', '<Leader>sv', git_commit)


-- vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>lua if is_markdown() then print("Custom action in Markdown mode") else vim.cmd("normal! \<C-b>") end<CR>', { noremap = true, silent = true })


-- Markdown 快捷键
local function is_markdown()
    return vim.bo.filetype == "markdown"
end

-- 仅支持 Visual 模式下的操作, 支持 CJK
local wrap_text = function(wrapper)
	if vim.fn.mode() ~= 'v' then return end

	-- 获取选中区域的起始行和结束行
	local _, start_line, start_col, _ = unpack(vim.fn.getpos("v"))
	local _, end_line, end_col, _ = unpack(vim.fn.getpos("."))

	if start_line > end_line or (start_line == end_line and start_col > end_col) then
		vim.api.nvim_input('o')
	end
	vim.api.nvim_input('<Esc>a' ..wrapper .. '<Esc>gvo<Esc>i' .. wrapper .. '<Esc>')
end

local text_bold = function ()
	if not is_markdown() or vim.fn.mode() ~= 'v' then
		-- vim.cmd([[exe "normal! \<c-b>"]])
		return
	end
	wrap_text("**")
end

local text_delete = function ()
	if not is_markdown() or vim.fn.mode() ~= 'v' then return end
	wrap_text("~~")
end

vim.keymap.set('x', '<S-b>', text_bold)
vim.keymap.set('x', '<S-d>', text_delete)

