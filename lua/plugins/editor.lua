return {

	-- file explorer
	-- {
	-- 	"stevearc/oil.nvim",
	-- 	cmd = "Oil",
	-- 	keys = { { "-", "<Cmd>Oil --float<CR>", desc = "Toggle Oil" } },
	-- 	opts = {
	-- 		delete_to_trash = true,
	-- 		float = {
	-- 			max_width = 0.4,
	-- 			max_height = 0.6,
	-- 			preview_split = "below",
	-- 		},
	-- 		keymaps = {
	-- 			["<C-c>"] = false,
	-- 			["<C-l>"] = false,
	-- 			["<C-h>"] = false,
	-- 			["<C-s>"] = false,
	-- 			["<C-r>"] = "actions.refresh",
	-- 			["<C-x>"] = "actions.select_split",
	-- 			["<C-v>"] = "actions.select_vsplit",
	-- 			["q"] = "actions.close",
	-- 			["y."] = "actions.copy_entry_path",
	-- 		},
	-- 	},
	-- },

	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		opts = {
			icons = { fileIconsProvider = "mini.icons" },
			keymaps = { close = { n = "q" } },
		},
		cmd = "GrugFar",
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

	-- Flash enhances the built-in search functionality by showing labels
	-- at the end of each match, letting you quickly jump to a specific
	-- location.
	{
		"folke/flash.nvim",
		config = function()
			require("flash").setup()

			vim.keymap.set({ "n", "x", "o" }, "s", function()
				require("flash").jump()
			end, { desc = "Flash" })
			vim.keymap.set({ "n", "x", "o" }, "S", function()
				require("flash").treesitter()
			end, { desc = "Flash Treesitter" })
			vim.keymap.set("o", "r", function()
				require("flash").remote()
			end, { desc = "Remote Flash" })
			vim.keymap.set({ "x", "o" }, "R", function()
				require("flash").treesitter_search()
			end, { desc = "Treesitter Search" })
			vim.keymap.set("c", "<C-s>", function()
				require("flash").toggle()
			end, { desc = "Toggle Flash Search" })
		end,
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			diff_opts = {
				internal = true,
				indent_heuristic = true,
				linematch = 60,
			},
			preview_config = { border = "rounded" },
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

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Hunk" })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Undo Stage Hunk" })

				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame Line" })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Diff This (File)" })

				map("n", "<leader>hQ", function()
					gitsigns.setqflist("all")
				end, { desc = "Set qflist (all)" })
				map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set qflist" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
				map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}
