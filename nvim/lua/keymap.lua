-- Quite ugly... Though works well... 后期一定会改进的...
-- https://vi.stackexchange.com/questions/41405/how-to-extract-filename-of-w-command-in-vims-autocmd
vim.cmd([[
	function! CorrectWritePath()
	  if getcmdtype() != ':'
		return "\<CR>"
	  endif

	  if matchstr(getcmdline(), '^w\%[rite]!\?\>') == ''
		return "\<CR>"
	  endif

	  let l:cmdline = getcmdline()

	  " Parse the cmd line
	  let l:newcmdline = l:cmdline
	  let l:good = v:true
	  if matchstr(l:cmdline, ']') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, ']', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '[') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '[', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '`') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '`', '\', 'g')
		let l:good = v:false
	  endif
	  if matchstr(l:cmdline, '=') != ''
		echo 'match'
		let l:newcmdline = substitute(l:cmdline, '=', '\', 'g')
		let l:good = v:false
	  endif

	  if l:good
		return "\<CR>"
	  else
		return "\<C-u>" . l:newcmdline  
	  endif
	endfunction
]])

vim.cmd([[cnoremap <expr> <CR> CorrectWritePath()]])

vim.cmd([[nnoremap gb :bn<CR>]])
vim.cmd([[nnoremap gB :bp<CR>]])

-- 自动跳转到上次编辑的位置
vim.api.nvim_create_autocmd("BufReadPost",{
	command = [[
		if line("'\"") > 0 && line("'\"") <= line("$") |
		exe "normal! g`\"" |
		endif
	]]
})
