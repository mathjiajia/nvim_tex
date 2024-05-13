return {

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neodev.nvim", config = true, ft = { "lua", "vim" } },
		},
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

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "texlab" },
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									workspace = { checkThirdParty = false },
									hint = { enable = true },
									completion = { callSnippet = "Replace" },
									telemetry = { enable = false },
								},
							},
						})
					end,

					["texlab"] = function()
						local pdf_executable
						local forward_search_args

						if vim.uv.os_uname().sysname == "Darwin" then
							pdf_executable = "sioyek"
							forward_search_args = {
								"--reuse-window",
								"--execute-command",
								"toggle_synctex", -- "turn_on_synctex", -- Open Sioyek in synctex mode.
								"--inverse-search",
								vim.fn.stdpath("data") .. "/mason/bin/texlab inverse-search --input %%1 --line %%2",
								"--forward-search-file",
								"%f",
								"--forward-search-line",
								"%l",
								"%p",
							}
							-- pdf_executable = "/Applications/Skim.app/Contents/SharedSupport/displayline"
							-- forward_search_args = { "%l", "%p", "%f" }
						elseif vim.uv.os_uname().sysname == "Linux" then
							pdf_executable = "zathura"
							forward_search_args = {
								"--synctex-editor-command",
								vim.fn.stdpath("data") .. "/mason/bin/texlab inverse-search --input %%1 --line %%2",
								"--synctex-forward",
								"%l:1:%f",
								"%p",
							}
						end

						require("lspconfig").texlab.setup({
							capabilities = capabilities,
							filetypes = { "tex", "bib" },
							settings = {
								texlab = {
									build = {
										forwardSearchAfter = false,
										executable = "latexmk",
										args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
										onSave = true,
									},
									forwardSearch = {
										executable = pdf_executable,
										args = forward_search_args,
									},
									chktex = { onOpenAndSave = false },
									diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
									latexFormatter = "none",
									bibtexFormatter = "latexindent",
								},
							},
						})
					end,
				},
			})
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = {
					"bibtex-tidy",
					"latexindent",
					"prettierd",
					"stylua",
				},
			},
		},
		opts = { ui = { border = "rounded", height = 0.8 } },
	},
}
