return {

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		-- build = "make install_jsregexp",
		submodules = false,
		dependencies = "mathjiajia/nvim-math-snippets",
		config = function()
			local ls = require("luasnip")
			local types = require("luasnip.util.types")

			ls.setup({
				update_events = "TextChanged,TextChangedI",
				delete_check_events = "TextChanged",
				enable_autosnippets = true,
				store_selection_keys = "<Tab>",
				ext_opts = {
					[types.insertNode] = { active = { virt_text = { { "", "Boolean" } } } },
					[types.choiceNode] = { active = { virt_text = { { "󱥸", "Special" } } } },
				},
			})

			require("luasnip.loaders.from_lua").lazy_load()

			-- stylua: ignore start
			vim.keymap.set({ "i", "s" }, "<C-;>", function() if ls.choice_active() then ls.change_choice(1) end end, { silent = true })
		end,
	},

	-- auto completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"fang2hou/blink-copilot",
			{ "mikavilpas/blink-ripgrep.nvim", version = "*" },
		},
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local source_dedup_priority = { "lsp", "path", "snippets", "buffer", "ripgrep" }

			local show_orig = require("blink.cmp.completion.list").show
			require("blink.cmp.completion.list").show = function(ctx, items_by_source)
				local seen = {}
				for _, source in ipairs(source_dedup_priority) do
					if items_by_source[source] then
						items_by_source[source] = vim.tbl_filter(function(item)
							local did_seen = seen[item.label]
							seen[item.label] = true
							return not did_seen
						end, items_by_source[source])
					end
				end
				return show_orig(ctx, items_by_source)
			end

			require("blink.cmp").setup({
				completion = {
					documentation = { auto_show = true },
					list = { max_items = 20 },
					menu = { draw = { treesitter = { "lsp" } } },
				},
				snippets = { preset = "luasnip" },
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "ripgrep", "copilot" },
					providers = {
						copilot = { async = true, module = "blink-copilot", name = "Copilot" },
						ripgrep = { module = "blink-ripgrep", name = "Ripgrep" },
						snippets = { opts = { show_autosnippets = false } },
					},
				},
			})
		end,
	},

	-- pairs
	{
		"saghen/blink.pairs",
		version = "*",
		dependencies = "saghen/blink.download",
		opts = {
			highlights = {
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
					"BlinkPairsCyan",
					"BlinkPairsYellow",
					"BlinkPairsGreen",
				},
			},
		},
	},

	-- surround
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		config = true,
		keys = {
			{ "cs", desc = "Change Surrounding" },
			{ "ds", desc = "Delete Surrounding" },
			{ "ys", desc = "Add Surrounding" },
			{ "yS", desc = "Add Surrounding to Current Line" },
			{ "S", mode = "x", desc = "Add Surrounding" },
			{ "gS", mode = "x", desc = "Add Surrounding to Current Line" },
			{ "<C-g>s", mode = "i", desc = "Add Surrounding" },
			{ "<C-g>S", mode = "i", desc = "Add Surrounding to Current Line" },
		},
	},
}
