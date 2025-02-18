return {

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = "make install_jsregexp",
		dependencies = { "mathjiajia/nvim-math-snippets" },
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
		version = "*",
		dependencies = { "mikavilpas/blink-ripgrep.nvim" },
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
				["<C-l>"] = {
					vim.schedule_wrap(function()
						local ls = require("luasnip")
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end),
				},
			},
			appearance = { nerd_font_variant = "normal" },
			signature = { window = { border = "rounded" } },
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					border = "rounded",
					draw = {
						-- columns = {
						-- 	{ "label",      "label_description", gap = 1 },
						-- 	{ "kind_icon",  "kind" },
						-- 	{ "source_name" },
						-- },
						treesitter = { "lsp" },
					},
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
				providers = {
					snippets = { opts = { show_autosnippets = false } },
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						opts = { additional_rg_options = { "--glob=!*.pdf" } },
					},
				},
			},
		},
	},

	-- auto pairs
	{ "altermo/ultimate-autopair.nvim", event = { "InsertEnter", "CmdlineEnter" }, config = true },

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
