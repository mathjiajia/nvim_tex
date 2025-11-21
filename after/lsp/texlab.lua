return {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = {
		".git",
		".latexmkrc",
		"latexmkrc",
		".texlabroot",
		"texlabroot",
		"Tectonic.toml",
	},
	settings = {
		texlab = {
			build = {
				args = { "-interaction=nonstopmode", "-synctex=1", "%f" },
				forwardSearchAfter = false,
				onSave = true,
			},
			forwardSearch = {
				executable = "sioyek",
				args = {
					"--reuse-window",
					"--execute-command",
					"turn_on_synctex",
					"--inverse-search",
					vim.fn.stdpath("data") .. "/mason/bin/texlab inverse-search -i %%1 --line1 %%2",
					"--forward-search-file",
					"%f",
					"--forward-search-line",
					"%l",
					"%p",
				},
				-- executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
				-- args = { "-r", "%l", "%p", "%f" },
			},
			diagnostics = {
				ignoredPatterns = {
					"Overfull",
					"Underfull",
					"Package hyperref Warning",
					"Float too large for page",
					"contains only floats",
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		local function buf_build()
			local win = vim.api.nvim_get_current_win()
			local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
			client:request("textDocument/build", params, function(err, result)
				if err then
					error(tostring(err))
				end
				local texlab_build_status = {
					[0] = "Success",
					[1] = "Error",
					[2] = "Failure",
					[3] = "Cancelled",
				}
				vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
			end, bufnr)
		end

		local function buf_search()
			local win = vim.api.nvim_get_current_win()
			local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
			client:request("textDocument/forwardSearch", params, function(err, result)
				if err then
					error(tostring(err))
				end
				local texlab_forward_status = {
					[0] = "Success",
					[1] = "Error",
					[2] = "Failure",
					[3] = "Unconfigured",
				}
				vim.notify("Search " .. texlab_forward_status[result.status], vim.log.levels.INFO)
			end, bufnr)
		end

		local function buf_cancel_build()
			return client:exec_cmd({
				title = "cancel",
				command = "texlab.cancelBuild",
			}, { bufnr = bufnr })
		end

		local function dependency_graph()
			client:exec_cmd({ command = "texlab.showDependencyGraph" }, { bufnr = bufnr }, function(err, result)
				if err then
					return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
				end
				vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
			end)
		end

		local function command_factory(cmd)
			local cmd_tbl = {
				Auxiliary = "texlab.cleanAuxiliary",
				Artifacts = "texlab.cleanArtifacts",
			}
			return function()
				return client:exec_cmd({
					title = ("clean_%s"):format(cmd),
					command = cmd_tbl[cmd],
					arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
				}, { bufnr = bufnr }, function(err, _)
					if err then
						vim.notify(("Failed to clean %s files: %s"):format(cmd, err.message), vim.log.levels.ERROR)
					else
						vim.notify(("Command %s executed successfully"):format(cmd), vim.log.levels.INFO)
					end
				end)
			end
		end

		local function buf_change_env()
			vim.ui.input({ prompt = "New environment name: " }, function(input)
				if not input or input == "" then
					return vim.notify("No environment name provided", vim.log.levels.WARN)
				end
				local pos = vim.api.nvim_win_get_cursor(0)
				return client:exec_cmd({
					title = "change_environment",
					command = "texlab.changeEnvironment",
					arguments = {
						{
							textDocument = { uri = vim.uri_from_bufnr(bufnr) },
							position = { line = pos[1] - 1, character = pos[2] },
							newName = input,
						},
					},
				}, { bufnr = bufnr })
			end)
		end

		local function close_env()
			local win = vim.api.nvim_get_current_win()
			client:exec_cmd({
				command = "texlab.findEnvironments",
				arguments = { vim.lsp.util.make_position_params(win, client.offset_encoding) },
			}, { bufnr = bufnr }, function(err, result)
				if err then
					return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
				end
				if #result == 0 then
					return vim.notify("No environment found", vim.log.levels.WARN)
				end

				local text = result[#result].name.text
				vim.api.nvim_put({ ("\\end{%s}"):format(text) }, "c", true, true)
			end)
		end

		local toggle_star = function()
			local win = vim.api.nvim_get_current_win()
			client:exec_cmd({
				command = "texlab.findEnvironments",
				arguments = { vim.lsp.util.make_position_params(win, client.offset_encoding) },
			}, { bufnr = bufnr }, function(err, result)
				if err then
					return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
				end
				if #result == 0 then
					return vim.notify("No environment found", vim.log.levels.WARN)
				end

				local text = result[#result].name.text
				local new = text:sub(-1) == "*" and text:sub(1, -2) or text .. "*"
				local pos = vim.api.nvim_win_get_cursor(0)
				client:exec_cmd({
					command = "texlab.changeEnvironment",
					arguments = {
						{
							textDocument = { uri = vim.uri_from_bufnr(bufnr) },
							position = { line = pos[1] - 1, character = pos[2] },
							newName = new,
						},
					},
				}, { bufnr = bufnr })
			end)
		end

		vim.api.nvim_buf_create_user_command(
			bufnr,
			"LspTexlabDependencyGraph",
			dependency_graph,
			{ desc = "Show LaTeX dependency graph" }
		)
		vim.api.nvim_buf_create_user_command(
			bufnr,
			"LspTexlabCleanArtifacts",
			command_factory("Artifacts"),
			{ desc = "Clean the artifacts" }
		)
		vim.api.nvim_buf_create_user_command(
			bufnr,
			"LspTexlabCleanAuxiliary",
			command_factory("Auxiliary"),
			{ desc = "Clean the auxiliary files" }
		)

		vim.keymap.set("n", "<localleader>ll", buf_build, { buffer = bufnr, desc = "Build the current buffer" })
		vim.keymap.set(
			"n",
			"<localleader>lf",
			buf_search,
			{ buffer = bufnr, desc = "Forward search from current position" }
		)
		vim.keymap.set("n", "<localleader>lc", buf_cancel_build, { buffer = bufnr, desc = "Cancel the current build" })
		vim.keymap.set("n", "cse", buf_change_env, { buffer = bufnr, desc = "Change the current environment" })
		vim.keymap.set("i", ";]", close_env, { buffer = bufnr, desc = "Close the current environment" })
		vim.keymap.set("n", "tss", toggle_star, { buffer = bufnr, desc = "Toggle starred environment" })
	end,
}
