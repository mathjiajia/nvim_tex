return {

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- style = "storm",
				dim_inactive = true,
				transparent = true,
				terminal_colors = false,
				on_highlights = function(hl, c)
					c.bg_statusline = "NONE"
					hl.StatusLine = { fg = c.fg_sidebar }
					hl.StatusLineNC = { fg = c.fg_gutter }
					hl["@module.latex"] = { fg = c.yellow }
					hl["@label.latex"] = { fg = c.blue }
					hl["@function.latex"] = { fg = c.magenta }
					hl.BlinkPairsBlue = { fg = c.blue }
					hl.BlinkPairsYellow = { fg = c.yellow }
					hl.BlinkPairsGreen = { fg = c.green }
					hl.BlinkPairsTeal = { fg = c.teal }
					hl.BlinkPairsMagenta = { fg = c.magenta }
					hl.BlinkPairsPurple = { fg = c.purple }
					hl.BlinkPairsOrange = { fg = c.orange }
				end,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- statusline
	-- lazy
	{
		"sontungexpt/witch-line",
		opts = {},
	},
	-- {
	-- 	"sschleemilch/slimline.nvim",
	-- 	opts = {
	-- 		components = { center = { "searchcount", "selectioncount" } },
	-- 		configs = { git = { hl = { primary = "Function" } } },
	-- 	},
	-- },

	-- winbar
	{
		"Bekaboo/dropbar.nvim",
		opts = {
			icons = {
				kinds = {
					file_icon = function(path)
						local file_icon = "󰈔 "
						local file_icon_hl = "DropBarIconKindFile"

						local mini_icon, mini_icon_hl = require("mini.icons").get("file", vim.fs.basename(path))

						if not mini_icon then
							local buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
								return vim.api.nvim_buf_get_name(buf) == path
							end)
							if buf then
								local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
								mini_icon, mini_icon_hl = require("mini.icons").get("filetype", filetype)
							end
						end

						file_icon = mini_icon and mini_icon .. " " or file_icon
						file_icon_hl = mini_icon_hl
						return file_icon, file_icon_hl
					end,
				},
			},
		},
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		-- stylua: ignore
		keys = {
			-- Top Pickers & Explorer
			{ "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
			{ "<leader>n",       function() Snacks.picker.notifications() end,         desc = "Notification History" },
			-- find
			{ "<leader>fb",      function() Snacks.picker.buffers() end,               desc = "Buffers" },
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
			{ "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
			{ "<leader>sk",      function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
			{ "<leader>sl",      function() Snacks.picker.loclist() end,               desc = "Location List" },
			{ "<leader>sm",      function() Snacks.picker.marks() end,                 desc = "Marks" },
			{ "<leader>sp",      function() Snacks.picker.lazy() end,                  desc = "Search for Plugin Spec" },
			{ "<leader>sq",      function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
			{ "<leader>sR",      function() Snacks.picker.resume() end,                desc = "Resume" },
			{ "<leader>su",      function() Snacks.picker.undo() end,                  desc = "Undo History" },
			{ "<leader>uC",      function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
			-- LSP
			{ "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
			{ "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
			-- { "gr",              function() Snacks.picker.lsp_references() end,        desc = "References",               nowait = true },
			{ "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
			{ "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
			{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
			{ "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
			-- Other
			{ "<leader>z",       function() Snacks.zen() end,                          desc = "Toggle Zen Mode" },
			{ "<leader>Z",       function() Snacks.zen.zoom() end,                     desc = "Toggle Zoom" },
			{ "<leader>.",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
			{ "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
			{ "<leader>n",       function() Snacks.notifier.show_history() end,        desc = "Notification History" },
			{ "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
			{ "<leader>cR",      function() Snacks.rename.rename_file() end,           desc = "Rename File" },
			{ "<leader>gB",      function() Snacks.gitbrowse() end,                    desc = "Git Browse",               mode = { "n", "v" } },
			{ "<leader>gg",      function() Snacks.lazygit() end,                      desc = "Lazygit" },
			{ "<leader>un",      function() Snacks.notifier.hide() end,                desc = "Dismiss All Notifications" },
		},
		config = function()
			require("snacks").setup({
				input = { enabled = true },
				picker = { win = { input = { keys = { ["<M-d>"] = { "toggle_hidden", mode = { "n", "i" } } } } } },
				styles = {
					lazygit = { width = 0, height = 0 },
				},
			})

			local Snacks = require("snacks")

			-- Called by scooter to open the selected file at the correct line from the scooter search list
			_G.EditLineFromScooter = function(file_path, line)
				local current_path = vim.fn.expand("%:p")
				local target_path = vim.fn.fnamemodify(file_path, ":p")
				if current_path ~= target_path then
					vim.cmd.edit(vim.fn.fnameescape(file_path))
				end
				vim.api.nvim_win_set_cursor(0, { line, 0 })
			end

			-- Opens scooter with the search text populated by the `search_text` arg
			_G.OpenScooterSearchText = function(search_text)
				local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
				Snacks.terminal("scooter --search-text " .. escaped_text, {
					interactive = true,
					auto_close = true,
				})
			end

			vim.keymap.set("n", "<leader>sr", function()
				Snacks.terminal("scooter", { border = "rounded" })
			end, { desc = "Open scooter" })

			vim.keymap.set(
				"v",
				"<leader>sr",
				'"ay<Esc><Cmd>lua OpenScooterSearchText(vim.fn.getreg("a"))<CR>',
				{ desc = "Search selected text in scooter" }
			)
		end,
	},

	-- mini
	{
		"nvim-mini/mini.icons",
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
	},
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
