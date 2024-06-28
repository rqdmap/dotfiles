local autocmd = vim.api.nvim_create_autocmd


-- 自动跳转到上次编辑的位置
autocmd("BufReadPost",{
	command = [[
		if line("'\"") > 0 && line("'\"") <= line("$") |
		exe "normal! g`\"" |
		endif
	]]
})


-- 自动生成dot文件的png图片
autocmd("BufWritePost",{
	pattern = "*.dot",
	command = [[
		!dot -Tpng -o %.png % 
	]]
})

-- 自动重新生成polybar
autocmd("BufWritePost",{
	pattern = "*/polybar/config.ini",
	command = [[
		!polybar_run
	]]
})

-- 修改giph源码时则修改对应的缩进
autocmd("BufRead",{
	pattern = "giph",
	command = [[
		setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
	]]
})


-- MacOS 输入法切换, 需要安装 macsim
-- xkbswitch 无法正确切换鼠须管, issue: https://github.com/rime/squirrel/issues/402
local get_current_layout = function()
    local file = io.popen('macism')
	if file then
		local output = file:read('*all')
		file:close()
		return output
	else
		error("Error occured: macism failed")
		return nil
	end
end

local saved_layout = get_current_layout()
local us_layout_name = "com.apple.keylayout.ABC"

autocmd(
	{'InsertLeave', 'FocusLost'},
	{
		pattern = "*",
		callback = function()
			-- vim.schedule(function()
				saved_layout = get_current_layout()
				os.execute('macism ' .. us_layout_name);
			-- end)
		end
	}
)

autocmd(
	{'InsertEnter', 'FocusGained'},
	{
		pattern = "*",
		callback = function()
			-- vim.schedule(function()
			if(saved_layout ~= us_layout_name) then
				os.execute('macism ' .. saved_layout);
			end
			-- end)
		end
	}
)

autocmd("BufWritePost",{
	pattern = "*/.config/sketchybar/*",
	command = [[
		!sketchybar --reload
	]]
})
