local on_attach = function(client, bufnr)
	local win = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

	local function buf_build()
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
		client:exec_cmd({ title = "cancel", command = "texlab.cancelBuild" }, { bufnr = bufnr })
	end

	local function dependency_graph()
		client:request("workspace/executeCommand", { command = "texlab.showDependencyGraph" }, function(err, result)
			if err then
				return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
			end
			vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
		end, 0)
	end

	local function command_factory(cmd)
		local cmd_tbl = {
			Auxiliary = "texlab.cleanAuxiliary",
			Artifacts = "texlab.cleanArtifacts",
			CancelBuild = "texlab.cancelBuild",
		}
		return function()
			client:exec_cmd({
				title = ("clean_%s"):format(cmd),
				command = cmd_tbl[cmd],
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			}, { bufnr = bufnr }, function(err, _)
				if err then
					vim.notify(("Failed to clean %s files: %s"):format(cmd, err.message), vim.log.levels.ERROR)
				else
					vim.notify(("command %s executed successfully"):format(cmd), vim.log.levels.INFO)
				end
			end)
		end
	end

	local function buf_find_envs()
		client:request("workspace/executeCommand", {
			command = "texlab.findEnvironments",
			arguments = { params },
		}, function(err, result)
			if err then
				return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
			end
			local env_names = {}
			local max_length = 1
			for _, env in ipairs(result) do
				table.insert(env_names, env.name.text)
				max_length = math.max(max_length, string.len(env.name.text))
			end
			for i, name in ipairs(env_names) do
				env_names[i] = string.rep(" ", i - 1) .. name
			end
			vim.lsp.util.open_floating_preview(env_names, "", {
				height = #env_names,
				width = math.max((max_length + #env_names - 1), (string.len("Environments"))),
				focusable = false,
				focus = false,
				border = "single",
				title = "Environments",
			})
		end, bufnr)
	end

	local function buf_change_env()
		local new = vim.fn.input("Enter the new environment name: ")
		if not new or new == "" then
			return vim.notify("No environment name provided", vim.log.levels.WARN)
		end
		local pos = vim.api.nvim_win_get_cursor(0)

		client:exec_cmd({
			title = "change_environment",
			command = "texlab.changeEnvironment",
			arguments = {
				{
					textDocument = { uri = vim.uri_from_bufnr(bufnr) },
					position = { line = pos[1] - 1, character = pos[2] },
					newName = tostring(new),
				},
			},
		}, { bufnr = bufnr })
	end

	local function close_env()
		client:request("workspace/executeCommand", {
			command = "texlab.findEnvironments",
			arguments = { params },
		}, function(err, result)
			if err then
				return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
			end
			if #result == 0 then
				return vim.notify("No environment found", vim.log.levels.WARN)
			end

			local text = result[#result].name.text
			vim.api.nvim_put({ "\\end{" .. text .. "}" }, "", false, true)
		end, bufnr)
	end

	local toggle_star = function()
		client:request("workspace/executeCommand", {
			command = "texlab.findEnvironments",
			arguments = { params },
		}, function(err, result)
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
				title = "change_environment",
				command = "texlab.changeEnvironment",
				arguments = {
					{
						textDocument = { uri = vim.uri_from_bufnr(bufnr) },
						position = { line = pos[1] - 1, character = pos[2] },
						newName = new,
					},
				},
			}, { bufnr = bufnr })
		end, bufnr)
	end

	-- vim.api.nvim_buf_create_user_command(bufnr, "TexlabBuild", buf_build, { desc = "Build the current buffer" })
	-- vim.api.nvim_buf_create_user_command(
	-- 	bufnr,
	-- 	"TexlabForward",
	-- 	buf_search,
	-- 	{ desc = "Forward search from current position" }
	-- )
	-- vim.api.nvim_buf_create_user_command(
	-- 	bufnr,
	-- 	"TexlabCancelBuild",
	-- 	buf_cancel_build,
	-- 	{ desc = "Cancel the current build" }
	-- )
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TexlabDependencyGraph",
		dependency_graph,
		{ desc = "Show the dependency graph" }
	)
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TexlabCleanArtifacts",
		command_factory("Artifacts"),
		{ desc = "Clean the artifacts" }
	)
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TexlabCleanAuxiliary",
		command_factory("Auxiliary"),
		{ desc = "Clean the auxiliary files" }
	)
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TexlabFindEnvironments",
		buf_find_envs,
		{ desc = "Find the environments at current position" }
	)
	vim.api.nvim_buf_create_user_command(
		bufnr,
		"TexlabChangeEnvironment",
		buf_change_env,
		{ desc = "Change the environment at current position" }
	)

	vim.keymap.set("n", "<leader>ll", buf_build, { buffer = bufnr, desc = "Build the current buffer" })
	vim.keymap.set("n", "<leader>lf", buf_search, { buffer = bufnr, desc = "Forward search from current position" })
	vim.keymap.set("n", "<leader>lc", buf_cancel_build, { buffer = bufnr, desc = "Cancel the current build" })
	vim.keymap.set("n", "cse", buf_change_env, { buffer = bufnr, desc = "Change the current environment" })
	vim.keymap.set("i", "]]", close_env, { buffer = bufnr, desc = "Close the current environment" })
	vim.keymap.set("n", "tss", toggle_star, { buffer = bufnr, desc = "Toggle starred environment" })
end

return {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = {
		".git",
		".latexmkrc",
		".texlabroot",
		"texlabroot",
		"Tectonic.toml",
	},
	single_file_support = true,
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
					"texlab inverse-search -i %%1 -l %%2",
					"--forward-search-file",
					"%f",
					"--forward-search-line",
					"%l",
					"%p",
				},
				-- executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
				-- args = { "-r", "%l", "%p", "%f" },
			},
			diagnostics = { ignoredPatterns = { "^Overfull", "^Underfull" } },
		},
	},
	on_attach = on_attach,
}
