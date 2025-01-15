return {

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- diagnostic keymaps
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Loclist Diagnostics" })

			-- diagnostics config
			vim.diagnostic.config({
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
			})

			-- lspconfig
			local settings = {
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						hint = { enable = true },
						completion = { callSnippet = "Replace" },
						telemetry = { enable = false },
					},
				},
				texlab = {
					texlab = {
						build = {
							args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
							forwardSearchAfter = false,
							onSave = true,
							pdfDirectory = "./build",
						},
						forwardSearch = {
							executable = "sioyek",
							args = {
								"--reuse-window",
								"--execute-command",
								"turn_on_synctex",
								"--inverse-search",
								"texlab inverse-search -i %%1 -l %%2",
								"--forward-search-file",
								"%f",
								"--forward-search-line",
								"%l",
								"%p",
							},
							-- executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
							-- args = { "-r", "%l", "%p", "%f" },
						},
						diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
					},
				},
			}

			for _, server in pairs(vim.tbl_keys(settings)) do
				require("lspconfig")[server].setup({ settings = settings[server] })
			end
		end,
	},

	{
		"stevearc/aerial.nvim",
		opts = {
			backends = { "lsp", "treesitter", "markdown", "man" },
			show_guides = true,
			filter_kind = false,
		},
		keys = { { "<leader>cs", "<Cmd>AerialToggle<CR>", desc = "Aerial (Symbols)" } },
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"bibtex-tidy",
				"prettierd",
				"texlab",
			},
		},
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					bib = { "bibtex-tidy" },
					markdown = { "prettierd" },
					["markdown.mdx"] = { "prettierd" },
					tex = { "latexindent" },
				},
				formatters = {
					latexindent = {
						prepend_args = { "-c", "./.aux", "-m" },
					},
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
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 500,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>cF", function()
				require("conform").format({ formatters = { "injected" } })
			end, { desc = "Format Injected Langs" })
		end,
	},
}
