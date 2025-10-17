return {

	{
		"folke/sidekick.nvim",
		config = true,
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
				layout = { prompt_position = "top" },
			}

			-- stylua: ignore start
			vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Open Files Picker" })
			vim.keymap.set("n", "<leader>fg", function() require("fff").find_in_git_root() end, { desc = "Git Files Picker" })
			vim.keymap.set("n", "<leader>fc", function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end, { desc = "Find Config Files" })
		end,
	},

	-- file explorer
	{
		"A7Lavinraj/fyler.nvim",
		branch = "stable",
		config = function()
			require("fyler").setup({
				default_explorer = true,
				hooks = {
					on_rename = function(src_path, destination_path)
						Snacks.rename.on_rename_file(src_path, destination_path)
					end,
				},
				icon = {
					directory_collapsed = "",
					directory_expanded = "",
					directory_empty = "󰜌",
				},
				win = {
					kind = "split_left",
					kind_presets = { split_left = { width = "0.2rel" } },
					win_opts = {
						number = false,
						relativenumber = false,
					},
				},
			})
			vim.keymap.set("n", "<leader>e", "<Cmd>Fyler<CR>", { desc = "Open File Explorer" })
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

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		commit = "23ae90a2a52fdc9b8c50dc61d6c30ebb18521343",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- stylua: ignore start
				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Hunk" })
				map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Hunk" })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Undo Stage Hunk" })

				map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame Line" })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
				map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { desc = "Diff This (File)" })

				map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "Set qflist (all)" })
				map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set qflist" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })
				-- stylua: ignore end

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk)
			end,
		},
	},
	-- {
	-- 	"nvim-mini/mini.diff",
	-- 	config = function()
	-- 		require("mini.diff").setup({
	-- 			view = {
	-- 				style = "sign",
	-- 				signs = { add = "┃", change = "┃", delete = "_" },
	-- 			},
	-- 		})
	--
	-- 		vim.keymap.set("n", "<leader>hp", function()
	-- 			MiniDiff.toggle_overlay()
	-- 		end, { desc = "Hunk Diff Preview" })
	-- 	end,
	-- },
}
