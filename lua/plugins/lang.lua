return {

	-- filesype plugin for `LaTeX`
	{
		"pxwg/math-conceal.nvim",
		lazy = true,
		build = "make luajit",
		opts = {
			conceal = {
				"greek",
				"script",
				"math",
				"font",
				"delim",
			},
		},
	},
	{ "mathjiajia/nvim-latex-conceal", dev = true },

	-- viewing Markdown files in Neovim
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion", "quarto" },
		opts = {
			file_types = { "markdown", "codecompanion", "quarto" },
			sign = { enabled = false },
			code = {
				position = "right",
				min_width = 80,
				width = "block",
				border = "thin",
			},
			heading = {
				icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
				border = true,
				render_modes = true,
			},
			pipe_table = {
				alignment_indicator = "─",
				border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
			},
			anti_conceal = {
				disabled_modes = { "n" },
				ignore = {
					code_border = true,
					code_background = true,
					bullet = true,
					head_border = true,
					head_background = true,
				},
			},
			win_options = { concealcursor = { rendered = "nvc" } },
			completions = { lsp = { enabled = true } },
		},
	},
}
