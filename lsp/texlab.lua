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
			client:exec_cmd({ title = "cancel Build", command = "texlab.cancelBuild" }, { bufnr = bufnr })
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
			local win = vim.api.nvim_get_current_win()
			client:exec_cmd({
				title = "find Environments",
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
			end)
		end

		-- Enhanced function to parse DOT graph into a Lua table
		local function parse_dot(dot_str)
			local graph = { nodes = {}, edges = {} }
			-- Parse nodes
			for id, label in dot_str:gmatch('(%S-)%s*%[label="(.-)"%s*,?%s*shape=%S-%]') do
				graph.nodes[id] = label:match(".*/(.-)$") or label -- Extract filename from full path
			end

			-- Parse edges
			for from, to, edge_label in dot_str:gmatch('(%S-)%s*%->%s*(%S-)%s*%[label="(.-)"%]') do
				table.insert(graph.edges, {
					from = from,
					to = to,
					label = edge_label or "", -- Handle missing labels gracefully
				})
			end

			return graph
		end
		-- Function to render the graph with node labels instead of IDs
		local function render_graph(graph)
			local output = { "ASCII Representation of DOT Graph:" }

			for _, edge in ipairs(graph.edges) do
				local from_label = graph.nodes[edge.from] or edge.from
				table.insert(output, string.format("%s --> %s", from_label, edge.label))
			end

			return table.concat(output, "\n")
		end
		-- Handler function for the LSP command
		-- Updated dependency_graph function with split buffer
		local function dependency_graph()
			client:exec_cmd({
				title = "Dependency Graph",
				command = "texlab.showDependencyGraph",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			}, { bufnr = bufnr }, function(err, result)
				if err then
					return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
				end
				-- Parse and render the graph
				local graph = parse_dot(result)
				local rendered_graph = render_graph(graph)
				vim.notify(rendered_graph, vim.log.levels.INFO)
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

		vim.keymap.set("n", "<leader>ll", buf_build, { buffer = bufnr, desc = "Build the current buffer" })
		vim.keymap.set("n", "<leader>lf", buf_search, { buffer = bufnr, desc = "Forward search from current position" })
		vim.keymap.set("n", "<leader>lc", buf_cancel_build, { buffer = bufnr, desc = "Cancel the current build" })
		vim.keymap.set("n", "cse", buf_change_env, { buffer = bufnr, desc = "Change the current environment" })
		vim.keymap.set("i", ";]", close_env, { buffer = bufnr, desc = "Close the current environment" })
		vim.keymap.set("n", "tss", toggle_star, { buffer = bufnr, desc = "Toggle starred environment" })
	end,
}
