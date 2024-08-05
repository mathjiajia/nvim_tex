return {

	-- filesype plugin for `LaTeX`
	{ "mathjiajia/latex.nvim", ft = "tex", config = true },

	{ "OXY2DEV/markview.nvim", ft = "markdown" },

	-- Faster LuaLS setup for Neovim
	{ "folke/lazydev.nvim", ft = "lua", config = true },

	-- neorg
	{
		"nvim-neorg/neorg",
		ft = "norg",
		opts = {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.completion"] = { config = { engine = "nvim-cmp" } },
				["core.dirman"] = {
					config = {
						workspaces = { notes = "~/Documents/neorg/notes" },
						default_workspace = "notes",
					},
				},
			},
		},
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
