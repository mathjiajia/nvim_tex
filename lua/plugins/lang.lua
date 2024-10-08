return {

	-- filesype plugin for `LaTeX`
	{ "mathjiajia/latex.nvim", ft = "tex", config = true },

	-- viewing Markdown files in Neovim
	{ "OXY2DEV/markview.nvim", config = true },

	-- Faster LuaLS setup for Neovim
	-- { "folke/lazydev.nvim", ft = "lua", config = true },

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
