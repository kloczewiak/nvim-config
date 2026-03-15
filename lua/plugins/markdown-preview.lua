return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.keymap.set("n", "<leader>tm", ":MarkdownPreviewToggle<CR>", { desc = "[T]oggle [M]arkdown Preview" })
		end,
		ft = { "markdown" },
	},
}
