return {

	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", config = true, ft = { "lua", "vim" } },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		config = function()
			-- diagnostic keymaps
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Float Diagnostics" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostics" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostics" })
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

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							hint = { enable = true },
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
						},
					},
				},
				matlab_ls = {},
				texlab = {
					settings = {
						texlab = {
							build = {
								-- forwardSearchAfter = true,
								args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
								onSave = true,
							},
							forwardSearch = {
								executable = "sioyek",
								args = {
									"--reuse-window",
									"--execute-command",
									"toggle_synctex", -- "turn_on_synctex", -- Open Sioyek in synctex mode.
									"--inverse-search",
									vim.fn.stdpath("data")
										.. [[/lazy/nvim-texlabconfig/nvim-texlabconfig -file %%%1 -line %%%2 -server ]]
										.. vim.v.servername,
									"--forward-search-file",
									"%f",
									"--forward-search-line",
									"%l",
									"%p",
								},
								-- executable = "zathura",
								-- args = {
								-- 	"--synctex-editor-command",
								-- 	vim.fn.stdpath("data")
								-- 		.. [[/lazy/nvim-texlabconfig/nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]]
								-- 		.. vim.v.servername,
								-- 	"--synctex-forward",
								-- 	"%l:1:%f",
								-- 	"%p",
								-- },
								-- executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
								-- args = { "%l", "%p", "%f" },
							},
							chktex = { onOpenAndSave = false },
							diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
							latexFormatter = "none",
							bibtexFormatter = "latexindent",
						},
					},
				},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				handlers = {
					function(server)
						local opts = servers[server]
						opts.capabilities = capabilities
						require("lspconfig")[server].setup(opts)
					end,
				},
			})
		end,
	},

	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local tools = {
				"commitlint",
				-- "latexindent",
				"markdownlint-cli2",
				"prettierd",
				"stylua",
			}
			local function ensure_installed()
				for _, tool in ipairs(tools) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
