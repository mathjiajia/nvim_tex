return {

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
		dependencies = { "mathjiajia/nvim-math-snippets", dev = true },
		submodules = false,
		config = function()
			local ls = require("luasnip")
			local types = require("luasnip.util.types")

			ls.setup({
				update_events = "TextChanged,TextChangedI",
				delete_check_events = "TextChanged",
				ext_opts = {
					[types.insertNode] = { active = { virt_text = { { "", "Boolean" } } } },
					[types.choiceNode] = { active = { virt_text = { { "󱥸", "Special" } } } },
				},
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
			})

			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/Projects/nvim-math-snippets/luasnippets" })

			-- stylua: ignore start
			vim.keymap.set("i", "<C-k>", function() if ls.expandable() then ls.expand() end end, { desc = "LuaSnip Expand" })
			vim.keymap.set({ "i", "s" }, "<C-;>", function() if ls.choice_active() then ls.change_choice(1) end end,
				{ desc = "LuaSnip Next Choice" })
			-- stylua: ignore end
		end,
	},

	-- auto completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"mikavilpas/blink-ripgrep.nvim",
			"fang2hou/blink-copilot",
			{
				"copilotlsp-nvim/copilot-lsp",
				init = function()
					vim.lsp.enable("copilot_ls")
					vim.keymap.set("n", "<Tab>", function()
						local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
							or (
								require("copilot-lsp.nes").apply_pending_nes()
								and require("copilot-lsp.nes").walk_cursor_end_edit()
							)
					end)
				end,
				lazy = false,
			},
		},
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			keymap = {
				preset = "default",
				["<C-y>"] = {
					"select_and_accept",
					vim.schedule_wrap(function()
						local ls = require("luasnip")
						if ls.expandable() then
							ls.expand()
						end
					end),
				},
				["<C-;>"] = {
					vim.schedule_wrap(function()
						local ls = require("luasnip")
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end),
				},
				["<Tab>"] = {
					function(cmp)
						if vim.b[vim.api.nvim_get_current_buf()].nes_state then
							cmp.hide()
							return (
								require("copilot-lsp.nes").apply_pending_nes()
								and require("copilot-lsp.nes").walk_cursor_end_edit()
							)
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},
			appearance = { nerd_font_variant = "normal" },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = MiniIcons.get("lsp", ctx.kind)
									return kind_icon
								end,
							},
						},
						treesitter = { "lsp" },
					},
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "ripgrep", "copilot" },
				providers = {
					snippets = { opts = { show_autosnippets = false } },
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
					},
					copilot = {
						async = true,
						module = "blink-copilot",
						name = "Copilot",
					},
				},
			},
		},
	},

	-- pairs
	{
		"saghen/blink.pairs",
		version = "*",
		dependencies = "saghen/blink.download",
		opts = {
			mappings = {
				pairs = {
					["`"] = {
						{
							"```",
							"```",
							when = function()
								local cursor = vim.api.nvim_win_get_cursor(0)
								local line = vim.api.nvim_get_current_line()
								return line:sub(cursor[2] - 1, cursor[2]) == "``"
							end,
							filetypes = { "markdown", "vimwiki", "rmarkdown", "rmd", "pandoc", "quarto", "typst" },
						},
						{ "`", "'", filetypes = { "bib", "latex", "tex" } },
						{ "`", enter = false, space = false },
					},
				},
			},
			highlights = {
				groups = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
				matchparen = { enabled = true, group = "MatchParen" },
			},
		},
	},

	-- symbols
	{
		"stevearc/aerial.nvim",
		keys = { { "<leader>cs", "<Cmd>AerialToggle<CR>", desc = "Aerial Symbols" } },
		opts = {
			backends = { "lsp", "treesitter", "markdown", "man" },
			show_guides = true,
			filter_kind = {
				"Array",
				"Boolean",
				"Class",
				-- "Constant",
				"Constructor",
				"Enum",
				"EnumMember",
				"Event",
				"Field",
				"File",
				"Function",
				"Interface",
				"Key",
				"Method",
				"Module",
				"Namespace",
				"Null",
				"Number",
				"Object",
				"Operator",
				-- "Package",
				"Property",
				"String",
				"Struct",
				"TypeParameter",
				"Variable",
			},
		},
	},

	-- surround
	{
		"kylechui/nvim-surround",
		config = true,
		keys = {
			{ "cs", desc = "Change Surrounding" },
			{ "ds", desc = "Delete Surrounding" },
			{ "ys", desc = "Add Surrounding" },
			{ "yS", desc = "Add Surrounding to Current Line" },
			{ "S", mode = { "x" }, desc = "Add Surrounding" },
			{ "gS", mode = { "x" }, desc = "Add Surrounding to Current Line" },
			{ "<C-g>s", mode = { "i" }, desc = "Add Surrounding" },
			{ "<C-g>S", mode = { "i" }, desc = "Add Surrounding to Current Line" },
		},
	},
}
