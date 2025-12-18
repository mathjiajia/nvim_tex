vim.loader.enable()
require("vim._extui").enable({ msg = { target = "msg" } })

-- Set up globals {{{
do
	local user_globals = {
		loaded_gzip = 1,
		loaded_matchit = 1,
		loaded_matchparen = 1,
		loaded_netrw = 1,
		loaded_netrwPlugin = 1,
		loaded_remote_plugins = 1,
		loaded_shada_plugin = 1,
		loaded_spellfile_plugin = 1,
		loaded_tarPlugin = 1,
		loaded_tutor_mode_plugin = 1,
		loaded_zip = 1,
		loaded_zipPlugin = 1,

		mapleader = " ",

		fff = { layout = { prompt_position = "top" }, lazy_sync = true, prompt = "   " },
		["grug-far"] = { icons = { fileIconsProvider = "mini.icons" } },
		render_markdown_config = {
			file_types = { "markdown", "quarto" },
			anti_conceal = {
				disabled_modes = { "n" },
				ignore = {
					bullet = true,
					code_border = true,
					head_background = true,
					head_border = true,
				},
			},
			completions = { lsp = { enabled = true } },
			heading = {
				render_modes = true,
				icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
				border = true,
			},
			code = {
				position = "right",
				width = "block",
				min_width = 80,
				border = "thin",
			},
			pipe_table = {
				alignment_indicator = "─",
				border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
			},
			sign = { enabled = false },
			win_options = { concealcursor = { rendered = "nvc" } },
		},
	}

	for k, v in pairs(user_globals) do
		vim.g[k] = v
	end
end
-- }}}

-- Set up options {{{
do
	local user_options = {
		breakindent = true,
		clipboard = "unnamedplus",
		cmdheight = 0,
		cursorline = true,
		cursorlineopt = "number",
		fillchars = { eob = " ", fold = " ", foldclose = "", foldopen = "", foldsep = " " },
		foldexpr = "v:lua.vim.treesitter.foldexpr()",
		foldlevel = 99,
		foldlevelstart = 99,
		foldmethod = "expr",
		ignorecase = true,
		inccommand = "split",
		laststatus = 3,
		linebreak = true,
		list = true,
		listchars = { nbsp = "␣", tab = "▸ ", trail = "·" },
		number = true,
		pumborder = "rounded",
		relativenumber = true,
		scrolloff = 999,
		shiftwidth = 2,
		showmode = false,
		signcolumn = "yes",
		smartcase = true,
		softtabstop = 2,
		splitbelow = true,
		splitright = true,
		tabstop = 2,
		timeoutlen = 300,
		undofile = true,
		updatetime = 250,
		winborder = "rounded",
	}

	for k, v in pairs(user_options) do
		vim.opt[k] = v
	end
end
-- }}}

vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.WARN] = "",
		},
	},
	virtual_lines = { current_line = true },
	virtual_text = { current_line = false },
})

-- Set up vim.pack {{{
vim.pack.add({
	-- coding
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/mathjiajia/nvim-math-snippets",

	"https://github.com/fang2hou/blink-copilot",
	{ src = "https://github.com/mikavilpas/blink-ripgrep.nvim", version = "v2.2.0" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },
	"https://github.com/saghen/blink.download",
	{ src = "https://github.com/saghen/blink.pairs", version = "v0.4.1" },
	"https://github.com/kylechui/nvim-surround",

	-- editor
	"https://github.com/dmtrKovalenko/fff.nvim",
	"https://github.com/folke/snacks.nvim",

	"https://github.com/folke/sidekick.nvim",

	"https://github.com/MagicDuck/grug-far.nvim",

	"https://github.com/nvim-mini/mini.diff",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/esmuellert/vscode-diff.nvim",

	-- lang
	-- "https://github.com/nvim-lua/plenary.nvim",
	-- "https://github.com/Julian/lean.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/mathjiajia/nvim-latex-conceal",

	-- formatters
	"https://github.com/stevearc/conform.nvim",

	-- treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- ui
	"https://github.com/nvim-mini/mini.statusline",
	"https://github.com/nvim-mini/mini.hipatterns",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/MunifTanjim/nui.nvim",
})
-- }}}

vim.keymap.set("n", "<leader>gv", ":G<CR>") -- open Git view

vim.keymap.set("n", "<leader>gs", ":Gwrite <CR>") -- git stage
vim.keymap.set("n", "<leader>gc", ":G commit<CR>") -- git commit
vim.keymap.set("n", "<leader>gd", ":G diff<CR>") -- git diff
vim.keymap.set("n", "<leader>gg", ":Gwrite | :G commit<CR>") -- git stage and commit

