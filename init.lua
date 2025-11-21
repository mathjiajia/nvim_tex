vim.loader.enable()
vim.schedule(function()
	require("vim._extui").enable({ msg = { target = "msg" } })
end)

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

vim.g.mapleader = " "

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

opt.linebreak = true
opt.pumborder = "rounded"
opt.winborder = "rounded"
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Make line numbers default
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes"

-- only one statusline
opt.laststatus = 3
opt.cmdheight = 0

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
-- opt.timeout = false
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 999

-- folding
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.fillchars = {
	eob = " ",
	fold = " ",
	foldopen = "",
	foldsep = " ",
	foldclose = "",
}

vim.cmd.colorscheme("bamboo")

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
	group = augroup("highlightYank", {}),
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
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- if client:supports_method("textDocument/codeLens", bufnr) then
		-- 	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.refresh, { desc = "codelens.refresh", buffer = bufnr })
		-- 	vim.keymap.set("n", "<leader>cr", vim.lsp.codelens.run, { desc = "lsp.codelens.run", buffer = bufnr })
		--
		-- 	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		-- 		buffer = bufnr,
		-- 		callback = function()
		-- 			vim.lsp.codelens.refresh({ bufnr = bufnr })
		-- 		end,
		-- 	})
		-- end

		if client:supports_method("textDocument/inlayHint", bufnr) then
			-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			vim.keymap.set("n", "<M-i>", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, { buffer = bufnr, desc = "Inlay Hint Toggle" })
		end
	end,
})

-- treesitter
autocmd("FileType", {
	group = augroup("treesitterFoldIndent", {}),
	callback = function(ev)
		if not pcall(vim.treesitter.start, ev.buf) then
			return
		end
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
	desc = "Enable Treesitter",
})

