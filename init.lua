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
		loaded_perl_provider = 0,
		loaded_python3_provider = 0,
		loaded_remote_plugins = 1,
		loaded_ruby_provider = 0,
		loaded_shada_plugin = 1,
		loaded_spellfile_plugin = 1,
		loaded_tarPlugin = 1,
		loaded_tutor_mode_plugin = 1,
		loaded_zip = 1,
		loaded_zipPlugin = 1,
		mapleader = " ",
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

vim.cmd.colorscheme("bamboo")

-- Set up Coding {{{
do
	vim.pack.add({
		"https://github.com/L3MON4D3/LuaSnip",
		"https://github.com/mathjiajia/nvim-math-snippets",
	})

	local ls = require("luasnip")
	local types = require("luasnip.util.types")

	ls.setup({
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged",
		enable_autosnippets = true,
		store_selection_keys = "<Tab>",
		ext_opts = {
			[types.insertNode] = { active = { virt_text = { { "", "Boolean" } } } },
			[types.choiceNode] = { active = { virt_text = { { "󱥸", "Special" } } } },
		},
	})

	require("luasnip.loaders.from_lua").lazy_load()

	vim.keymap.set({ "i", "s" }, "<C-;>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, { silent = true })

	vim.pack.add({
		"https://github.com/fang2hou/blink-copilot",
		{ src = "https://github.com/mikavilpas/blink-ripgrep.nvim", version = "v2.2.0" },
		{ src = "https://github.com/saghen/blink.cmp", version = "v1.8.0" },
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

	vim.pack.add({
		"https://github.com/saghen/blink.download",
		{ src = "https://github.com/saghen/blink.pairs", version = "v0.4.1" },
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

	vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
	require("nvim-surround").setup({})
end
-- }}}

-- Set up Editor {{{
do
	vim.pack.add({
		"https://github.com/esmuellert/vscode-diff.nvim",
		"https://github.com/saghen/blink.indent",
	})

	vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(event)
			if event.data.updated then
				require("fff.download").download_or_build_binary()
			end
		end,
	})

	vim.g.fff = {
		lazy_sync = true,
		prompt = "   ",
		layout = { prompt_position = "top" },
	}

-- stylua: ignore start
vim.keymap.set("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Open Files Picker" })
vim.keymap.set("n", "<leader>fg", function() require("fff").find_in_git_root() end, { desc = "Git Files Picker" })
vim.keymap.set("n", "<leader>fc", function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end, { desc = "Find Config Files" })
	-- stylua: ignore end

	vim.pack.add({ "https://github.com/folke/sidekick.nvim" })

	require("sidekick").setup({})

-- stylua: ignore start
vim.keymap.set("n", "<Tab>", function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end, { desc = "Goto/Apply Next Edit Suggestion" })
vim.keymap.set({ "n", "x", "i", "t" }, "<C-.>", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle" })
vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function() require("sidekick.cli").select({ filter = { installed = true } }) end, { desc = "Sidekick Select CLI" })
vim.keymap.set("n", "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach a CLI Session" })
vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
vim.keymap.set("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send File" })
vim.keymap.set("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Sidekick Select Prompt" })
	-- stylua: ignore end

	vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

	vim.g.grug_far = { icons = { fileIconsProvider = "mini.icons" } }
	vim.keymap.set({ "n", "v" }, "<leader>sr", function()
		local grug = require("grug-far")
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({ prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
	end, { desc = "[S]earch and [R]eplace" })

	vim.pack.add({ "https://github.com/nvim-mini/mini.diff" })

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

	vim.keymap.set("n", "<leader>hp", MiniDiff.toggle_overlay, { desc = "Hunk Diff Preview" })
end
-- }}}

-- Set up Lang {{{
do
	vim.pack.add({
		-- "https://github.com/nvim-lua/plenary.nvim",
		-- "https://github.com/Julian/lean.nvim",
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
		"https://github.com/mathjiajia/nvim-latex-conceal",
	})

	vim.g.render_markdown_config = {
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
	}
end
-- }}}

-- Set up Formatters {{{
do
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

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

	vim.keymap.set({ "n", "v" }, "<leader>cF", function()
		require("conform").format({ formatters = { "injected" } })
	end, { desc = "Format Injected Langs" })

	vim.api.nvim_create_user_command("FormatDisable", function(args)
		if args.bang then
			-- FormatDisable! will disable formatting just for this buffer
			vim.b.disable_autoformat = true
		else
			vim.g.disable_autoformat = true
		end
	end, {
		desc = "Disable autoformat-on-save",
		bang = true,
	})
	vim.api.nvim_create_user_command("FormatEnable", function()
		vim.b.disable_autoformat = false
		vim.g.disable_autoformat = false
	end, {
		desc = "Re-enable autoformat-on-save",
	})
end
--- }}}

-- Set up tree-sitter {{{
do
	vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(event)
			if event.data.updated then
				vim.cmd.TSUpdate()
			end
		end,
	})
end

-- }}}

-- Set up UI {{{
do
	vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
	vim.keymap.set("n", "<leader>go", ":G<CR>") -- open Git view

	vim.keymap.set("n", "<leader>gs", ":Gwrite <CR>") -- git stage
	vim.keymap.set("n", "<leader>gc", ":G commit<CR>") -- git commit
	vim.keymap.set("n", "<leader>gd", ":G diff<CR>") -- git diff
	vim.keymap.set("n", "<leader>gg", ":Gwrite | :G commit<CR>") -- git stage and commit

	vim.keymap.set("n", "<leader>gp", ":G push<CR>") -- git push
	vim.keymap.set("n", "<leader>gl", ":G log --pretty --oneline<CR>") -- git log
	vim.keymap.set("n", "<leader>gi", ":G rebase -i<CR>") -- git rebase

	vim.pack.add({
		"https://github.com/folke/snacks.nvim",
	})

	require("snacks").setup({
		opts = {
			explorer = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			-- styles = { lazygit = { width = 0, height = 0 } },
			words = { enabled = true },
		},
	})
	-- stylua: ignore start
	-- Top Pickers & Explorer
	vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
	vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })
	-- find
	vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fm", function() Snacks.picker({ layout = "select" }) end, { desc = "Pickers Meta" })
	vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
	vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
	-- git
	vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
	-- vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
	vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
	-- vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
	-- vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
	-- vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
	vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
	-- Grep
	vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
	vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
	vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
	vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
	-- search
	vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
	vim.keymap.set("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" })
	vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
	vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
	vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
	vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
	vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
	vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
	vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
	vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
	vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
	vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
	vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
	vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
	vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
	vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
	vim.keymap.set("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
	vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
	vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Resume" })
	vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
	vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
	-- LSP
	vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
	vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
	-- vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
	vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
	vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
	vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
	vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
	-- Other
	vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
	vim.keymap.set("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
	vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
	vim.keymap.set("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
	vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
	vim.keymap.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
	vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
	-- vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
	-- stylua: ignore end

	vim.pack.add({
		"https://github.com/nvim-mini/mini.statusline",
		"https://github.com/nvim-mini/mini.hipatterns",
		"https://github.com/nvim-mini/mini.icons",
		"https://github.com/MunifTanjim/nui.nvim",
	})

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
	require("mini.icons").setup()
	require("mini.statusline").setup()
end
-- }}}

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
	}
	for _, map in ipairs(user_binds) do
		vim.keymap.set(map.mode, map.key, map.action, map.options)
	end
end
-- }}}

-- }}}

-- LSP {{{
do
	vim.lsp.enable("copilot")
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
