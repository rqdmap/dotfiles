return {
    "jcdickinson/codeium.nvim",
	enabled = function()
		local hostname = vim.api.nvim_call_function('hostname', {})
		return hostname == 'ArchLinux'
	end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    config = function()
        require("codeium").setup({ })
    end
}


