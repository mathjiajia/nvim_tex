return {

	-- filesype plugin for `LaTeX`
	{
		"mathjiajia/latex.nvim",
		ft = "tex",
		config = true,
	},

	-- inverse serach for LaTeX
	{
		"f3fora/nvim-texlabconfig",
		ft = "tex",
		build = "go build",
		config = true,
	},

	-- {
	-- 	"HakonHarnes/img-clip.nvim",
	-- 	ft = { "markdown", "tex" },
	-- 	config = true,
	-- 	keys = {
	-- 		{
	-- 			"<leader>p",
	-- 			function()
	-- 				require("img-clip").pasteImage()
	-- 			end,
	-- 			desc = "Paste clipboard image",
	-- 		},
	-- 	},
	-- },
}
