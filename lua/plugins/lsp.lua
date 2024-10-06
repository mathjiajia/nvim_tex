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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
								vim.fn.stdpath("data") .. "/mason/bin/texlab inverse-search -i %%1 -l %%2",
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
				require("lspconfig")[server].setup({
					capabilities = capabilities,
					settings = settings[server],
				})
			end
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		opts = { ui = { border = "rounded", height = 0.8 } },
		-- dependencies = {
		-- 	"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- 	opts = {
		-- 		ensure_installed = {
		-- 			-- lsp
		-- 			"lua-language-server",
		-- 			"texlab",
		-- 			-- formatter
		-- 			"bibtex-tidy",
		-- 			"latexindent",
		-- 			"prettierd",
		-- 			"stylua",
		-- 		},
		-- 	},
		-- },
	},

	-- lsp enhancement
	{
		"nvimdev/lspsaga.nvim",
		event = { "LspAttach" },
		-- stylua: ignore
		keys = { { "<M-g>", function() require("lspsaga.floaterm"):open_float_terminal({ "lazygit" }) end, mode = { "n", "t" }, desc = "LazyGit" } },
		config = function()
			require("lspsaga").setup({
				symbol_in_winbar = { enable = false },
				lightbulb = { enable = false },
				outline = { auto_preview = false },
				floaterm = { height = 1, width = 1 },
			})

			vim.keymap.set("n", "gh", function()
				require("lspsaga.finder"):new({})
			end, { desc = "Lsp Finder" })

			vim.keymap.set("n", "<M-o>", function()
				require("lspsaga.symbol"):outline()
			end, { desc = "Lspsaga Outline" })
		end,
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
					lua = { "stylua" },
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
