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

		if client:supports_method("textDocument/documentSymbol") then
			local breadcrumbs_augroup = augroup("Breadcrumbs", {})

			autocmd({ "CursorMoved" }, {
				buffer = bufnr,
				group = breadcrumbs_augroup,
				callback = function()
					local folder_icon = "%#Conditional#" .. "󰉋" .. "%#Normal#"
					local file_icon = "󰈙"

					local kind_icons = {
						"%#File#" .. "󰈙" .. "%#Normal#", -- file
						"%#Module#" .. "󰠱" .. "%#Normal#", -- module
						"%#Structure#" .. "" .. "%#Normal#", -- namespace
						"%#Keyword#" .. "󰌋" .. "%#Normal#", -- key
						"%#Class#" .. "" .. "%#Normal#", -- class
						"%#Method#" .. "󰆧" .. "%#Normal#", -- method
						"%#Property#" .. "" .. "%#Normal#", -- property
						"%#Field#" .. "" .. "%#Normal#", -- field
						"%#Function#" .. "" .. "%#Normal#", -- constructor
						"%#Enum#" .. "" .. "%#Normal#", -- enum
						"%#Type#" .. "" .. "%#Normal#", -- interface
						"%#Function#" .. "󰊕" .. "%#Normal#", -- function
						"%#None#" .. "󰂡" .. "%#Normal#", -- variable
						"%#Constant#" .. "󰏿" .. "%#Normal#", -- constant
						"%#String#" .. "" .. "%#Normal#", -- string
						"%#Number#" .. "" .. "%#Normal#", -- number
						"%#Boolean#" .. "" .. "%#Normal#", -- boolean
						"%#Array#" .. "" .. "%#Normal#", -- array
						"%#Class#" .. "" .. "%#Normal#", -- object
						"", -- package
						"󰟢", -- null
						"", -- enum-member
						"%#Struct#" .. "" .. "%#Normal#", -- struct
						"", -- event
						"", -- operator
						"󰅲", -- type-parameter
						"",
						"",
						"󰎠",
						"",
						"󰏘",
						"",
						"󰉋",
					}

					local function range_contains_pos(range, line, char)
						local start = range.start
						local stop = range["end"]

						if line < start.line or line > stop.line then
							return false
						end

						if line == start.line and char < start.character then
							return false
						end

						if line == stop.line and char > stop.character then
							return false
						end

						return true
					end

					local function find_symbol_path(symbol_list, line, char, path)
						if not symbol_list or #symbol_list == 0 then
							return false
						end

						for _, symbol in ipairs(symbol_list) do
							if range_contains_pos(symbol.range, line, char) then
								local icon = kind_icons[symbol.kind] or ""
								table.insert(path, icon .. " " .. symbol.name)
								find_symbol_path(symbol.children, line, char, path)
								return true
							end
						end
						return false
					end

					local function lsp_callback(err, symbols, ctx)
						if err or not symbols then
							vim.o.winbar = ""
							return
						end

						local winnr = vim.api.nvim_get_current_win()
						local pos = vim.api.nvim_win_get_cursor(0)
						local cursor_line = pos[1] - 1
						local cursor_char = pos[2]

						local file_path = vim.fn.bufname(ctx.bufnr)
						if not file_path or file_path == "" then
							vim.o.winbar = "[No Name]"
							return
						end

						local relative_path

						local clients = vim.lsp.get_clients({ bufnr = ctx.bufnr })

						if #clients > 0 and clients[1].root_dir then
							local root_dir = clients[1].root_dir
							if root_dir == nil then
								relative_path = file_path
							else
								relative_path = vim.fs.relpath(root_dir, file_path)
							end
						else
							local root_dir = vim.fn.getcwd(0)
							relative_path = vim.fs.relpath(root_dir, file_path)
						end

						local breadcrumbs = {}

						local path_components = vim.split(relative_path, "[/\\]", { trimempty = true })
						local num_components = #path_components

						for i, component in ipairs(path_components) do
							if i == num_components then
								local icon
								local icon_hl

								if _G.MiniIcons then
									icon, icon_hl = MiniIcons.get("file", component)
								end
								table.insert(
									breadcrumbs,
									"%#" .. icon_hl .. "# " .. (icon or file_icon) .. "%#Normal#" .. " " .. component
								)
							else
								table.insert(breadcrumbs, folder_icon .. " " .. component)
							end
						end
						find_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)

						local breadcrumb_string = table.concat(breadcrumbs, " > ")

						if breadcrumb_string ~= "" then
							vim.api.nvim_set_option_value("winbar", breadcrumb_string, { win = winnr })
						else
							vim.api.nvim_set_option_value("winbar", " ", { win = winnr })
						end
					end

					local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
					if not uri then
						vim.print("Error: Could not get URI for buffer. Is it saved?")
						return
					end

					local params = { textDocument = { uri = uri } }

					local buf_src = uri:sub(1, uri:find(":") - 1)
					if buf_src ~= "file" then
						vim.o.winbar = ""
						return
					end

					local result, _ =
						pcall(vim.lsp.buf_request, bufnr, "textDocument/documentSymbol", params, lsp_callback)
					if not result then
						return
					end
				end,
				desc = "Set breadcrumbs.",
			})

			vim.api.nvim_create_autocmd({ "WinLeave" }, {
				group = breadcrumbs_augroup,
				callback = function()
					vim.o.winbar = ""
				end,
				desc = "Clear breadcrumbs when leaving window.",
			})
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

require("lazy").setup("plugins", { ui = { border = "rounded" } })

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