-- Opens non-text files in the default program instead of in Neovim
autocmd("BufReadPost", {
	group = augroup("openFile", {}),
	pattern = { "*.jpeg", "*.jpg", "*.mp4", "*.pdf", "*.png" },
	callback = function(ev)
		vim.system({ "open", vim.fn.expand("%") }, { detach = true })
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

require("lazy").setup("plugins")

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

-- Default icons
---@type string
local folder_icon = "%#Conditional#" .. "󰉋" .. "%#Normal#"
---@type string
local file_icon = "󰈙"

-- Map of LSP SymbolKind (which is a number) to a string icon
---@type table<number, string>
local kind_icons = {
	[1] = "%#File#" .. "󰈙" .. "%#Normal#", -- file
	[2] = "%#Module#" .. "󰏗" .. "%#Normal#", -- module
	[3] = "%#Structure#" .. "" .. "%#Normal#", -- namespace
	[19] = "%#Keyword#" .. "󰌋" .. "%#Normal#", -- key
	[5] = "%#Class#" .. "" .. "%#Normal#", -- class
	[6] = "%#Method#" .. "󰆧" .. "%#Normal#", -- method
	[7] = "%#Property#" .. "" .. "%#Normal#", -- property
	[8] = "%#Field#" .. "" .. "%#Normal#", -- field
	[9] = "%#Function#" .. "" .. "%#Normal#", -- constructor
	[10] = "%#Enum#" .. "" .. "%#Normal#", -- enum
	[11] = "%#Type#" .. "" .. "%#Normal#", -- interface
	[12] = "%#Function#" .. "󰊕" .. "%#Normal#", -- function
	[13] = "%#None#" .. "󰀫" .. "%#Normal#", -- variable
	[14] = "%#Constant#" .. "󰏿" .. "%#Normal#", -- constant
	[15] = "%#String#" .. "" .. "%#Normal#", -- string
	[16] = "%#Number#" .. "󰎠" .. "%#Normal#", -- number
	[17] = "%#Boolean#" .. "" .. "%#Normal#", -- boolean
	[18] = "%#Array#" .. "" .. "%#Normal#", -- array
	[20] = "%#Class#" .. "" .. "%#Normal#", -- object
	[4] = "󰆦", -- package
	[21] = "󰢤", -- null
	[22] = "", -- enum-member
	[23] = "%#Struct#" .. "" .. "%#Normal#", -- struct
	[24] = "", -- event
	[25] = "", -- operator
	[26] = "󰅲", -- type-parameter
}

--- Recursively finds the symbol path at the current cursor position.
---@param symbol_list any[]? List of LSP DocumentSymbol items
---@param path string[] An array to store the resulting path components (mutated).
---@param bufnr number
---@param encoding string
---@return boolean -- True if a symbol was found and added to the path.
local function find_symbol_path(symbol_list, path, bufnr, encoding)
	if not symbol_list or #symbol_list == 0 then
		return false
	end

	---@type number
	local winid = vim.api.nvim_get_current_win()

	for _, symbol in ipairs(symbol_list) do
		local cursor = vim.pos.cursor(vim.api.nvim_win_get_cursor(winid))
		local cursor_range = vim.range(cursor, cursor)
		local symbol_range = vim.range.lsp(bufnr, symbol.range, encoding)
		if symbol_range:intersect(cursor_range) then
			-- Found the symbol, add it to the path
			---@type string
			local icon = kind_icons[symbol.kind] or "" -- Default icon
			table.insert(path, icon .. " " .. symbol.name)
			-- Recurse into its children to find the most specific symbol
			find_symbol_path(symbol.children, path, bufnr, encoding)
			return true
		end
	end
	return false
end

--- Callback for the textDocument/documentSymbol LSP request.
--- Builds the full breadcrumb string (file path + symbol path) and sets the winbar.
---@param err any? Error object if the request failed.
---@param symbols any[]? The list of DocumentSymbol items from the LSP.
---@param ctx table Context object (includes bufnr).
---@param config table Client config.
local function lsp_callback(err, symbols, ctx, config)
	if err or not symbols then
		vim.o.winbar = "" -- Clear winbar on error or no symbols
		return
	end

	---@type string
	local file_path = vim.fn.bufname(ctx.bufnr)
	if not file_path or file_path == "" then
		vim.o.winbar = "[No Name]"
		return
	end

	---@type string?
	local relative_path

	---@type vim.lsp.Client[]
	local clients = vim.lsp.get_clients({ bufnr = ctx.bufnr })

	if #clients > 0 and clients[1].root_dir then
		-- Try to get relative path from LSP root
		---@type string?
		local root_dir = clients[1].root_dir
		if root_dir == nil then
			relative_path = file_path
		else
			relative_path = vim.fs.relpath(root_dir, file_path)
		end
	else
		-- Fallback to CWD
		---@type string
		local root_dir = vim.fn.getcwd(0)
		relative_path = vim.fs.relpath(root_dir, file_path)
	end

	---@type string[]
	local breadcrumbs = {}

	if not relative_path then
		return -- Failed to get a relative path
	end

	-- Split the path into components
	---@type string[]
	local path_components = vim.split(relative_path, "[/\\]", { trimempty = true })
	---@type number
	local num_components = #path_components

	-- Build the file path part of the breadcrumbs
	for i, component in ipairs(path_components) do
		if i == num_components then
			-- Last component is the file name, use devicon
			---@type string?
			local icon
			---@type string?
			local icon_hl

			if _G.MiniIcons then
				icon, icon_hl = MiniIcons.get("file", component)
			end
			table.insert(breadcrumbs, "%#" .. icon_hl .. "#" .. (icon or file_icon) .. "%#Normal#" .. " " .. component)
		else
			-- Path component is a folder
			table.insert(breadcrumbs, folder_icon .. " " .. component)
		end
	end

	local position_encoding = clients[1] and clients[1].server_capabilities.positionEncoding or "utf-16"

	-- Find and append the symbol path
	find_symbol_path(symbols, breadcrumbs, ctx.bufnr, position_encoding)

	---@type string
	local breadcrumb_string = table.concat(breadcrumbs, " > ")

	-- Set the winbar
	if breadcrumb_string ~= "" then
		vim.api.nvim_set_option_value("winbar", " " .. breadcrumb_string, { win = winnr })
	else
		vim.api.nvim_set_option_value("winbar", " ", { win = winnr })
	end
end

--- Requests document symbols from the LSP to update the breadcrumbs.
--- This function initiates the request; `lsp_callback` handles the result.
---@return nil
local function breadcrumbs_set()
	---@type number
	local bufnr = vim.api.nvim_get_current_buf()
	---@type number
	---@diagnostic disable-next-line: unused-local
	local winnr = vim.api.nvim_get_current_buf() -- Note: This is buffer handle, not window. Not used.

	-- Exit if no clients or client doesn't support documentSymbol
	if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" })) then
		return
	end

	---@type string
	local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
	if not uri then
		vim.print("Error: Could not get URI for buffer. Is it saved?")
		return
	end

	local params = {
		textDocument = {
			uri = uri,
		},
	}

	-- Don't run on non-file buffers (e.g., help tags)
	---@type string
	local buf_src = uri:sub(1, uri:find(":") - 1)
	if buf_src ~= "file" then
		vim.o.winbar = ""
		return
	end

	-- Make the async LSP request
	local result, _ = pcall(vim.lsp.buf_request, bufnr, "textDocument/documentSymbol", params, lsp_callback)

	if not result then
		-- Request failed to send
		return
	end
end

-- Create a dedicated augroup
---@type number
local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", {})

-- Update breadcrumbs when the cursor moves
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = breadcrumbs_augroup,
	callback = breadcrumbs_set,
	desc = "Set breadcrumbs.",
})

