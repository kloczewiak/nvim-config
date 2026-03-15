local M = {}
local Terminal = require("toggleterm.terminal").Terminal

function M.setup()
	local width = math.floor(vim.o.columns * 0.4)

	local claudecode = Terminal:new({
		cmd = "claude",
		hidden = true,
		direction = "vertical",
		on_open = function(term)
			vim.keymap.set("t", "<C-;>", function()
				vim.cmd(term.id .. "ToggleTerm")
			end, { buffer = term.bufnr, nowait = true })
		end,
		on_close = function(term)
			width = vim.api.nvim_win_get_width(term.window)
		end,
	})

	vim.keymap.set("n", "<C-;>", function()
		local opening = not claudecode:is_open()
		claudecode:toggle(width)
		if opening then
			vim.schedule(function()
				vim.cmd("startinsert!")
			end)
		end
	end, { desc = "Toggle [C]laude Code" })

	-- Pass current file to claudecode with @ reference
	vim.keymap.set("n", "<leader>cf", function()
		local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		if file_path == "" then
			print("No file to reference")
			return
		end

		claudecode:open(width)
		vim.schedule(function()
			vim.api.nvim_put({ "@" .. file_path .. "\n" }, "c", true, true)
			vim.cmd("startinsert!")
		end)
	end, { desc = "[C]laude [F]ile Reference" })

	-- File and line reference for visual mode
	vim.keymap.set("x", "<leader>cf", function()
		local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		if file_path == "" then
			print("No file to reference")
			return
		end

		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")

		-- Ensure correct order
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		local ref = "@" .. file_path .. ":" .. start_line .. "-" .. end_line .. "\n"

		claudecode:open(width)
		vim.schedule(function()
			vim.cmd("startinsert!")
			vim.api.nvim_put({ ref }, "c", true, true)
		end)
	end, { desc = "[C]laude [F]ile Reference with Lines" })

	vim.defer_fn(function()
		claudecode:open(width)
		claudecode:close()
	end, 200)
end

return M
