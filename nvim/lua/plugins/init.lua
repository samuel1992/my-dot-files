return {
	-- Appearance
	{ "nvim-tree/nvim-tree.lua", opts = {} },
	{ "nvim-tree/nvim-web-devicons" },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"https://gitlab.com/HiPhish/resolarized.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme solarized-dark")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local actions = require("telescope.actions")
      local telescope = require("telescope")

      telescope.load_extension("harpoon")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-j>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-k>"] = actions.cycle_history_prev,

							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							["<C-c>"] = actions.close,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,

							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.complete_tag,
							["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
						},

						n = {
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,

							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["H"] = actions.move_to_top,
							["M"] = actions.move_to_middle,
							["L"] = actions.move_to_bottom,

							["<Down>"] = actions.move_selection_next,
							["<Up>"] = actions.move_selection_previous,
							["gg"] = actions.move_to_top,
							["G"] = actions.move_to_bottom,

							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,

							["<PageUp>"] = actions.results_scrolling_up,
							["<PageDown>"] = actions.results_scrolling_down,

							["?"] = actions.which_key,
						},
					},
				},
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"go",
					"elixir",
					"heex",
					"javascript",
					"tsx",
					"html",
					"apex",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- LSP
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()

			local mason_registry = require("mason-registry")
			local tools = { "stylua", "black", "prettier" }

			for _, tool in ipairs(tools) do
				local p = mason_registry.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Lua
			vim.lsp.config("lua_ls", {})
			vim.lsp.enable("lua_ls")

			-- Python
			vim.lsp.config("pyright", {})
			vim.lsp.enable("pyright")

			-- Go
			vim.lsp.config("gopls", {})
			vim.lsp.enable("gopls")

			-- TypeScript/JavaScript
			vim.lsp.config("ts_ls", {})
			vim.lsp.enable("ts_ls")

			-- HTML
			vim.lsp.config("html", {})
			vim.lsp.enable("html")

			-- Elixir
			vim.lsp.config("elixirls", {
				cmd = { "elixir-ls" },
			})
			vim.lsp.enable("elixirls")

			-- Apex LSP using local jar
			vim.lsp.config("apex_ls", {
				cmd = {
					"/usr/bin/java",
					"-cp",
					"/usr/local/bin/apex-jorje-lsp.jar",
					"-Ddebug.internal.errors=true",
					"-Ddebug.semantic.errors=false",
					"-Ddebug.completion.statistics=false",
					"-Dlwc.typegeneration.disabled=true",
					"apex.jorje.lsp.ApexLanguageServerLauncher",
				},
				filetypes = { "apex" },
				root_markers = { "sfdx-project.json", ".git" },
			})
			vim.lsp.enable("apex_ls")
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
						scrollbar = false,
						col_offset = -3,
						side_padding = 0,
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:CmpDoc",
						max_width = 80,
						max_height = 20,
					},
				},
				formatting = {
					format = function(entry, vim_item)
						vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-h>"] = cmp.mapping.abort(),
					["<C-l>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				}),
				sources = {
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp" },
				},
			})
		end,
	},

	-- Copilot
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		-- 'github/copilot.vim',
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = true,
				},
				suggestion = {
					enabled = false,
				},
				filetypes = {
					yaml = false,
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},

	-- Git
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					markdown = { "prettier" },
					go = { "gofmt", "goimports" },
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				require("conform").format({ lsp_fallback = true, timeout_ms = 5000 })
			end)
		end,
	},

	-- Tmux integration with nvim
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup({
				copy_sync = {
					enable = false,
				},
			})
		end,
	},

	-- Avante

	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			-- add any opts here
			-- this file can contain specific instructions for your project
			instructions_file = "avante.md",
			-- for example
			provider = "deepseek",
			providers = {
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder",
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	-- Markdown previewer
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
      local telescope = require("telescope")

			harpoon.setup()

			vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
			vim.keymap.set("n", "<leader>hd", function() harpoon:list():remove() end)
      vim.keymap.set("n", "<leader>hm", telescope.extensions.harpoon.marks)

			vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
			vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
		end,
	},
}
