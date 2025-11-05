return {

	{
		"saghen/blink.indent",
		commit = "a8feeeae8510d16f26afbb5c81f2ad1ccea38d62",
		opts = {
			scope = {
				highlights = {
					"BlinkIndentOrange",
					"BlinkIndentViolet",
					"BlinkIndentBlue",
					"BlinkIndentCyan",
					"BlinkIndentYellow",
					"BlinkIndentGreen",
				},
			},
		},
	},

	{
		"folke/sidekick.nvim",
		opts = { nes = { enabled = true } },
		-- stylua: ignore
		keys = {
			{
				"<Tab>",
				function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<C-.>",
				function() require("sidekick.cli").toggle() end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Toggle",
			},
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select({ filter = { installed = true } }) end,
				desc = "Sidekick Select CLI",
			},
			{
				"<leader>ad",
				function() require("sidekick.cli").close() end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function() require("sidekick.cli").send({ msg = "{this}" }) end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function() require("sidekick.cli").send({ msg = "{file}" }) end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
		},
	},

	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			require("fff.download").download_or_build_binary()
		end,
		config = function()
			vim.g.fff = {
				lazy_sync = true,
				prompt = "   ",
				layout = { prompt_position = "top" },
			}

			-- stylua: ignore start
			vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Open Files Picker" })
			vim.keymap.set("n", "<leader>fg", function() require("fff").find_in_git_root() end, { desc = "Git Files Picker" })
			vim.keymap.set("n", "<leader>fc", function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end, { desc = "Find Config Files" })
		end,
	},

	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		cmd = { "GrugFar", "GrugFarWithin" },
		opts = { icons = { fileIconsProvider = "mini.icons" } },
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({ prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	-- diff signs
	{
		"nvim-mini/mini.diff",
		config = function()
			require("mini.diff").setup({
				view = {
					style = "sign",
					signs = {
						add = "┃",
						change = "┃",
						delete = "-",
					},
				},
			})
			vim.keymap.set("n", "<leader>hp", function()
				MiniDiff.toggle_overlay()
			end, { desc = "Hunk Diff Preview" })
		end,
	},
}
