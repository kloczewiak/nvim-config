return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		-- Added Next.js/React specific parsers
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"javascript",
			"typescript",
			"tsx",
			"css",
			"json",
			"yaml",
		},

		-- Autoinstall languages that are not installed
		auto_install = true,

		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system for indent rules.
			additional_vim_regex_highlighting = { "ruby" },
		},

		indent = {
			enable = true,
			disable = { "ruby" },
		},
	},
}
