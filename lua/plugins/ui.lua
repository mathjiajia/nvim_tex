return {

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- style = "storm",
				dim_inactive = true,
				-- transparent = true,
				terminal_colors = false,
				on_highlights = function(hl, c)
					hl["@module.latex"] = { fg = "#DCDCAF" }
					hl["@label.latex"] = { fg = "#AADAFA" }
					hl["@function.latex"] = { fg = "#71C6B1" }
					hl.BlinkPairsBlue = { fg = c.blue }
					hl.BlinkPairsYellow = { fg = c.yellow }
					hl.BlinkPairsGreen = { fg = c.green }
					hl.BlinkPairsTeal = { fg = c.teal }
					hl.BlinkPairsMagenta = { fg = c.magenta }
					hl.BlinkPairsPurple = { fg = c.purple }
					hl.BlinkPairsOrange = { fg = c.orange }
					-- hl.BlinkPairsRed = { fg = c.red }
				end,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- statusline
	{
		"sschleemilch/slimline.nvim",
		opts = {
			components = { center = { "searchcount", "selectioncount" } },
			configs = {
				mode = {
					format = {
						["n"] = { short = "NOR" },
						["v"] = { short = "VIS" },
						["V"] = { short = "V-L" },
						["\22"] = { short = "V-B" },
						["s"] = { short = "SEL" },
						["S"] = { short = "S-L" },
						["\19"] = { short = "S-B" },
						["i"] = { short = "INS" },
						["R"] = { short = "REP" },
						["c"] = { short = "CMD" },
						["r"] = { short = "PRO" },
						["!"] = { short = "SHE" },
						["t"] = { short = "TER" },
						["U"] = { short = "UNK" },
					},
				},
				path = { hl = { primary = "Define" } },
				git = { hl = { primary = "Function" } },
				filetype_lsp = {
					hl = { primary = "String" },
					map_lsps = { ["copilot_ls"] = "copilot" },
				},
			},
		},
	},

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
			{ "<leader>:",       function() Snacks.picker.command_history() end,       desc = "Command History" },
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
			{ "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                     desc = "References" },
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
		opts = {
			dashboard = {
				preset = {
					header = [[
██████████████████████████████████████████████████
█████ ████████████████████████████████████████
████   ███  ████████████████  █ ███████████
███     █     █     ██  ████ █ ███
██  █       ██ ██    █        ██
██  ███   █   ██ ██ █   █  █ █  ██
███████ ██    █    ███ █  █████ ██
██████████████████████████████████████████████████]],
					keys = {
						{ action = ":lua require('fff').find_files()", key = "f", hidden = true },
						{ action = ":ene | startinsert", key = "n", hidden = true },
						{ action = ":lua Snacks.picker.grep()", key = "g", hidden = true },
						{ action = ":lua Snacks.picker.recent()", key = "r", hidden = true },
						{
							key = "c",
							action = ":lua require('fff').find_files_in_dir(vim.fn.stdpath('config'))",
							hidden = true,
						},
						{ key = "L", action = ":Lazy", hidden = true },
						{ action = ":qa", key = "q", hidden = true },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys" },
					{
						padding = 2,
						align = "center",
						text = {
							{ " [f]ile ", hl = "BlinkPairsBlue" },
							{ " [n]ew ", hl = "BlinkPairsYellow" },
							{ " [g]rep ", hl = "BlinkPairsGreen" },
							{ " [r]ecent ", hl = "BlinkPairsTeal" },
							{ " [c]onfig ", hl = "BlinkPairsMagenta" },
							{ "󰒲 [L]azy ", hl = "BlinkPairsPurple" },
							{ " [q]uit", hl = "BlinkPairsOrange" },
						},
					},
					{
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
			input = { enabled = true },
			notifier = { enabled = true },
			picker = {
				win = {
					input = {
						keys = {
							["<M-d>"] = { "toggle_hidden", mode = { "n", "i" } },
							["<M-s>"] = { "flash", mode = { "n", "i" } },
							["s"] = { "flash" },
						},
					},
				},
				actions = {
					flash = function(picker)
						require("flash").jump({
							pattern = "^",
							label = { after = { 0, 0 } },
							search = {
								mode = "search",
								exclude = {
									function(win)
										return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
									end,
								},
							},
							action = function(match)
								local idx = picker.list:row2idx(match.pos[1])
								picker.list:_move(idx, true, true)
							end,
						})
					end,
				},
			},
			styles = {
				lazygit = { width = 0, height = 0 },
				notification = { wo = { wrap = true } },
			},
		},
	},

	-- mini
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.icons").setup()

			require("mini.hipatterns").setup({
				highlighters = {
					fixme = {
						pattern = "%f[%w]()FIXME()%f[%W]",
						group = "MiniHipatternsFixme",
						extmark_opts = {
							sign_text = "",
							sign_hl_group = "DiagnosticError",
						},
					},
					hack = {
						pattern = "%f[%w]()HACK()%f[%W]",
						group = "MiniHipatternsHack",
						extmark_opts = {
							sign_text = "",
							sign_hl_group = "DiagnosticWarn",
						},
					},
					todo = {
						pattern = "%f[%w]()TODO()%f[%W]",
						group = "MiniHipatternsTodo",
						extmark_opts = {
							sign_text = "",
							sign_hl_group = "DiagnosticInfo",
						},
					},
					note = {
						pattern = "%f[%w]()NOTE()%f[%W]",
						group = "MiniHipatternsNote",
						extmark_opts = {
							sign_text = "",
							sign_hl_group = "DiagnosticHint",
						},
					},
				},
			})
		end,
	},
}