vim.keymap.set("n", "<leader>gp", ":G push<CR>") -- git push
vim.keymap.set("n", "<leader>gl", ":G log --pretty --oneline<CR>") -- git log
vim.keymap.set("n", "<leader>gi", ":G rebase -i<CR>") -- git rebase

vim.cmd.colorscheme("bamboo")

require("mini.icons").setup()

require("snacks").setup({
	opts = {
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		scope = { enabled = true },
		words = { enabled = true },
	},
})

require("sidekick").setup({})

require("nvim-surround").setup({})

require("mini.statusline").setup()

require("mini.hipatterns").setup({
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
})

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

require("luasnip").setup({
	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
	ext_opts = {
		[require("luasnip.util.types").insertNode] = { active = { virt_text = { { "", "Boolean" } } } },
		[require("luasnip.util.types").choiceNode] = { active = { virt_text = { { "󱥸", "Special" } } } },
	},
})

require("luasnip.loaders.from_lua").lazy_load()

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require("conform").setup({
	formatters = {
		["bibtex-tidy"] = {
			prepend_args = {
				"--curly",
				"--tab",
				"--trailing-commas",
				"--sort-fields=author,year,month,day,title,shorttitle",
				"--remove-braces",
			},
		},
	},
	formatters_by_ft = {
		bib = { "bibtex-tidy" },
		fish = { "fish_indent" },
		lua = { "stylua" },
		markdown = { "prettier" },
		tex = { "tex-fmt" },
	},
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

local source_dedup_priority = { "lsp", "path", "snippets", "buffer", "ripgrep" }

local show_orig = require("blink.cmp.completion.list").show
require("blink.cmp.completion.list").show = function(ctx, items_by_source)
	local seen = {}
	for _, source in ipairs(source_dedup_priority) do
		if items_by_source[source] then
			items_by_source[source] = vim.tbl_filter(function(item)
				local did_seen = seen[item.label]
				seen[item.label] = true
				return not did_seen
			end, items_by_source[source])
		end
	end
	return show_orig(ctx, items_by_source)
end

require("blink.cmp").setup({
	completion = {
		documentation = { auto_show = true },
		list = { max_items = 20 },
		menu = { draw = { treesitter = { "lsp" } } },
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "ripgrep", "copilot" },
		providers = {
			copilot = { async = true, module = "blink-copilot", name = "Copilot" },
			ripgrep = { module = "blink-ripgrep", name = "Ripgrep" },
			snippets = { opts = { show_autosnippets = false } },
		},
	},
})

require("blink.pairs").setup({
	highlights = {
		groups = {
			"BlinkPairsOrange",
			"BlinkPairsPurple",
			"BlinkPairsBlue",
			"BlinkPairsCyan",
			"BlinkPairsYellow",
			"BlinkPairsGreen",
		},
	},
})

-- Set up keybinds {{{
do
	local user_binds = {
		{
			action = "v:count == 0 ? 'gk' : 'k'",
			key = "k",
			mode = { "n", "x" },
			options = { expr = true, silent = true },
		},
		{
			action = "v:count == 0 ? 'gj' : 'j'",
			key = "j",
			mode = { "n", "x" },
			options = { expr = true, silent = true },
		},
		{
			action = "o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>",
			key = "gco",
			mode = "n",
			options = { desc = "Create a commented line below" },
		},
		{
			action = "O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>",
			key = "gcO",
			mode = "n",
			options = { desc = "Create a commented line above" },
		},
		{
			action = "p:let @+=@0<CR>",
			key = "p",
			mode = "x",
			options = { desc = "Paste w/o overwriting clipboard (unnamedplus)" },
		},
		{ action = "<Esc>/\\%V", key = "/", mode = "x", options = { desc = "search within visual selection" } },
		{ action = vim.diagnostic.setqflist, key = "<leader>qq", mode = "n", options = { desc = "Set [Q]uickfix" } },
		{ action = vim.diagnostic.setloclist, key = "<leader>ql", mode = "n", options = { desc = "Set [L]oclist" } },
		{
			action = function()
				MiniDiff.toggle_overlay()
			end,
			key = "<leader>go",
			mode = "n",
			options = { desc = "Hunk Diff [O]verlay" },
		},

		{
			action = function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 2000 })
			end,
			key = "<leader>cF",
			mode = { "n", "v" },
			options = { desc = "[F]ormat Injected Langs" },
		},

		{
			action = function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({ prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
			end,
			key = "<leader>sr",
			mode = { "n", "v" },
			options = { desc = "[S]earch and [R]eplace" },
		},

		{ action = "<Cmd>FFFFind<CR>", key = "<leader>ff", mode = "n", options = { desc = "[F]ile [F]inder" } },
		{
			action = function()
				require("fff").find_in_git_root()
			end,
			key = "<leader>fg",
			mode = "n",
			options = { desc = "[F]ind [G]it Files" },
		},

		{
			action = function()
				Snacks.picker.smart()
			end,
			key = "<leader><space>",
			mode = "n",
			options = { desc = "Smart Open" },
		},
		{
			action = function()
				Snacks.explorer()
			end,
			key = "<leader>e",
			mode = "n",
			options = { desc = "[E]xplorer" },
		},
		{
			action = function()
				Snacks.picker.buffers({ layout = "select" })
			end,
			key = "<leader>fb",
			mode = "n",
			options = { desc = "[F]ind [B]uffers" },
		},
		{
			action = function()
				Snacks.picker({ layout = "select" })
			end,
			key = "<leader>fm",
			mode = "n",
			options = { desc = "[F]ind [M]eta" },
		},
		{
			action = function()
				Snacks.picker.projects()
			end,
			key = "<leader>fp",
			mode = "n",
			options = { desc = "[F]ind [P]rojects" },
		},
		{
			action = function()
				Snacks.picker.recent()
			end,
			key = "<leader>fr",
			mode = "n",
			options = { desc = "[F]ind [R]ecent" },
		},
		-- {
		-- 	action = function()
		-- 		Snacks.picker.git_diff()
		-- 	end,
		-- 	key = "<leader>gd",
		-- 	mode = "n",
		-- 	options = { desc = "[G]it [D]iff (Hunks)" },
		-- },
		{
			action = function()
				Snacks.picker.git_log_file()
			end,
			key = "<leader>gf",
			mode = "n",
			options = { desc = "[G]it Log [F]ile" },
		},
		{
			action = function()
				Snacks.picker.git_log_line()
			end,
			key = "<leader>gL",
			mode = "n",
			options = { desc = "[G]it Log [L]ine" },
		},
		{
			action = function()
				Snacks.picker.lines()
			end,
			key = "<leader>sb",
			mode = "n",
			options = { desc = "[B]uffer Lines" },
		},
		{
			action = function()
				Snacks.picker.grep_buffers()
			end,
			key = "<leader>sB",
			mode = "n",
			options = { desc = "Grep Open [B]uffers" },
		},
		{
			action = function()
				Snacks.picker.grep()
			end,
			key = "<leader>sg",
			mode = "n",
			options = { desc = "[G]rep" },
		},
		{
			action = function()
				Snacks.picker.grep_word()
			end,
			key = "<leader>sw",
			mode = { "n", "x" },
			options = { desc = "Visual selection or [W]ord" },
		},
		{
			action = function()
				Snacks.picker.registers()
			end,
			key = '<leader>s"',
			mode = "n",
			options = { desc = "Registers" },
		},
		{
			action = function()
				Snacks.picker.search_history()
			end,
			key = "<leader>s/",
			mode = "n",
			options = { desc = "Search History" },
		},
		{
			action = function()
				Snacks.picker.command_history()
			end,
			key = "<leader>sc",
			mode = "n",
			options = { desc = "[C]ommand History" },
		},
		{
			action = function()
				Snacks.picker.commands()
			end,
			key = "<leader>sC",
			mode = "n",
			options = { desc = "[C]ommands" },
		},
		{
			action = function()
				Snacks.picker.diagnostics()
			end,
			key = "<leader>sd",
			mode = "n",
			options = { desc = "[D]iagnostics" },
		},
		{
			action = function()
				Snacks.picker.help()
			end,
			key = "<leader>sh",
			mode = "n",
			options = { desc = "[H]elp Pages" },
		},
		{
			action = function()
				Snacks.picker.jumps()
			end,
			key = "<leader>sj",
			mode = "n",
			options = { desc = "[J]umps" },
		},
		{
			action = function()
				Snacks.picker.loclist()
			end,
			key = "<leader>sl",
			mode = "n",
			options = { desc = "[L]ocation List" },
		},
		{
			action = function()
				Snacks.picker.marks()
			end,
			key = "<leader>sm",
			mode = "n",
			options = { desc = "[M]arks" },
		},
		{
			action = function()
				Snacks.picker.qflist()
			end,
			key = "<leader>sq",
			mode = "n",
			options = { desc = "[Q]uickfix List" },
		},
		{
			action = function()
				Snacks.picker.resume()
			end,
			key = "<leader>sR",
			mode = "n",
			options = { desc = "[R]esume" },
		},
		{
			action = function()
				Snacks.picker.undo()
			end,
			key = "<leader>su",
			mode = "n",
			options = { desc = "[U]ndo History" },
		},
		{
			action = function()
				Snacks.picker.lsp_symbols()
			end,
			key = "<leader>ss",
			mode = "n",
			options = { desc = "Lsp [S]ymbols" },
		},
		{
			action = function()
				Snacks.zen()
			end,
			key = "<leader>z",
			mode = "n",
			options = { desc = "Toggle [Z]en Mode" },
		},
		{
			action = function()
				Snacks.zen.zoom()
			end,
			key = "<leader>Z",
			mode = "n",
			options = { desc = "Toggle [Z]oom" },
		},
		{
			action = function()
				Snacks.scratch()
			end,
			key = "<leader>.",
			mode = "n",
			options = { desc = "Toggle Scratch Buffer" },
		},
		{
			action = function()
				Snacks.scratch.select()
			end,
			key = "<leader>S",
			mode = "n",
			options = { desc = "Select [S]cratch Buffer" },
		},
		{
			action = function()
				Snacks.bufdelete()
			end,
			key = "<leader>bd",
			mode = "n",
			options = { desc = "[D]elete [B]uffer" },
		},
		{
			action = function()
				Snacks.bufdelete.other()
			end,
			key = "<leader>bD",
			mode = "n",
			options = { desc = "[D]elete Other [B]uffers" },
		},
		{
			action = function()
				Snacks.rename.rename_file()
			end,
			key = "<leader>cr",
			mode = "n",
			options = { desc = "[R]ename File" },
		},

		{
			action = function()
				if require("luasnip").choice_active() then
					require("luasnip").change_choice(1)
				end
			end,
			key = "<C-;>",
			mode = { "i", "s" },
			options = { desc = "Change Choice", silent = true },
		},

		{
			action = function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>"
				end
			end,
			key = "<Tab>",
			mode = "n",
			options = { desc = "Sidekick Toggle CLI", expr = true },
		},
		{
			action = function()
				require("sidekick.cli").toggle()
			end,
			key = "<C-.>",
			mode = { "n", "x", "i", "t" },
			options = { desc = "Sidekick Switch Focus" },
		},
		{
			action = function()
				require("sidekick.cli").toggle()
			end,
			key = "<leader>aa",
			mode = "n",
			options = { desc = "Sidekick Toggle CLI" },
		},
		{
			action = function()
				require("sidekick.cli").select({ filter = { installed = true } })
			end,
			key = "<leader>as",
			mode = "n",
			options = { desc = "Sidekick Select CLI" },
		},
		{
			action = function()
				require("sidekick.cli").close()
			end,
			key = "<leader>ad",
			mode = "n",
			options = { desc = "Detach a CLI Session" },
		},
		{
			action = function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			key = "<leader>at",
			mode = { "x", "n" },
			options = { desc = "Send This" },
		},
		{
			action = function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			key = "<leader>af",
			mode = "n",
			options = { desc = "Send File" },
		},
		{
			action = function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			key = "<leader>av",
			mode = "x",
			options = { desc = "Send Visual Selection" },
		},
		{
			action = function()
				require("sidekick.cli").select_prompt()
			end,
			key = "<leader>ap",
			mode = { "n", "x" },
			options = { desc = "Sidekick Prompt Picker" },
		},
	}
	for _, map in ipairs(user_binds) do
		vim.keymap.set(map.mode, map.key, map.action, map.options)
	end
end
-- }}}

do
	local cmds = {
		FormatDisable = {
			command = function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end,
			options = { bang = true, desc = "Disable autoformat-on-save" },
		},
		FormatEnable = {
			command = function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end,
			options = { desc = "Re-enable autoformat-on-save" },
		},
	}
	for name, cmd in pairs(cmds) do
		vim.api.nvim_create_user_command(name, cmd.command, cmd.options or {})
	end
end

-- Set up fff and treesitter {{{
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		if event.data.updated then
			require("fff.download").download_or_build_binary()
			vim.cmd.TSUpdate()
		end
	end,
})

-- }}}

