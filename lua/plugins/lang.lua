return {

	-- filesype plugin for `LaTeX`
	{
		"pxwg/math-conceal.nvim",
		build = "make luajit",
		main = "math-conceal",
		config = true,
	},

	-- { "mathjiajia/nvim-latex-conceal", dev = true },

	-- {
	-- 	"mathjiajia/latex_concealer.nvim",
	-- 	dev = true,
	-- 	ft = { "tex", "latex" },
	-- 	config = true,
	-- },

	-- viewing Markdown files in Neovim
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	opts = {
	-- 		code = { width = "block" },
	-- 		latex = { enabled = false },
	-- 		pipe_table = { preset = "round" },
	-- 		win_options = {
	-- 			colorcolumn = {
	-- 				default = "120",
	-- 				rendered = "",
	-- 			},
	-- 		},
	-- 	},
	-- },
}
