-- Detect tabstop and shiftwidth automatically
return {
	"tpope/vim-sleuth",
	init = function()
		vim.keymap.set("n", "<leader>wi", ":Sleuth<CR>", { desc = "Sleuth - detect [i]ndent size" })
		vim.keymap.set("n", "<leader>wt", ":set ts=2 sw=2 sts=2 expandtab<CR>", { desc = "Set indent size to 2" })
	end,
}
