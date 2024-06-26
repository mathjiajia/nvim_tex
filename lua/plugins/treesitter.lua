return {

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
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
					"norg",
					"python",
					"query",
					"regex",
					"vim",
					"vimdoc",
				},
				highlight = { enable = true },
				auto_install = true,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "ts_attach",
				callback = function()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
