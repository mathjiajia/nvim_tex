local kind_icons = {
	Array = "",
	Boolean = "",
	Class = "",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Key = "",
	Keyword = "",
	Method = "",
	Module = "",
	Namespace = "",
	Null = "",
	Number = "",
	Object = "",
	Operator = "",
	Package = "",
	Property = "",
	Reference = "",
	Snippet = "",
	String = "",
	Struct = "",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "",

	Component = "󰅴",
	Fragment = "󰅴",
}
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

			require("luasnip.loaders.from_lua").lazy_load({})

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
			appearance = { nerd_font_variant = "normal", kind_icons = kind_icons },
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
						-- 	{ "label", "label_description", gap = 1 },
						-- 	{ "kind_icon", "kind" },
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

	{
		"oskarrrrrrr/symbols.nvim",
		cmd = { "Symbols", "SymbolsToggle", "SymbolsOpen" },
		keys = { { "<leader>cs", "<Cmd>SymbolsToggle<CR>", desc = "Symbols" } },
		config = function()
			local function tex_filter(symbol)
				local kind = symbol.kind
				if kind == "Constant" then
					return false
				end
				return true
			end

			local function lua_filter(symbol)
				local kind = symbol.kind
				local pkind = symbol.parent.kind
				if kind == "Constant" or kind == "Package" then
					return false
				end
				if pkind == "Function" or pkind == "Method" then
					return false
				end
				return true
			end

			local function python_filter(symbol)
				local kind = symbol.kind
				local pkind = symbol.parent.kind
				if (pkind == "Function" or pkind == "Method") and kind ~= "Function" then
					return false
				end
				return true
			end

			local function javascript_filter(symbol)
				local pkind = symbol.parent.kind
				if pkind == "Function" or pkind == "Method" or pkind == "Constructor" then
					return false
				end
				return true
			end

			local r = require("symbols.recipes")

			require("symbols").setup(r.AsciiSymbols, {
				sidebar = {
					symbol_filter = function(ft, symbol)
						if ft == "tex" then
							return tex_filter(symbol)
						end
						if ft == "lua" then
							return lua_filter(symbol)
						end
						if ft == "python" then
							return python_filter(symbol)
						end
						if ft == "javascript" then
							return javascript_filter(symbol)
						end
						if ft == "typescript" then
							return javascript_filter(symbol)
						end
						return true
					end,
				},
				providers = { lsp = { kinds = { default = kind_icons } } },
			})
		end,
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
