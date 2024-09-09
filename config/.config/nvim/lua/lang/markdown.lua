vim.o.tabstop		= 4
vim.o.shiftwidth	= 4
vim.o.softtabstop	= 4
vim.cmd([[set expandtab]])

local keymap = vim.api.nvim_set_keymap
keymap('n', 'j', 'gj', {noremap = true})
keymap('n', 'k', 'gk', {noremap = true})
keymap('n', '0', 'g0', {noremap = true})
keymap('n', '$', 'g$', {noremap = true})
keymap('n', '^', 'g^', {noremap = true})
