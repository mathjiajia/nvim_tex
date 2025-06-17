return {

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- style = "moon",
				-- dim_inactive = true,
				-- transparent = true,
				terminal_colors = false,
				plugins = {
					all = false,
					auto = false,
					aerial = true,
					blink = true,
					dap = true,
					flash = true,
					gitsigns = true,
					["grug-far"] = true,
					mini_diff = true,
					mini_hipatterns = true,
					mini_icons = true,
					rainbow = true,
					["render-markdown"] = true,
					snacks = true,
					treesitter_context = true,
				},
			})
			vim.cmd.colorscheme("tokyonight")
		end,
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

						local mini_icon, mini_icon_hl = MiniIcons.get("file", vim.fs.basename(path))

						if not mini_icon then
							local buf = vim.iter(vim.api.nvim_list_bufs()):find(function(buf)
								return vim.api.nvim_buf_get_name(buf) == path
							end)
							if buf then
								local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
								mini_icon, mini_icon_hl = MiniIcons.get("filetype", filetype)
							end
						end

						file_icon = mini_icon and mini_icon .. " " or file_icon
						file_icon_hl = mini_icon_hl
						return file_icon, file_icon_hl
					end,
				},
			},
			sources = {
				path = {
					modified = function(sym)
						return sym:merge({
							name = sym.name .. "[+]",
							name_hl = "DiffAdded",
						})
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
			{ "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
			{ "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
			{ "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
			{ "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
			{ "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
			-- find
			{ "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
			{ "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
			{ "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
			{ "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
			{ "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
			-- git
			{ "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
			{ "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
			{ "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
			{ "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
			{ "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
			{ "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
			{ "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
			-- Grep
			{ "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
			{ "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
			{ "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
			{ "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			{ '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
			{ '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
			{ "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
			{ "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
			{ "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
			{ "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
			{ "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
			{ "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
			{ "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
			{ "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
			{ "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
			{ "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
			{ "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
			{ "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
			{ "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
			{ "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
			{ "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
			{ "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
			{ "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
			{ "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
			{ "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
			-- LSP
			{ "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
			{ "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
			{ "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
			{ "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
			{ "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
			{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
			{ "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
			-- Other
			{ "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
			{ "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
			{ "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
			{ "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
			{ "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
			{ "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
			{ "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
			{ "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
			{ "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
			{ "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
		},
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = [[
██████████████████████████████████████████████████
█████ ████████████████████████████████████████
████   ███  ████████████████  █ ███████████
███     █     █     ██  ████ █ ███
██  █       ██ ██    █        ██
██  ███   █   ██ ██ █   █  █ █  ██
███████ ██    █    ███ █  █████ ██
██████████████████████████████████████████████████
]],
					keys = {
						{ action = ":lua Snacks.picker.files()", desc = "Find File", icon = " ", key = "f" },
						{ action = ":ene | startinsert", desc = "New File", icon = " ", key = "n" },
						{ action = ":lua Snacks.picker.grep()", desc = "Find Text", icon = " ", key = "g" },
						{ action = ":lua Snacks.picker.recent()", desc = "Recent Files", icon = " ", key = "r" },
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
						{ action = ":qa", desc = "Quit", icon = " ", key = "q" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys",  gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 300,
						indent = 2,
					},
					{ section = "startup" },
				},
			},
			image = {
				enabled = not vim.g.neovide,
				math = { enabled = false },
			},
			indent = {
				scope = {
					hl = {
						"RainbowDelimiterRed",
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
					},
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
			scroll = { enabled = not vim.g.neovide },
			scope = { enabled = true },
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
			require("mini.icons").setup({
				lsp = {
					copilot = { glyph = "" },
					["function"] = { glyph = "" },
					object = { glyph = "" },
					value = { glyph = "" },
				},
			})

			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
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

					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},

	-- statusline
	{
		"rebelot/heirline.nvim",
		config = function()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local colors = {
				bright_bg = utils.get_highlight("Folded").bg,
				bright_fg = utils.get_highlight("Folded").fg,
				red = utils.get_highlight("DiagnosticError").fg,
				dark_red = utils.get_highlight("DiffDelete").bg,
				green = utils.get_highlight("String").fg,
				blue = utils.get_highlight("Function").fg,
				gray = utils.get_highlight("NonText").fg,
				orange = utils.get_highlight("Constant").fg,
				purple = utils.get_highlight("Statement").fg,
				cyan = utils.get_highlight("Special").fg,
				diag_warn = utils.get_highlight("DiagnosticWarn").fg,
				diag_error = utils.get_highlight("DiagnosticError").fg,
				diag_hint = utils.get_highlight("DiagnosticHint").fg,
				diag_info = utils.get_highlight("DiagnosticInfo").fg,
				git_del = utils.get_highlight("GitSignsDelete").fg,
				git_add = utils.get_highlight("GitSignsAdd").fg,
				git_change = utils.get_highlight("GitSignsChange").fg,
			}

			local VimMode = {
				init = function(self)
					self.mode = vim.fn.mode(1)
					self.mode_color = self.mode_colors[self.mode:sub(1, 1)]
				end,
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd.redrawstatus()
					end),
				},
				static = {
					mode_names = {
						n = "NORMAL",
						no = "NORMAL",
						nov = "NORMAL",
						noV = "NORMAL",
						["no\22"] = "NORMAL",
						niI = "NORMAL",
						niR = "NORMAL",
						niV = "NORMAL",
						nt = "NORMAL",
						v = "VISUAL",
						vs = "VISUAL",
						V = "VISUAL",
						Vs = "VISUAL",
						["\22"] = "VISUAL",
						["\22s"] = "VISUAL",
						s = "SELECT",
						S = "SELECT",
						["\19"] = "SELECT",
						i = "INSERT",
						ic = "INSERT",
						ix = "INSERT",
						R = "REPLACE",
						Rc = "REPLACE",
						Rx = "REPLACE",
						Rv = "REPLACE",
						Rvc = "REPLACE",
						Rvx = "REPLACE",
						c = "COMMAND",
						cv = "Ex",
						r = "...",
						rm = "M",
						["r?"] = "?",
						["!"] = "!",
						t = "TERM ",
					},
					mode_colors = {
						n = "purple",
						i = "green",
						v = "orange",
						V = "orange",
						["\22"] = "orange",
						c = "orange",
						s = "yellow",
						S = "yellow",
						["\19"] = "yellow",
						r = "green",
						R = "green",
						["!"] = "red",
						t = "red",
					},
				},
				{
					provider = function(self)
						return "  %2(" .. self.mode_names[self.mode] .. "%)"
					end,
					hl = function(self)
						return { fg = "#222436", bg = self.mode_color }
					end,
				},
				{
					provider = "",
					hl = function(self)
						return { fg = self.mode_color }
					end,
				},
			}

			local FileIcon = {
				init = function(self)
					local filename = self.filename
					self.icon, self.icon_hl = MiniIcons.get("file", filename)
				end,
				provider = function(self)
					return self.icon and (self.icon .. " ")
				end,
				hl = function(self)
					return self.icon_hl
				end,
			}

			local FileName = {
				provider = function(self)
					local filename = vim.fn.fnamemodify(self.filename, ":.")
					if filename == "" then
						return "[No Name]"
					end
					if not conditions.width_percent_below(#filename, 0.25) then
						filename = vim.fn.pathshorten(filename)
					end
					return filename
				end,
				hl = { fg = utils.get_highlight("Directory").fg },
			}

			local WorkDir = {
				provider = function()
					local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. "  "
					local cwd = vim.fn.getcwd(0)
					cwd = vim.fn.fnamemodify(cwd, ":~")
					cwd = vim.fn.pathshorten(vim.fn.fnamemodify(cwd, ":~"))
					local trail = cwd:sub(-1) == "/" and "" or "/"
					return icon .. cwd .. trail
				end,
				hl = { fg = "blue" },
			}

			local Git = {
				condition = conditions.is_git_repo,
				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0
							or self.status_dict.removed ~= 0
							or self.status_dict.changed ~= 0
				end,
				hl = { fg = "orange" },
				{
					provider = function(self)
						return "  " .. self.status_dict.head
					end,
				},
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and ("  " .. count)
					end,
					hl = { fg = "git_add" },
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and ("  " .. count)
					end,
					hl = { fg = "git_del" },
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and ("  " .. count)
					end,
					hl = { fg = "git_change" },
				},
			}

			local Diagnostics = {
				condition = conditions.has_diagnostics,
				static = { Error = " ", Warn = " ", Hint = " ", Info = " " },
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,
				update = { "DiagnosticChanged", "BufEnter" },
				{ provider = "![" },
				{
					provider = function(self)
						return self.errors > 0 and (self.Error .. self.errors .. " ")
					end,
					hl = { fg = "diag_error" },
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.Warn .. self.warnings .. " ")
					end,
					hl = { fg = "diag_warn" },
				},
				{
					provider = function(self)
						return self.info > 0 and (self.Info .. self.info .. " ")
					end,
					hl = { fg = "diag_info" },
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.Hint .. self.hints)
					end,
					hl = { fg = "diag_hint" },
				},
				{ provider = "]" },
			}

			local LSPActive = {
				condition = conditions.lsp_attached,
				update = { "LspAttach", "LspDetach" },
				provider = function()
					local names = {}
					for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
						table.insert(names, server.name)
					end
					return "[" .. table.concat(names, ",") .. "]"
				end,
				hl = { fg = "green" },
			}

			local Ruler = {
				{ provider = "", hl = { fg = "gray" } },
				{ provider = " %7(%l/%3L%):%2c ", hl = { bg = "gray" } },
			}

			local FileType = {
				provider = function()
					return string.upper(vim.bo.filetype)
				end,
				hl = { fg = "yellow", bold = true },
			}

			local SearchCount = {
				condition = function()
					return vim.v.hlsearch ~= 0
				end,
				init = function(self)
					local ok, search = pcall(vim.fn.searchcount)
					if ok and search.total then
						self.search = search
					end
				end,
				provider = function(self)
					local search = self.search
					return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
				end,
			}

			local MacroRec = {
				condition = function()
					return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
				end,
				provider = " ",
				hl = { fg = "orange", bold = true },
				utils.surround({ "[", "]" }, nil, {
					provider = function()
						return vim.fn.reg_recording()
					end,
					hl = { fg = "green", bold = true },
				}),
				update = {
					"RecordingEnter",
					"RecordingLeave",
				},
			}

			local TerminalName = {
				provider = function()
					local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
					return " " .. tname
				end,
				hl = { fg = "blue" },
			}

			local HelpFileName = {
				condition = function()
					return vim.bo.filetype == "help"
				end,
				provider = function()
					local filename = vim.api.nvim_buf_get_name(0)
					return vim.fn.fnamemodify(filename, ":t")
				end,
				hl = { fg = colors.blue },
			}

			local Align = { provider = "%=" }

			local Space = { provider = " " }

			local DefaultStatusline = {
				VimMode,
				Space,
				WorkDir,
				Git,
				Align,
				SearchCount,
				MacroRec,
				Align,
				Diagnostics,
				LSPActive,
				Space,
				Ruler,
				-- Space,
				-- ScrollBar,
				-- Space,
				-- Spell,
			}

			local InactiveStatusline = {
				condition = conditions.is_not_active,
				Space,
				FileType,
				Space,
				FileName,
				Align,
			}

			local SpecialStatusline = {
				condition = function()
					return conditions.buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix", "snacks_input" },
						filetype = { "^git.*", "fugitive" },
					})
				end,
				Space,
				FileType,
				Space,
				HelpFileName,
				Align,
			}

			local TerminalStatusline = {
				condition = function()
					return conditions.buffer_matches({ buftype = { "terminal" } })
				end,
				hl = { bg = "dark_red" },
				{ condition = conditions.is_active, VimMode, Space },
				FileType,
				Space,
				TerminalName,
				Align,
			}

			local StatusLine = {
				fallthrough = false,
				SpecialStatusline,
				TerminalStatusline,
				InactiveStatusline,
				DefaultStatusline,
				hl = "StatusLine",
			}

			-- Tabline
			local TablineBufnr = {
				provider = function(self)
					return tostring(self.bufnr) .. ". "
				end,
				hl = "Comment",
			}

			local TablineFileName = {
				provider = function(self)
					local filename = self.filename
					filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
					return filename
				end,
				hl = function(self)
					return { bold = self.is_active or self.is_visible, italic = true }
				end,
			}

			local TablineFileFlags = {
				{
					condition = function(self)
						return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
					end,
					provider = " ● ", --[+]",
					hl = { fg = "green" },
				},
				{
					condition = function(self)
						return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
								or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
					end,
					provider = function(self)
						if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
							return "  "
						else
							return ""
						end
					end,
					hl = { fg = "orange" },
				},
			}

			local TablineFileNameBlock = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(self.bufnr)
				end,
				hl = function(self)
					if self.is_active then
						return "TabLineSel"
					elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
						return { fg = "gray" }
					else
						return "TabLine"
					end
				end,
				on_click = {
					callback = function(_, minwid, _, button)
						if button == "m" then
							vim.schedule(function()
								Snacks.bufdelete({ buf = minwid })
							end)
						else
							vim.api.nvim_win_set_buf(0, minwid)
						end
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_buffer_callback",
				},
				TablineBufnr,
				FileIcon,
				TablineFileName,
				TablineFileFlags,
			}

			local TablineCloseButton = {
				condition = function(self)
					return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				{ provider = " " },
				{
					provider = "✗",
					hl = { fg = "gray" },
					on_click = {
						callback = function(_, minwid)
							vim.schedule(function()
								Snacks.bufdelete({ buf = minwid })
								vim.cmd.redrawtabline()
							end)
						end,
						minwid = function(self)
							return self.bufnr
						end,
						name = "heirline_tabline_close_buffer_callback",
					},
				},
			}

			local TablineBufferBlock = utils.surround({ "█", "█" }, function(self)
				if self.is_active then
					return utils.get_highlight("TabLineSel").bg
				else
					return utils.get_highlight("TabLine").bg
				end
			end, { TablineFileNameBlock, TablineCloseButton })

			local get_bufs = function()
				return vim.tbl_filter(function(bufnr)
					return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
				end, vim.api.nvim_list_bufs())
			end

			local buflist_cache = {}

			vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						local buffers = get_bufs()
						for i, v in ipairs(buffers) do
							buflist_cache[i] = v
						end
						for i = #buffers + 1, #buflist_cache do
							buflist_cache[i] = nil
						end
						if #buflist_cache > 1 then
							vim.o.showtabline = 2
						elseif vim.o.showtabline ~= 1 then
							vim.o.showtabline = 1
						end
					end)
				end,
			})

			local BufferLine = utils.make_buflist(
				TablineBufferBlock,
				{ provider = " ", hl = { fg = "gray" } },
				{ provider = " ", hl = { fg = "gray" } },
				function()
					return buflist_cache
				end,
				false
			)

			local Tabpage = {
				provider = function(self)
					return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
				end,
				hl = function(self)
					if not self.is_active then
						return "TabLine"
					else
						return "TabLineSel"
					end
				end,
			}

			local TabpageClose = { provider = " %999X %X", hl = "TabLine" }

			local TabPages = {
				condition = function()
					return #vim.api.nvim_list_tabpages() >= 2
				end,
				{ provider = "%=" },
				utils.make_tablist(Tabpage),
				TabpageClose,
			}

			local TabLineOffset = {
				condition = function(self)
					local win = vim.api.nvim_tabpage_list_wins(0)[1]
					local bufnr = vim.api.nvim_win_get_buf(win)
					self.winid = win
					if vim.bo[bufnr].filetype == "aerial" then
						self.title = "aerial"
						return true
					end
					if vim.bo[bufnr].filetype == "neo-tree" then
						self.title = "neo-tree"
						return true
					end
				end,
				provider = function(self)
					local title = self.title
					local width = vim.api.nvim_win_get_width(self.winid)
					local pad = math.ceil((width - #title) * 0.5)
					return string.rep(" ", pad) .. title .. string.rep(" ", pad)
				end,
				hl = function(self)
					if vim.api.nvim_get_current_win() == self.winid then
						return "TablineSel"
					else
						return "Tabline"
					end
				end,
			}

			local TabLine = { TabLineOffset, BufferLine, TabPages }

			require("heirline").setup({
				opts = { colors = colors },
				statusline = StatusLine,
				tabline = TabLine,
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				callback = function(ev)
					local bufnr = ev.buf
					if
							vim.list_contains(
								{ "wipe", "delete" },
								vim.api.nvim_get_option_value("bufhidden", { buf = bufnr })
							)
					then
						vim.bo[bufnr].buflisted = false
					end
				end,
				group = vim.api.nvim_create_augroup("Heirline", {}),
			})
		end,
	},
}
