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

-- 自动 rsync
vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/reasoner/*",
	command = [[
		silent !boe push ~/Codes/reasoner
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/ocean_rpc_service/*",
	command = [[
		silent !boe push ~/Codes/ocean_rpc_service
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/ocean/*",
	command = [[
		silent !boe push ~/Codes/ocean
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/tmp/*",
	command = [[
		silent !boe push ~/Codes/tmp
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/bkb_engine_server/*",
	command = [[
		silent !boe push ~/Codes/bkb_engine_server
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/bkb_robot/*",
	command = [[
		silent !boe push ~/Codes/bkb_robot
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/baike_realtime/*",
	command = [[
		silent !boe push ~/Codes/baike_realtime
	]]
})

vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*/Codes/sql直连操作mysql/*",
	command = [[
		silent !boe push ~/Codes/sql直连操作mysql
	]]
})
