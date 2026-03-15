return {
	{
		-- Typescript plugin
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				jsx_close_tag = {
					enable = true,
					filetypes = { "javascriptreact", "typescriptreact" },
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "typescript", "typescriptreact" },
				callback = function()
					require("which-key").add({
						{ "<leader>T", group = "[T]ypeScript", mode = "n" },
					}, { buffer = 0 })

					local ts = require("typescript-tools.api")
					local opts = { buffer = true, noremap = true, silent = true }

					vim.keymap.set(
						"n",
						"<leader>To",
						ts.organize_imports,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript [o]rganize imports" })
					)
					vim.keymap.set(
						"n",
						"<leader>Ts",
						ts.sort_imports,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript [s]ort imports" })
					)
					vim.keymap.set(
						"n",
						"<leader>Tr",
						ts.remove_unused_imports,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript [r]emove unused imports" })
					)
					vim.keymap.set(
						"n",
						"<leader>Ta",
						ts.add_missing_imports,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript [a]dd missing imports" })
					)
					vim.keymap.set(
						"n",
						"<leader>Tu",
						ts.remove_unused,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript remove [u]nused statements" })
					)
					vim.keymap.set(
						"n",
						"<leader>Tf",
						ts.fix_all,
						vim.tbl_extend("keep", opts, { desc = "[T]ypeScript [f]ix all" })
					)
				end,
			})
		end,
	},
	{
		-- Uses correct comments for most file types
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			enable_autocmd = false,
		},
		config = function()
			local get_option = vim.filetype.get_option
			--- @diagnostic disable-next-line: duplicate-set-field
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or get_option(filetype, option)
			end
		end,
	},
}
