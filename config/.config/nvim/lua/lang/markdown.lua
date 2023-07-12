vim.o.tabstop		= 8
vim.o.shiftwidth	= 8
vim.o.softtabstop	= 8
vim.cmd([[set noexpandtab]])

local keymap = vim.api.nvim_set_keymap
keymap('n', 'j', 'gj', {noremap = true})
keymap('n', 'k', 'gk', {noremap = true})
keymap('n', '0', 'g0', {noremap = true})
keymap('n', '$', 'g$', {noremap = true})
keymap('n', '^', 'g^', {noremap = true})
