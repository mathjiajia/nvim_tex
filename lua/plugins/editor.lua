return {

	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		-- stylua: ignore
		keys = {
			{ "<leader>fe", function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
			{ "<leader>ge", function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end, desc = "Git explorer" },
			{ "<leader>be", function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end, desc = "Buffer explorer" },
		},
		init = function()
			if vim.fn.argc() == 1 then
				---@diagnostic disable-next-line: param-type-mismatch
				local stat = vim.uv.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		opts = {
			open_files_do_not_replace_types = { "aerial", "qf", "terminal" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	},

	-- search/replace in multiple files
	{
		"windwp/nvim-spectre",
		cmd = { "Spectre" },
		opts = { open_cmd = "noswapfile vnew" },
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		-- stylua: ignore
		keys = {
			{ "<leader><space>", function () require('telescope.builtin').find_files({ cwd = "%:p:h" }) end, desc = "Find Files (current)" },
			-- find
			{ "<leader>fb", function () require('telescope.builtin').buffers() end, desc = "Buffers" },
			{ "<leader>fc", function () require('telescope.builtin').find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>ff", function () require('telescope.builtin').find_files() end, desc = "Find Files (cwd)" },
			{ "<leader>fg", function () require('telescope.builtin').git_files() end, desc = "Find Git Files" },
			{ "<leader>fm", function () require('telescope.builtin').builtin() end, desc = "Telescope Meta" },
			{ "<leader>fo", function () require('telescope.builtin').oldfiles() end, desc = "Old Files" },
			-- search
			{ "<leader>sb", function () require('telescope.builtin').current_buffer_fuzzy_find() end, desc = "Current Buf Fuzzy" },
			{ "<leader>sg", function () require('telescope.builtin').live_grep() end, desc = "Live Grep" },
			{ "<leader>sh", function () require('telescope.builtin').help_tags() end, desc = "Help Tags" },
			{ "<leader>sw", function () require('telescope.builtin').grep_string({ word_match = "-w" }) end, desc = "Search Word" },
			{ "<leader>sw", function () require('telescope.builtin').grep_string() end, mode = "v", desc = "Search Selection" },
			-- extensions
			{ "<leader>fd", function() require("telescope").extensions.file_browser.file_browser({ path = "%:p:h" }) end, desc = "File Browser (current)" },
			{ "<leader>fD", function() require("telescope").extensions.file_browser.file_browser() end, desc = "File Browser (cwd)" },
		},
		dependencies = {
			"nvim-telescope/telescope-bibtex.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
					prompt_prefix = "   ",
					selection_caret = " ",
					file_ignore_patterns = { "%.jpeg$", "%.jpg$", "%.png$", ".DS_Store" },
				},
				pickers = {
					buffers = {
						theme = "dropdown",
						sort_lastused = true,
						previewer = false,
					},
					current_buffer_fuzzy_find = { previewer = false },
					find_files = { theme = "ivy", follow = true },
					git_files = { theme = "ivy" },
					grep_string = { path_display = { "shorten" } },
					live_grep = { path_display = { "shorten" } },
				},
				extensions = {
					bibtex = { format = "plain" },
					file_browser = { theme = "ivy" },
				},
			})

			local extns = { "fzf", "file_browser", "bibtex", "noice" }
			for _, extn in ipairs(extns) do
				telescope.load_extension(extn)
			end
		end,
	},

	-- Flash enhances the built-in search functionality by showing labels
	-- at the end of each match, letting you quickly jump to a specific
	-- location.
	{
		"folke/flash.nvim",
		config = true,
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	-- which-key helps you remember key bindings by showing a popup
	-- with the active keybindings of the command you started typing.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup()
			wk.register({
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["ys"] = { name = "+surround" },
				["z"] = { name = "+fold" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>b"] = { name = "+buffer" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+file/find" },
				["<leader>g"] = { name = "+git" },
				["<leader>h"] = { name = "+hunks" },
				["<leader>q"] = { name = "+quit/session" },
				["<leader>s"] = { name = "+search" },
			})
		end,
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
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
				-- stylua: ignore start
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage Hunk" })
				map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset Hunk" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame Line" })
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
				map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { desc = "Diff This (File)" })
				map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle Deleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}
