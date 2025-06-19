vim.lsp.enable({ "copilot_ls", "lua_ls", "texlab" })

return {

	{ "mason-org/mason.nvim", config = true },

	-- formatting
	{
		"stevearc/conform.nvim",
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			require("conform").setup({
				formatters = {
					["bibtex-tidy"] = {
						prepend_args = {
							"--curly",
							"--tab",
							"--trailing-commas",
							"--sort-fields=author,year,month,day,title,shorttitle",
							"--remove-braces",
						},
					},
				},
				formatters_by_ft = {
					bib = { "bibtex-tidy" },
					markdown = { "prettierd" },
					["markdown.mdx"] = { "prettierd" },
					typescriptreact = { "prettierd" },
					tex = { "tex-fmt" },
				},
				format_on_save = function(bufnr)
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
			})

			vim.keymap.set({ "n", "v" }, "<leader>cF", function()
				require("conform").format({ formatters = { "injected" } })
			end, { desc = "Format Injected Langs" })

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
