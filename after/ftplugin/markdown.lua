vim.wo[0][0].spell = true
vim.wo[0][0].conceallevel = 2
vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = 0, desc = "Crect Last Spelling" })
