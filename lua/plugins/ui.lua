return {

	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").load()
		end,
	},

	-- better vim.ui
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- winbar
	{ "Bekaboo/dropbar.nvim", config = true },

	-- statusline
	{ "brianaung/yasl.nvim", config = true },

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
				exclude = {
					filetypes = { "conf", "dashboard", "markdown" },
				},
			})

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},

	-- noicer ui
	{
		"folke/noice.nvim",
		dependencies = { "rcarriga/nvim-notify", cofig = true },
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = { enabled = false },
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
		event = "VimEnter",
		opts = {
			config = {
				week_header = { enable = true },
				disable_move = true,
				shortcut = {
					{ desc = "󰚰 Update", group = "Identifier", action = "Lazy update", key = "u" },
					{ desc = "󰀶 Files", group = "Directory", action = "Telescope find_files", key = "f" },
					{ desc = " Quit", group = "String", action = "quitall", key = "q" },
				},
				project = { limit = 4 },
				mru = { limit = 6, cwd_only = true },
			},
		},
	},

	-- Zen mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		dependencies = { "folke/twilight.nvim", config = true },
		opts = { plugins = { gitsigns = true } },
	},

	-- rainbow delimiters
	{
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false,
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		init = function()
			vim.g.rainbow_delimiters = { query = { latex = "rainbow-delimiters" } }
		end,
	},

	-- icons
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
}
