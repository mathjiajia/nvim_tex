return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_install = {
					"bash",
					"bibtex",
					"comment",
					"diff",
					"html",
					"latex",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"vim",
					"vimdoc",
				},
			})
		end,
	},
}
