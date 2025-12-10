return {
	{
		"tpope/vim-fugitive",
		config = function()
			local keymap = vim.keymap -- for conciseness
			-- Git keybinds / fugitive keybinds
			keymap.set("n", "<leader>go", ":G<CR>") -- open Git view

			keymap.set("n", "<leader>gs", ":Gwrite <CR>") -- git stage
			keymap.set("n", "<leader>gc", ":G commit<CR>") -- git commit
			keymap.set("n", "<leader>gg", ":Gwrite | :G commit<CR>") -- git stage and commit

			keymap.set("n", "<leader>gp", ":G push<CR>") -- git push
			keymap.set("n", "<leader>gl", ":G log --pretty --oneline<CR>") -- git log
			keymap.set("n", "<leader>gi", ":G rebase -i<CR>") -- git rebase
		end,
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		-- stylua: ignore
		keys = {
			-- Top Pickers & Explorer
			{ "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
			{ "<leader>e",       function() Snacks.explorer() end,                     desc = "File Explorer" },
			-- find
			{ "<leader>fb",      function() Snacks.picker.buffers() end,               desc = "Buffers" },
			{ "<leader>fm",      function() Snacks.picker({ layout = "select" }) end,  desc = "Pickers Meta" },
			{ "<leader>fp",      function() Snacks.picker.projects() end,              desc = "Projects" },
			{ "<leader>fr",      function() Snacks.picker.recent() end,                desc = "Recent" },
			-- git
			{ "<leader>gb",      function() Snacks.picker.git_branches() end,          desc = "Git Branches" },
			{ "<leader>gl",      function() Snacks.picker.git_log() end,               desc = "Git Log" },
			{ "<leader>gL",      function() Snacks.picker.git_log_line() end,          desc = "Git Log Line" },
			{ "<leader>gs",      function() Snacks.picker.git_status() end,            desc = "Git Status" },
			{ "<leader>gS",      function() Snacks.picker.git_stash() end,             desc = "Git Stash" },
			{ "<leader>gd",      function() Snacks.picker.git_diff() end,              desc = "Git Diff (Hunks)" },
			{ "<leader>gf",      function() Snacks.picker.git_log_file() end,          desc = "Git Log File" },
			-- Grep
			{ "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
			{ "<leader>sB",      function() Snacks.picker.grep_buffers() end,          desc = "Grep Open Buffers" },
			{ "<leader>sg",      function() Snacks.picker.grep() end,                  desc = "Grep" },
			{ "<leader>sw",      function() Snacks.picker.grep_word() end,             desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			{ '<leader>s"',      function() Snacks.picker.registers() end,             desc = "Registers" },
			{ '<leader>s/',      function() Snacks.picker.search_history() end,        desc = "Search History" },
			{ "<leader>sa",      function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
			{ "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
			{ "<leader>sc",      function() Snacks.picker.command_history() end,       desc = "Command History" },
			{ "<leader>sC",      function() Snacks.picker.commands() end,              desc = "Commands" },
			{ "<leader>sd",      function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
			{ "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
			{ "<leader>sh",      function() Snacks.picker.help() end,                  desc = "Help Pages" },
			{ "<leader>sH",      function() Snacks.picker.highlights() end,            desc = "Highlights" },
			{ "<leader>si",      function() Snacks.picker.icons() end,                 desc = "Icons" },
			{ "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
			{ "<leader>sk",      function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
			{ "<leader>sl",      function() Snacks.picker.loclist() end,               desc = "Location List" },
			{ "<leader>sm",      function() Snacks.picker.marks() end,                 desc = "Marks" },
			{ "<leader>sM",      function() Snacks.picker.man() end,                   desc = "Man Pages" },
			{ "<leader>sp",      function() Snacks.picker.lazy() end,                  desc = "Search for Plugin Spec" },
			{ "<leader>sq",      function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
			{ "<leader>sR",      function() Snacks.picker.resume() end,                desc = "Resume" },
			{ "<leader>su",      function() Snacks.picker.undo() end,                  desc = "Undo History" },
			{ "<leader>uC",      function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
			-- LSP
			{ "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
			{ "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
			-- { "gr",        function() Snacks.picker.lsp_references() end,        desc = "References",               nowait = true },
			{ "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
			{ "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
			{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
			{ "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
			-- Other
			{ "<leader>z",       function() Snacks.zen() end,                          desc = "Toggle Zen Mode" },
			{ "<leader>Z",       function() Snacks.zen.zoom() end,                     desc = "Toggle Zoom" },
			{ "<leader>.",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
			{ "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
			{ "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
			{ "<leader>cR",      function() Snacks.rename.rename_file() end,           desc = "Rename File" },
			{ "<leader>gB",      function() Snacks.gitbrowse() end,                    desc = "Git Browse",               mode = { "n", "v" } },
			-- { "<leader>gg",      function() Snacks.lazygit() end,                      desc = "Lazygit" },
		},
		opts = {
			explorer = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			-- styles = { lazygit = { width = 0, height = 0 } },
		},
	},

	-- mini
	{ "nvim-mini/mini.statusline", config = true },
	{ "nvim-mini/mini.icons", config = true },
	{
		"nvim-mini/mini.hipatterns",
		opts = {
			highlighters = {
				fixme = {
					pattern = "%f[%w]()FIXME()%f[%W]",
					group = "MiniHipatternsFixme",
					extmark_opts = { sign_text = "", sign_hl_group = "DiagnosticError" },
				},
				hack = {
					pattern = "%f[%w]()HACK()%f[%W]",
					group = "MiniHipatternsHack",
					extmark_opts = { sign_text = "", sign_hl_group = "DiagnosticWarn" },
				},
				todo = {
					pattern = "%f[%w]()TODO()%f[%W]",
					group = "MiniHipatternsTodo",
					extmark_opts = { sign_text = "", sign_hl_group = "DiagnosticInfo" },
				},
				note = {
					pattern = "%f[%w]()NOTE()%f[%W]",
					group = "MiniHipatternsNote",
					extmark_opts = { sign_text = "", sign_hl_group = "DiagnosticHint" },
				},
			},
		},
	},
}
