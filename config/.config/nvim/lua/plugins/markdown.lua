-- Todo
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	config = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.keymap.set('n', '<leader>mm', "<Plug>MarkdownPreview")
	end,
	ft = { "markdown" },
}

