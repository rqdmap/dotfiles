print('Hello, Markdown!')
vim.o.tabstop		= 2
vim.o.shiftwidth	= 2
vim.o.softtabstop	= 2
vim.cmd([[set noexpandtab]])

local keymap = vim.api.nvim_set_keymap
keymap('n', 'j', 'gj', {noremap = true})
keymap('n', 'k', 'gk', {noremap = true})
keymap('n', '0', 'g0', {noremap = true})
keymap('n', '$', 'g$', {noremap = true})
keymap('n', '^', 'g^', {noremap = true})
