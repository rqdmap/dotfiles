-- 自动跳转到上次编辑的位置
vim.api.nvim_create_autocmd("BufReadPost",{
	command = [[
		if line("'\"") > 0 && line("'\"") <= line("$") |
		exe "normal! g`\"" |
		endif
	]]
})


-- 自动生成dot文件的png图片
vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*.dot",
	command = [[
		!dot -Tpng -o %.png % 
	]]
})

-- 自动重新生成polybar
vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/polybar/config.ini",
	command = [[
		!polybar_run
	]]
})

-- 修改giph源码时则修改对应的缩进
vim.api.nvim_create_autocmd("BufRead",{
	pattern = "giph",
	command = [[
		setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
	]]
})

-- -- 自动生成dot文件的png图片
-- vim.api.nvim_create_autocmd("BufWritePost",{
-- 	pattern = "*.dot",
-- 	command = [[
-- 		!dot -Tpng -o %.png % 
-- 	]]
-- })
