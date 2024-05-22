return {

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		opts = {
			ensure_install = {
				"bash",
				"bibtex",
				"comment",
				"diff",
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
			auto_install = true,
		},
	},
}
