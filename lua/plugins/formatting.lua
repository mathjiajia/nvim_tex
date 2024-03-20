return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" } })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			require("util").format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end,
		opts = {
			formatters_by_ft = {
				bib = { "bibtex-tidy" },
				markdown = { "prettierd", "injected" },
				["markdown.mdx"] = { "prettierd", "injected" },
				lua = { "stylua" },
				tex = { "latexindent" },
			},
		},
	},
}
