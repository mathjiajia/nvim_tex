return {

	{
		"ribru17/bamboo.nvim",
		priority = 1000,
		config = function()
			require("bamboo").setup({ transparent = true })
			require("bamboo").load()
		end,
	},

	-- winbar
	{
		"Bekaboo/dropbar.nvim",
		config = function()
			require("dropbar").setup({
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
			})
		end,
	},

	-- statusline
	{
		"rebelot/heirline.nvim",
		config = function()
			require("status")
		end,
	},

	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		-- stylua: ignore
		keys = {
			{ "<C-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal",       mode = { "n", "t" }, },
			{ "<leader><space>", function() Snacks.picker.files({ cwd = vim.fs.root(0, ".git") }) end,   desc = "Find Files (Root Dir)" },
			-- find
			{ "<leader>fb",      function() Snacks.picker.buffers({ layout = "select" }) end,            desc = "Buffers" },
			{ "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files (Root Dir)" },
			{ "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Files (git-files)" },
			{ "<leader>fm",      function() Snacks.picker.pickers({ layout = "select" }) end,            desc = "Snacks Picker" },
			{ "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
			{ "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
			-- Grep
			{ "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
			{ "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Diagnostics" },
			{ "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Word (Root Dir)",       mode = { "n", "x" } },
			-- search
			{ '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
			{ "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
			{ "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
			{ "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
			{ "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
			{ "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
			{ "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
			{ "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
			{ "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
			{ "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
			{ "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
			{ "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
			{ "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "Lsp Symbols" },
		},
		opts = {
			dashboard = {
				enabled = true,
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
					{
						pane = 2,
						icon = " ",
						title = "Projects",
						section = "projects",
						indent = 2,
						padding = 2,
					},
					{ section = "startup" },
				},
			},
			indent = {
				enabled = true,
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
			picker = {},
			scroll = { enabled = not vim.g.neovide },
			scope = { enabled = true },
			terminal = { win = { wo = { winbar = "" } } },
			words = { enabled = true },
			styles = {
				lazygit = { width = 0, height = 0 },
				notification = { wo = { wrap = true } },
				terminal = { height = 12 },
			},
		},
	},

	-- noicer ui
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
							},
						},
						view = "mini",
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
				},
			})

			vim.keymap.set({ "i", "n", "s" }, "<C-f>", function()
				if not require("noice.lsp").scroll(4) then
					return "<C-f>"
				end
			end, { silent = true, expr = true, desc = "Scroll Forward" })

			vim.keymap.set({ "i", "n", "s" }, "<C-b>", function()
				if not require("noice.lsp").scroll(-4) then
					return "<C-b>"
				end
			end, { silent = true, expr = true, desc = "Scroll Backward" })
		end,
	},

	-- rainbow delimiters
	{
		"HiPhish/rainbow-delimiters.nvim",
		submodules = false,
		init = function()
			vim.g.rainbow_delimiters = { query = { latex = "rainbow-delimiters" } }
		end,
	},

	-- icons
	{
		"echasnovski/mini.icons",
		config = function()
			require("mini.icons").setup({
				lsp = {
					["function"] = { glyph = "" },
					object = { glyph = "" },
					value = { glyph = "" },
				},
			})
		end,
	},
}
