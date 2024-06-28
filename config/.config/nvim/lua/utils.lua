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

utils.longest_common_prefix_suffix = function(s_)
	local s = {}
	for i = 1, #s_, 1 do
		s[i] = string.sub(s_, i, i)
	end

	local n = #s;
	local pi = {}
	for i = 1, n, 1 do
		pi[i] = 0
	end
	for i = 2, n, 1 do
		local j = pi[i - 1] + 1
		while j > 1 and s[i] ~= s[j] do
			j = pi[j - 1]
		end
		if s[i] == s[j] then
			pi[i] = j
		end
	end

	return pi[n]
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
	local level = level or 1
	local indent_str = ""
	for _ = 1, level do
		   indent_str = indent_str.."  "
	end
	if type(o) == 'table' then
		   local s = '{\n' .. indent_str
		   for k,v in pairs(o) do
					if type(k) ~= 'number' then k = '"'.. k ..'"' end
					s = s .. '['..k..'] = ' .. dump(v, level + 1) .. ',\n' .. indent_str
		   end
		   return s .. '\n' .. indent_str:sub(1, -3) .. '}'
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

	fp:write("\n")
	fp:close()
	return 0
end


return utils
