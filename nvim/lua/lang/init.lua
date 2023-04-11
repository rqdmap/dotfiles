local path = vim.fn.stdpath("config") .. "/lua/lang"
local lang = {}

for _, file in pairs(vim.split(vim.fn.glob(path .. "/*"), '\n')) do
 	local _file = string.match(file, "[^/]+$"):gsub("%.lua", "")
 	if _file ~= "init" then
 		table.insert(lang, _file)
 	end
end

for _, v in ipairs(lang) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = v,
		once = true,
		callback = function(ev)
			require("lang." .. v)
		end
	})
end


