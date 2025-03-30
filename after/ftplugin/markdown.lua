vim.opt_local.spell = true

vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = 0, desc = "Crect Last Spelling" })
