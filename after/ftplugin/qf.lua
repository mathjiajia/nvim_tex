vim.wo[0][0].scrolloff = 0
vim.bo.buflisted = false
vim.keymap.set("n", "q", function()
	vim.api.nvim_win_close(0, false)
end, { buffer = 0, silent = true })
