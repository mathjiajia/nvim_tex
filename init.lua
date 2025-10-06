vim.loader.enable()
require("vim._extui").enable({})

vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

---------- LAZYINIT ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local opt = vim.opt

-- 1 important

-- 2 moving around, searching and patterns
opt.ignorecase = true
opt.smartcase = true

-- 3 tags

-- 4 displaying text
opt.smoothscroll = true
opt.scrolloff = 10
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "> "
opt.fillchars = { diff = "╱", eob = " ", fold = " " }
opt.cmdheight = 0
opt.number = true
opt.relativenumber = true

-- 5 syntax, highlighting and spelling
-- opt.colorcolumn = "120"
opt.cursorline = true
opt.spelllang = "en_gb"

-- 6 multiple windows
opt.laststatus = 3
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true

-- 7 multiple tab pages

-- 8 terminal

-- 9 using the mouse

-- 10 messages and info
opt.confirm = true

-- 11 selecting text
opt.clipboard = "unnamedplus"

-- 12 editing text
opt.undolevels = 200
opt.undofile = true
opt.formatoptions = "tcroqnlj"
opt.pumheight = 10

-- 13 tabs and indenting
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- 14 folding
opt.foldmethod = "expr"
opt.foldlevel = 99

-- 15 diff mode

-- 16 mapping
opt.timeoutlen = 300

-- 17 reading and writing files

-- 18 the swap file
opt.swapfile = false
opt.updatetime = 200

-- 19 command line editing

-- 20 executing external commands

-- 21 running make and jumping to errors (quickfix)

-- 22 language specific

-- 23 multi-byte characters

-- 24 various
opt.virtualedit = "block"
opt.signcolumn = "yes"
opt.winborder = "rounded"
opt.pumborder = "rounded"

vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("CheckTime", {}),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd.checktime()
		end
	end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
	group = augroup("HighlightYank", {}),
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Highlight the Yanked Text",
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
	group = augroup("LastPlace", {}),
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
	desc = "Last Position",
})

-- lsp
autocmd("LspAttach", {
	group = augroup("my.lsp", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local bufnr = ev.buf
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go Declaration" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go Definition" })
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go Type Definition" })

		if client:supports_method("textDocument/foldingRange", bufnr) then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if client:supports_method("textDocument/documentHighlight") then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp_document_highlight", {})
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client:supports_method("textDocument/inlayHint", bufnr) then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			vim.keymap.set("n", "<M-i>", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, { buffer = bufnr, desc = "Inlay Hint Toggle" })
		end
	end,
})

-- treesitter
autocmd("FileType", {
	callback = function(ev)
		if not pcall(vim.treesitter.start, ev.buf) then
			return
		end
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
	desc = "Enable Treesitter",
})

-- Opens non-text files in the default program instead of in Neovim
autocmd("BufReadPost", {
	group = augroup("openFile", {}),
	pattern = { "*.jpeg", "*.jpg", "*.pdf", "*.png" },
	callback = function(ev)
		vim.system("open '" .. vim.fn.expand("%") .. "'", { detach = true })
		vim.api.nvim_buf_delete(ev.buf, {})
	end,
	desc = "Open File",
})

vim.diagnostic.config({
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	virtual_lines = { current_line = true },
	virtual_text = { current_line = false },
})

vim.keymap.set("n", "<leader>qq", vim.diagnostic.setqflist, { desc = "Set Quickfix" })
vim.keymap.set("n", "<leader>ql", vim.diagnostic.setloclist, { desc = "Set Loclist" })

require("lazy").setup("plugins", {
	ui = { border = "rounded" },
})

autocmd("LspProgress", {
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
})
