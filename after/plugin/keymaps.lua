vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>qq", vim.diagnostic.setqflist, { desc = "Set Quickfix" })
vim.keymap.set("n", "<leader>ql", vim.diagnostic.setloclist, { desc = "Set Loclist" })
