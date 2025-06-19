local version = vim.version()

---@type vim.lsp.Config
return {
	--NOTE: This name means that existing blink completion works
	name = "copilot_ls",
	cmd = {
		"copilot-language-server",
		"--stdio",
	},
	init_options = {
		editorInfo = {
			name = "neovim",
			version = string.format("%d.%d.%d", version.major, version.minor, version.patch),
		},
		editorPluginInfo = {
			name = "Github Copilot LSP for Neovim",
			version = "0.0.1",
		},
	},
	-- settings = {
	-- 	nextEditSuggestions = {
	-- 		enabled = true,
	-- 	},
	-- },
	root_dir = vim.uv.cwd(),
}
