return {
	{
		"akinsho/toggleterm.nvim",
		opts = {
			-- <C-_> for Windows
			-- <C-/> for MacOS
			-- because Control forwardslash on windows reports as <C-_> for some reason
			open_mapping = { "<C-_>", "<C-/>" },
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			require("tools.lazygit").setup()
			require("tools.claudecode").setup()
		end,
	},
}
