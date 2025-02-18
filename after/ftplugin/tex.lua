vim.opt_local.conceallevel = 2
vim.opt_local.spell = true

vim.keymap.set("i", "<C-h>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = 0, desc = "Crect Last Spelling" })

require("nvim-surround").buffer_setup({
	surrounds = {
		["c"] = {
			add = function()
				local cmd = require("nvim-surround.config").get_input("Command: ")
				return { { "\\" .. cmd .. "{" }, { "}" } }
			end,
			find = function()
				return require("nvim-surround.config").get_selection({
					node = { "generic_command", "label_definition" },
				})
			end,
			change = {
				target = "^\\([^%{]*)().-()()$",
				replacement = function()
					local cmd = require("nvim-surround.config").get_input("Command: ")
					return { { cmd }, {} }
				end,
			},
			delete = function()
				local sel = require("nvim-surround.config").get_selections({
					char = "c",
					pattern = "^(\\.-{)().-(})()$",
				})
				if sel then
					return sel
				end
				return require("nvim-surround.config").get_selections({
					char = "c",
					pattern = "^(\\.*)().-()()$",
				})
			end,
		},
		["$"] = {
			add = { "\\(", "\\)" },
			find = "\\%(.-\\%)",
			delete = "^(\\%()().-(\\%))()$",
			change = {
				target = "^\\(%()().-(\\%))()$",
				replacement = function()
					return { { "[", "\t" }, { "", "\\]" } }
				end,
			},
		},
		["`"] = {
			add = { "``", "''" },
			find = "``.-''",
			delete = "^(``)().-('')()$",
		},
	},
})
