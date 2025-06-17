return {

	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		config = true,
	},

	-- file explorer
	{
		"stevearc/oil.nvim",
		config = function()
			function _G.get_oil_winbar()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
				local dir = require("oil").get_current_dir(bufnr)
				if dir then
					return vim.fn.fnamemodify(dir, ":~")
				else
					return vim.api.nvim_buf_get_name(0)
				end
			end

			local detail = false

			require("oil").setup({
				win_options = { winbar = "%!v:lua.get_oil_winbar()" },
				keymaps = {
					["gd"] = {
						desc = "Toggle file detail view",
						callback = function()
							detail = not detail
							if detail then
								require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
							else
								require("oil").set_columns({ "icon" })
							end
						end,
					},
				},
			})
			vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" })
		end,
	},

	-- llm
	{
		"olimorris/codecompanion.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
		keys = {
			{ "<leader>aa", "<Cmd>CodeCompanionActions<CR>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
			{ "<leader>ac", "<Cmd>CodeCompanionChat<CR>",    desc = "CodeCompanion Chat",    mode = { "n", "v" } },
			{
				"<leader>ae",
				function()
					local prompt = vim.fn.input("Inline Assistant: ")
					if prompt ~= "" then
						vim.cmd.CodeCompanion(prompt)
					end
				end,
				mode = { "n", "v" },
				desc = "CodeCompanion Inline Assistant",
			},
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = { model = { default = "o4-mini" } },
					})
				end,
				deepseek = function()
					return require("codecompanion.adapters").extend("deepseek", {
						url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
						env = { api_key = "ALIYUN_API_KEY" },
						schema = {
							model = {
								default = "deepseek-r1",
								choices = { ["deepseek-r1"] = { opts = { can_reason = true } } },
							},
						},
					})
				end,
				aliyun_qwen = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						name = "aliyun_qwen",
						env = {
							url = "https://dashscope.aliyuncs.com/compatible-mode",
							api_key = "ALIYUN_API_KEY",
						},
						schema = {
							model = {
								default = "qwen-max-0125",
								choices = {
									"qwen-max-0125",
									["qwq-plus-2025-03-05"] = { opts = { can_reason = true } },
								},
							},
						},
					})
				end,
			},
			display = {
				chat = {
					window = {
						opts = {
							conceallevel = 2,
							colorcolumn = "",
							number = false,
							relativenumber = false,
						},
					},
				},
				diff = { provider = "mini_diff" },
			},
			strategies = {
				chat = {
					tools = {
						["mcp"] = {
							callback = function()
								return require("mcphub.extensions.codecompanion")
							end,
							description = "Call tools and resources from the MCP Servers",
						},
					},
				},
			},
			prompt_library = {
				["Revision"] = {
					strategy = "chat",
					description = "Academic Revision Assistant",
					opts = { modes = { "v" } },
					prompts = {
						{
							role = "user",
							content = [[
You are an AI writing assistant with expertise in academic writing and algebraic geometry using LaTeX.
Your task is to revise provided academic text excerpts to enhance clarity, conciseness,
and grammatical accuracy while preserving all mathematical precision and LaTeX formatting.
Ensure that the revised text maintains the formal tone appropriate for a research paper.
When you receive a text input, output an improved version that adheres to these guidelines.
]],
						},
					},
				},
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		cmd = "MCPHub",
		build = "bundled_build.lua",
		config = function()
			require("mcphub").setup({
				port = 3000,
				use_bundled_binary = true,
			})
		end,
	},

	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		opts = {
			icons = { fileIconsProvider = "mini.icons" },
			keymaps = { close = { n = "q" } },
		},
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({ prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	-- flash navigation.
	{
		"folke/flash.nvim",
		config = function()
			require("flash").setup()

			-- stylua: ignore start
			vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
			vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
			vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
			vim.keymap.set({ "x", "o" }, "R", function() require("flash").treesitter_search() end,
				{ desc = "Treesitter Search" })
			vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
			-- stylua: ignore end
		end,
	},

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, lhs, rhs, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- stylua: ignore start
				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					{ desc = "Stage Hunk" })
				map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					{ desc = "Reset Hunk" })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Undo Stage Hunk" })

				map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame Line" })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })
				map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { desc = "Diff This (File)" })

				map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "Set qflist (all)" })
				map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set qflist" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })
				-- stylua: ignore end

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk)
			end,
		},
	},
}
