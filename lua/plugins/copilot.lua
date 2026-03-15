return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					keymap = {
						open = "<M-/>",
					},
					layout = {
						position = "right",
						ratio = 0.4,
					},
				},
				suggestion = {
					auto_trigger = true,
					hide_during_completion = false,
					keymap = {
						accept = "<M-CR>",
						accept_word = "<M-l>",
						accept_line = "<M-j>",
					},
				},
			})
		end,
		init = function()
			vim.keymap.set("n", "<leader>tc", function()
				require("copilot.suggestion").toggle_auto_trigger()
			end, { desc = "[T]oggle [C]opilot Suggestions" })
		end,
	},
}
