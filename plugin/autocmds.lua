local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("CheckTime", {}),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
	group = augroup("HighlightYank", {}),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight the yanked text",
})

autocmd("LspAttach", {
	group = augroup("UserLspConfig", {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local methods = vim.lsp.protocol.Methods

		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		-- vim.keymap.set("n", "<space>f", function()
		-- 	vim.lsp.buf.format({ async = true })
		-- end, opts)

		if client.supports_method(methods.textDocument_documentHighlight) then
			autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = ev.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client.supports_method(methods.textDocument_inlayHint) then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})

-- put the cursor at the last edited position
autocmd("BufReadPost", {
	group = augroup("LastPlace", {}),
	callback = function(event)
		local exclude_bt = { "help", "nofile", "quickfix" }
		local exclude_ft = { "gitcommit" }
		local buf = event.buf
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

-- treesitter
autocmd("FileType", {
	callback = function(ev)
		if not pcall(vim.treesitter.start, ev.buf) then
			return
		end

		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

		vim.api.nvim_exec_autocmds("User", { pattern = "ts_attach" })
	end,
	desc = "Enable Treesitter",
})

-- No buflist for special files
autocmd("FileType", {
	group = augroup("NoBufList", {}),
	pattern = { "checkhealth", "help", "qf", "spectre_panel" },
	callback = function(ev)
		vim.b[ev.buf].buflisted = false
		vim.keymap.set("n", "q", function()
			vim.api.nvim_win_close(0, false)
		end, { buffer = ev.buf, silent = true })
	end,
	desc = "Special Files",
})

-- Enable conceal and spell for markup langs
autocmd("FileType", {
	group = augroup("ConcealSpell", {}),
	pattern = { "markdown", "tex" },
	callback = function(ev)
		vim.opt_local.conceallevel = 2
		vim.opt_local.spell = true

		vim.keymap.set("i", "<C-s>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = ev.buf, desc = "Crect Last Spelling" })
	end,
	desc = "Special Files",
})

-- Opens non-text files in the default program instead of in Neovim
autocmd("BufReadPost", {
	group = augroup("openFile", {}),
	pattern = { "*.jpeg", "*.jpg", "*.pdf", "*.png" },
	callback = function()
		vim.fn.jobstart("open '" .. vim.fn.expand("%") .. "'", { detach = true })
		vim.api.nvim_buf_delete(0, {})
	end,
	desc = "openFile",
})

-- automatically regenerate spell file after editing dictionary
autocmd("BufWritePost", {
	pattern = "*/spell/*.add",
	callback = function()
		vim.cmd.mkspell({ "%", bang = true, mods = { silent = true } })
	end,
})