-- LSP {{{
do
	vim.lsp.enable({ "copilot", "lua_ls", "marksman", "texlab" })
end
-- }}}

-- Set up autogroups {{
do
	local user_autogroups = {
		checkTime = { clear = true },
		lastPlace = { clear = true },
		lsp_on_attach = { clear = false },
		openFile = { clear = true },
		treesitterFoldIndent = { clear = true },
	}

	for group_name, options in pairs(user_autogroups) do
		vim.api.nvim_create_augroup(group_name, options)
	end
end
-- }}

-- Set up autocommands {{
do
	local user_autocommands = {
		{
			callback = function()
				if vim.o.buftype ~= "nofile" then
					vim.cmd.checktime()
				end
			end,
			desc = "Check if file changed outside of Neovim",
			event = { "FocusGained", "TermClose", "TermLeave" },
			group = "checkTime",
		},
		{
			callback = function()
				vim.hl.on_yank()
			end,
			event = "TextYankPost",
		},
		{
			callback = function(ev)
				local exclude_bt = { "help", "nofile", "quickfix" }
				local exclude_ft = { "gitcommit" }
				local buf = ev.buf
				if
					vim.list_contains(exclude_bt, vim.bo[buf].buftype)
					or vim.list_contains(exclude_ft, vim.bo[buf].filetype)
					or vim.api.nvim_win_get_cursor(0)[1] > 1
					or vim.b[buf].last_pos
				then
					return
				end
				vim.b[buf].last_pos = true
				local mark = vim.api.nvim_buf_get_mark(buf, '"')
				local lcount = vim.api.nvim_buf_line_count(buf)
				if mark[1] > 0 and mark[1] <= lcount then
					pcall(vim.api.nvim_win_set_cursor, 0, mark)
				end
			end,
			desc = "go to last loc when opening a buffer",
			event = "BufReadPost",
			group = "lastPlace",
		},
		{
			callback = function(ev)
				if not pcall(vim.treesitter.start, ev.buf) then
					return
				end
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
			desc = "Enable Treesitter",
			event = "FileType",
			group = "treesitterFoldIndent",
		},
		{
			callback = function(ev)
				local value = ev.data.params.value
				if value.kind == "begin" then
					vim.api.nvim_ui_send("\027]9;4;1;0\027\\")
				elseif value.kind == "end" then
					vim.api.nvim_ui_send("\027]9;4;0\027\\")
				elseif value.kind == "report" then
					vim.api.nvim_ui_send(string.format("\027]9;4;1;%d\027\\", value.percentage or 0))
				end
			end,
			event = "LspProgress",
		},
		{
			callback = function(ev)
				vim.system({ "open", vim.fn.expand("%") }, { detach = true })
				vim.api.nvim_buf_delete(ev.buf, {})
			end,
			desc = "Opens non-text files in the default program instead of in Neovim",
			event = "BufReadPost",
			group = "openFile",
			pattern = { "*.jpeg", "*.jpg", "*.mp4", "*.pdf", "*.png" },
		},
		{
			callback = function(event)
				do
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local bufnr = event.buf
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go Declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go Definition" })
					vim.keymap.set(
						"n",
						"<C-k>",
						vim.lsp.buf.signature_help,
						{ buffer = bufnr, desc = "Signature Help" }
					)
					vim.keymap.set(
						"n",
						"gt",
						vim.lsp.buf.type_definition,
						{ buffer = bufnr, desc = "Go Type Definition" }
					)

					if client:supports_method("textDocument/foldingRange", bufnr) then
						local win = vim.api.nvim_get_current_win()
						vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
					end

					if client:supports_method("textDocument/codeLens", bufnr) then
						vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "CursorHold" }, {
							group = vim.api.nvim_create_augroup("CodelensRefresh", {}),
							buffer = bufnr,
							callback = vim.lsp.codelens.refresh,
						})
					end

					if client:supports_method("textDocument/inlayHint", bufnr) then
						-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						vim.keymap.set("n", "<M-i>", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
								{ bufnr = bufnr }
							)
						end, { buffer = bufnr, desc = "Inlay Hint Toggle" })
					end
				end
			end,
			desc = "Run LSP onAttach",
			event = "LspAttach",
			group = "lsp_on_attach",
		},
	}

	for _, autocmd in ipairs(user_autocommands) do
		vim.api.nvim_create_autocmd(autocmd.event, {
			group = autocmd.group,
			pattern = autocmd.pattern,
			buffer = autocmd.buffer,
			desc = autocmd.desc,
			callback = autocmd.callback,
			command = autocmd.command,
			once = autocmd.once,
			nested = autocmd.nested,
		})
	end
end
-- }}
