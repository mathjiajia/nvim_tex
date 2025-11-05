return {

	{
		"saxon1964/neovim-tips",
		version = "*",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = { "NeovimTips" },
		config = true,
	},

	-- {
	-- 	"Julian/lean.nvim",
	-- 	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	opts = { mappings = true },
	-- },

	-- filesype plugin for `LaTeX`
	"mathjiajia/nvim-latex-conceal",
	-- {
	-- 	"pxwg/math-conceal.nvim",
	-- 	build = "make luajit",
	-- 	opts = { conceal = { "greek", "script", "math", "font", "delim" } },
	-- },

	-- viewing Markdown files in Neovim
	-- { "yousefhadder/markdown-plus.nvim", ft = "markdown" },

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
