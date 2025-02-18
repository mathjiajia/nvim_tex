return {

	-- filesype plugin for `LaTeX`
	{ "mathjiajia/nvim-latex-conceal" },

	-- viewing Markdown files in Neovim
	{
		"OXY2DEV/markview.nvim",
		opts = {
			preview = {
				filetypes = { "markdown", "codecompanion" },
				ignore_buftypes = {},
				icon_provider = "mini",
			},
		},
	},
}
