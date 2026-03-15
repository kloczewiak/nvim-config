local M = {}
local Terminal = require("toggleterm.terminal").Terminal

function M.setup()
	local lazygit = Terminal:new({
		cmd = "lazygit",
		dir = "git_dir",
		hidden = true,
		direction = "float",
		float_opts = {
			border = "curved",
			width = function()
				return math.floor(vim.o.columns * 0.8)
			end,
			height = function()
				return math.floor(vim.o.lines * 0.8)
			end,
		},
		on_open = function(term)
			vim.bo[term.bufnr].modifiable = false
			vim.bo[term.bufnr].readonly = true
			vim.cmd("startinsert!")
			vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr, nowait = true })
		end,
	})

	vim.keymap.set("n", "<leader>g", function()
		lazygit:toggle()
	end, { desc = "Toggle Lazy[G]it" })
end

return M
