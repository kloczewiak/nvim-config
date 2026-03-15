-- Keymaps applied when an LSP attaches to a buffer
local function on_attach_keymaps(event)
	local map = function(keys, func, desc, mode, opts)
		mode = mode or "n"
		vim.keymap.set(
			mode,
			keys,
			func,
			vim.tbl_extend("force", { buffer = event.buf, desc = "LSP: " .. desc }, opts or {})
		)
	end

	local tb = require("telescope.builtin")

	map("gd", tb.lsp_definitions, "[G]oto [D]efinition")
	map("gr", tb.lsp_references, "[G]oto [R]eferences", "n", { nowait = true })
	map("gI", tb.lsp_implementations, "[G]oto [I]mplementation")
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
	map("<leader>ds", tb.lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
end

-- Highlight references under cursor, clear on move
local function on_attach_highlights(event, client)
	if not client or not client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
		return
	end

	local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = event.buf,
		group = hl_group,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		buffer = event.buf,
		group = hl_group,
		callback = vim.lsp.buf.clear_references,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
		callback = function(detach_event)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = detach_event.buf })
		end,
	})
end

-- Toggle inlay hints keymap
local function on_attach_inlay_hints(event, client)
	if not client or not client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		return
	end

	vim.keymap.set("n", "<leader>th", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
	end, { buffer = event.buf, desc = "LSP: [T]oggle Inlay [H]ints" })
end

-- ── Servers ──────────────────────────────────────────────────────────
local servers = {
	-- Lua
	lua_ls = {
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
			},
		},
	},

	-- Python
	pyright = {},

	-- C#
	omnisharp = {},

	-- Web / CSS
	cssls = {},
	css_variables = {},
	cssmodules_ls = {},
	tailwindcss = {},

	-- Web / JS+TS

	-- ts_ls = {}, -- not needed because of typescript-tools.nvim
	eslint = {},
}

-- Formatters & linters (non-LSP tools managed by Mason)
local extra_tools = {
	"stylua",
	"isort",
	"black",
	"prettier",
}

-- ── Plugin specs ─────────────────────────────────────────────────────
return {
	-- lazydev auto-configures lua_ls for your Neovim config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },

	-- Main LSP configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					on_attach_keymaps(event)
					on_attach_highlights(event, client)
					on_attach_inlay_hints(event, client)
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local ensure_installed = vim.list_extend(vim.tbl_keys(servers), extra_tools)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"echasnovski/mini.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
