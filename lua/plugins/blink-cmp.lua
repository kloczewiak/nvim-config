-- Autocompletion plugin
return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		-- Lua/Neovim dev completions
		"folke/lazydev.nvim",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-y>"] = { "select_and_accept" },
			["<C-x>"] = { "cancel" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			menu = { border = "rounded" },
			documentation = {
				auto_show = true,
				window = { border = "rounded" },
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
	},
}
