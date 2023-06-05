local utils = {}


-- Check whether there exists word before cursor
-- Return: Nil or String
utils.words_before_cursor = function()
	local _ = vim.api.nvim_win_get_cursor(0)
	local row = _[1]
	local col = _[2]

	if col == 0 then return nil end
	local word = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(0, col):match("[^%s]+$")
	return word
end


-- Returns the length of the longest common prefix of s1 and s2
utils.prefix_cnt = function(s1, s2)
	if(s1 == nil or type(s1) ~= "string") then return 0 end
	if(s2 == nil or type(s2) ~= "string") then return 0 end

	local len = math.min(#s1, #s2)
	local cnt = 0
	for i = 1, len, 1 do
		if(s1:sub(i, i) == s2:sub(i,i)) then
			cnt = cnt + 1
		else break end
	end
	return cnt
end


-- Merge t1 with t2, insert every kv from t2 into t1;
-- entries with the same key will be overwrite by `t2`
-- Return table `t1`
utils.table_merge = function(t1, t2)
	for k,v in pairs(t2) do
		t1[k] = v
	end
	return t1
end


utils.dump = function(o)
	if type(o) == 'table' then
		local s = '{\n'
		for k,v in pairs(o) do
			 if type(k) ~= 'number' then k = '"'.. k ..'"' end

			 s = s .. '\t['..k..'] = ' .. utils.dump(v) .. ',\n'
		end
		return s .. '\n}\n'
	else
		return '"' .. tostring(o) .. '"'
	end
end

utils.log = function(msg, file)
	file = file or "log"
	local fp = io.open(file, "a")
	if fp == nil then
		print("Error open file: ", file)
		return -1
	end

	fp:write(utils.dump(msg))

	fp:write("\nEND =================================================\n\n")
	fp:close()
	return 0
end


return utils