-- Clear breadcrumbs when leaving the window
vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = breadcrumbs_augroup,
	callback = function()
		vim.o.winbar = ""
	end,
	desc = "Clear breadcrumbs when leaving window.",
})

-- require("tex.conditions")

local EASYMOTION_NS = vim.api.nvim_create_namespace("EASYMOTION_NS")
local EM_CHARS = vim.split("fjdkslgha;rueiwotyqpvbcnxmzFJDKSLGHARUEIWOTYQPVBCNXMZ", "")

local function easy_motion()
	local char1 = vim.fn.nr2char(vim.fn.getchar() --[[@as number]])
	local char2 = vim.fn.nr2char(vim.fn.getchar() --[[@as number]])
	local line_idx_start, line_idx_end = vim.fn.line("w0"), vim.fn.line("w$")
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, EASYMOTION_NS, 0, -1)

	local char_idx = 1
	---@type table<string, {line: integer, col: integer, id: integer}>
	local extmarks = {}
	local lines = vim.api.nvim_buf_get_lines(bufnr, line_idx_start - 1, line_idx_end, false)
	local needle = char1 .. char2

	local is_case_sensitive = needle ~= string.lower(needle)

	for lines_i, line_text in ipairs(lines) do
		if not is_case_sensitive then
			line_text = string.lower(line_text)
		end
		local line_idx = lines_i + line_idx_start - 1
		-- skip folded lines
		if vim.fn.foldclosed(line_idx) == -1 then
			for i = 1, #line_text do
				if line_text:sub(i, i + 1) == needle and char_idx <= #EM_CHARS then
					local overlay_char = EM_CHARS[char_idx]
					local linenr = line_idx_start + lines_i - 2
					local col = i - 1
					local id = vim.api.nvim_buf_set_extmark(bufnr, EASYMOTION_NS, linenr, col + 2, {
						virt_text = { { overlay_char, "CurSearch" } },
						virt_text_pos = "overlay",
						hl_mode = "replace",
					})
					extmarks[overlay_char] = { line = linenr, col = col, id = id }
					char_idx = char_idx + 1
					if char_idx > #EM_CHARS then
						goto break_outer
					end
				end
			end
		end
	end
	::break_outer::

	-- otherwise setting extmarks and waiting for next char is on the same frame
	vim.schedule(function()
		local next_char = vim.fn.nr2char(vim.fn.getchar() --[[@as number]])
		if extmarks[next_char] then
			local pos = extmarks[next_char]
			-- to make <C-o> work
			vim.cmd("normal! m'")
			vim.api.nvim_win_set_cursor(0, { pos.line + 1, pos.col })
		end
		-- clear extmarks
		vim.api.nvim_buf_clear_namespace(0, EASYMOTION_NS, 0, -1)
	end)
end

vim.keymap.set({ "n", "x" }, "S", easy_motion, { desc = "Jump to 2 characters" })
