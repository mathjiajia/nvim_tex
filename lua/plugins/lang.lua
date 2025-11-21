return {

	{
		"Julian/lean.nvim",
		event = { "BufReadPre *.lean", "BufNewFile *.lean" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { mappings = true },
	},

	-- filesype plugin for `LaTeX`
	{ "mathjiajia/nvim-latex-conceal" },
	-- {
	-- 	"dirichy/nvimtex.nvim",
	-- 	ft = { "tex", "latex" },
	-- 	config = true,
	-- },
	-- {
	-- 	"dirichy/latex_concealer.nvim",
	-- 	ft = { "tex", "latex" },
	-- 	config = true,
	-- },
	-- {
	-- 	"pxwg/math-conceal.nvim",
	-- 	build = "make luajit",
	-- 	opts = { conceal = { "greek", "script", "math", "font", "delim" } },
	-- },

	-- viewing Markdown files in Neovim
	-- { "yousefhadder/markdown-plus.nvim", ft = "markdown" },

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "quarto" },
		opts = {
			file_types = { "markdown", "quarto" },
			anti_conceal = {
				disabled_modes = { "n" },
				ignore = {
					bullet = true,
					code_border = true,
					head_background = true,
					head_border = true,
				},
			},
			completions = { lsp = { enabled = true } },
			heading = {
				render_modes = true,
				icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
				border = true,
			},
			code = {
				position = "right",
				width = "block",
				min_width = 80,
				border = "thin",
			},
			pipe_table = {
				alignment_indicator = "─",
				border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
			},
			sign = { enabled = false },
			win_options = { concealcursor = { rendered = "nvc" } },
		},
	},
}
