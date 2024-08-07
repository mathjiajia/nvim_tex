return {

	-- colorschemes
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("tokyonight").setup({ style = "night" })
	-- 		vim.cmd.colorscheme("tokyonight")
	-- 	end,
	-- },
	{
		"ribru17/bamboo.nvim",
		priority = 1000,
		config = function()
			require("bamboo").setup({ transparent = true })
			require("bamboo").load()
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			-- flavour = "latte", -- latte, frappe, macchiato, mocha
	-- 			-- transparent_background = true,
	-- 			term_colors = true,
	-- 			dim_inactive = {
	-- 				enabled = true,
	-- 				shade = "dark",
	-- 				percentage = 0.15,
	-- 			},
	-- 			styles = {
	-- 				comments = { "italic" },
	-- 				conditionals = { "italic" },
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 				operators = {},
	-- 			},
	-- 			integrations = {
	-- 				alpha = false,
	-- 				dap = false,
	-- 				dap_ui = false,
	-- 				diffview = true,
	-- 				markdown = false,
	-- 				neogit = false,
	-- 				nvimtree = false,
	-- 				ufo = false,
	-- 				treesitter_context = false,
	-- 				illuminate = { enabled = false },
	-- 			},
	-- 		})
	--
	-- 		-- setup must be called before loading
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- },

	-- better vim.ui
	{ "stevearc/dressing.nvim", config = true },

	-- winbar
	{ "Bekaboo/dropbar.nvim", config = true },

	-- statuscolumn
	{
		"luukvbaal/statuscol.nvim",
		config = true,
	},

	-- statusline/tabline
	{
		"rebelot/heirline.nvim",
		dependencies = {
			"Zeioth/heirline-components.nvim",
			opts = { icons = { ActiveLSP = "◍" } },
		},
		config = function()
			local heirline = require("heirline")
			local lib = require("heirline-components.all")

			local opts = {
				tabline = { -- UI upper bar
					lib.component.tabline_conditional_padding(),
					lib.component.tabline_buffers(),
					lib.component.fill({ hl = { bg = "tabline_bg" } }),
					lib.component.tabline_tabpages(),
				},
				statusline = { -- UI statusbar
					hl = { fg = "fg", bg = "bg" },
					lib.component.mode(),
					lib.component.git_branch(),
					lib.component.file_info(),
					lib.component.git_diff(),
					lib.component.diagnostics(),
					lib.component.fill(),
					lib.component.cmd_info(),
					lib.component.fill(),
					lib.component.lsp({ lsp_progress = false }),
					lib.component.nav(),
					lib.component.mode({ surround = { separator = "right" } }),
				},
			}

			-- Setup
			lib.init.subscribe_to_events()
			heirline.load_colors(lib.hl.get_colors())
			heirline.setup(opts)

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "HeirlineComponentsTablineBuffersUpdated",
				callback = function()
					if #vim.t.bufs > 1 then
						vim.opt.showtabline = 2
					else
						vim.opt.showtabline = 1
					end
				end,
			})
		end,
	},

	-- indent guides for Neovim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({
				scope = { highlight = highlight },
				exclude = { filetypes = { "conf", "dashboard", "markdown" } },
			})

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},

	-- noicer ui
	{
		"folke/noice.nvim",
		event = { "VeryLazy" },
		dependencies = { "rcarriga/nvim-notify", config = true },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		-- stylua: ignore
		keys = {
			{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
			{ "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
		},
	},

	-- start screen
	{
		"nvimdev/dashboard-nvim",
		opts = {
			config = {
				week_header = { enable = true },
				disable_move = true,
				shortcut = {
					{ desc = "󰚰 Update", group = "Identifier", action = "Lazy update", key = "u" },
					{ desc = "󰀶 Files", group = "Directory", action = "Telescope find_files", key = "f" },
					{
						desc = " Quit",
						group = "String",
						action = function()
							vim.api.nvim_input("<Cmd>qa<CR>")
						end,
						key = "q",
					},
				},
				mru = { cwd_only = true },
			},
		},
	},

	-- rainbow delimiters
	{
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false,
		init = function()
			vim.g.rainbow_delimiters = { query = { latex = "rainbow-delimiters" } }
		end,
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },
}
