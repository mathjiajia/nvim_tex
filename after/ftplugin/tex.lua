vim.wo[0][0].conceallevel = 2
vim.wo[0][0].spell = true

vim.keymap.set("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", { buffer = 0, desc = "Correct Last Spelling" })

local config = require("nvim-surround.config")
require("nvim-surround").buffer_setup({
	surrounds = {
		["'"] = {
			add = { "`", "'" },
			find = "`.-'",
			delete = "^(`)().-(')()$",
		},
		['"'] = {
			add = { "``", "''" },
			find = "``.-''",
			delete = "^(``)().-('')()$",
		},
		["c"] = {
			add = function()
				local cmd = config.get_input("Enter a command: ")
				return { { "\\" .. cmd .. "{" }, { "}" } }
			end,
			find = "\\%a+%b{}",
			delete = "^(\\%a+{)().-(})()$",
			change = {
				target = "^\\(%a+)(){.-}()()$",
				replacement = function()
					local cmd = config.get_input("Enter a command: ")
					return { { cmd }, { "" } }
				end,
			},
		},
		-- ["e"] = {
		-- add = function()
		-- 	local env = config.get_input("Enter an environment: ")
		-- 	return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
		-- end,
		-- find = function()
		-- 	return config.get_selection({ node = "generic_environment" })
		-- end,
		-- delete = [[^(\begin%b{})().*(\end%b{})()$]],
		-- change = {
		-- 	target = [[^\begin{(.-)()%}.*\end{(.-)()}$]],
		-- 	replacement = function()
		-- 		local env = require("nvim-surround.config").get_input("Environment: ")
		-- 		return { { env }, { env } }
		-- 	end,
		-- },
		-- },
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
	},
})

-- local git_latexdiff_pick = function()
-- 	-- Show git log entries with multi-select enabled
-- 	Snacks.picker.git_log({
-- 		prompt = "Select two commits> ",
-- 		multi = 2, -- allow exactly two selections
-- 		win = { layout = "vertical", preview = false },
-- 		actions = {
-- 			-- Default Enter action
-- 			["default"] = function(picker)
-- 				local sel = picker:get_multi_selection()
-- 				if not sel or #sel ~= 2 then
-- 					vim.notify("Please select exactly two commits")
-- 					return
-- 				end
-- 				-- extract commit hashes
-- 				local hash1 = sel[1].entry.value:match("^%S+")
-- 				local hash2 = sel[2].entry.value:match("^%S+")
--
-- 				-- open a new buffer/window for output
-- 				vim.cmd("new")
-- 				local bufnr = vim.api.nvim_get_current_buf()
-- 				local win = vim.api.nvim_get_current_win()
--
-- 				-- launch git latexdiff
-- 				vim.fn.jobstart({
-- 					"git",
-- 					"latexdiff",
-- 					"--main",
-- 					vim.fn.expand("%:f"),
-- 					hash2,
-- 					hash1,
-- 				}, {
-- 					stdout_buffered = false,
-- 					stderr_buffered = false,
-- 					on_stdout = function(_, data)
-- 						if data and #data > 0 then
-- 							vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
-- 							local line = vim.api.nvim_buf_line_count(bufnr)
-- 							vim.api.nvim_win_set_cursor(win, { line, 0 })
-- 						end
-- 					end,
-- 					on_stderr = function(_, data)
-- 						if data and #data > 0 then
-- 							vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
-- 							local line = vim.api.nvim_buf_line_count(bufnr)
-- 							vim.api.nvim_win_set_cursor(win, { line, 0 })
-- 						end
-- 					end,
-- 					detach = true,
-- 				})
-- 			end,
-- 			-- disable other default actions (optional)
-- 			["<c-y>"] = false,
-- 		},
-- 	})
-- end
--
-- vim.keymap.set({ "n", "i", "v" }, ",ld", git_latexdiff_pick, { desc = "LatexDiff", buffer = true })
