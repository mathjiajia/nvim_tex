-- local function hasGrandparent(match, _, _, predicate)
-- 	local nodes = match[predicate[2]]
-- 	if not nodes or #nodes == 0 then
-- 		return true
-- 	end
--
-- 	local types = { unpack(predicate, 3) }
-- 	for _, node in ipairs(nodes) do
-- 		local grandparent_type = node:parent():parent():type()
-- 		if vim.list_contains(types, grandparent_type) then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
--
-- local function setPairs(match, _, source, pred, metadata)
-- 	local id = pred[2]
-- 	local key = pred[3]
-- 	local nodes = match[id]
-- 	if not nodes or #nodes == 0 then
-- 		return
-- 	end
--
-- 	for _, node in ipairs(nodes) do
-- 		local nodeText = vim.treesitter.get_node_text(node, source)
-- 		for i = 4, #pred, 2 do
-- 			if nodeText == pred[i] then
-- 				metadata[key] = pred[i + 1]
-- 				break
-- 			end
-- 		end
-- 	end
-- end
--
-- vim.treesitter.query.add_predicate("has-grandparent?", hasGrandparent, { force = true })
-- vim.treesitter.query.add_directive("set-pairs!", setPairs, { force = true, all = true })

return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"bibtex",
					"comment",
					"diff",
					"html",
					"latex",
					"lua",
					"luadoc",
					"luap",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"regex",
					"vim",
					"vimdoc",
				},
				highlight = { enable = true },
			})
		end,
	},
}
