local M = {}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set <leader>
vim.g.mapleader = " "

function M.setup()
	---- General ----
	-- Better window navigation
	keymap("n", "<C-h>", "<C-w>h", opts)
	keymap("n", "<C-j>", "<C-w>j", opts)
	keymap("n", "<C-k>", "<C-w>k", opts)
	keymap("n", "<C-l>", "<C-w>l", opts)

	-- Resize with arrows
	keymap("n", "<C-Up>", ":resize -2<CR>", opts)
	keymap("n", "<C-Down>", ":resize +2<CR>", opts)
	keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
	keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

	-- Splits
	keymap("n", "ss", ":split<CR>", opts)
	keymap("n", "vv", ":vsplit<CR>", opts)

	-- Terminal splits
	keymap("n", "tss", ":new<CR>:terminal<CR>", opts)
	keymap("n", "tvv", ":vnew<CR>:terminal<CR>", opts)

	-- Remove highlight
	keymap("n", "//", ":noh<CR>", opts)

	-- Buffer navigation
	keymap("n", "<S-l>", ":bnext<CR>", opts)
	keymap("n", "<S-h>", ":bprevious<CR>", opts)
	keymap("n", "<Leader>qq", ":bd<CR>", opts)

	-- Clipboard
	keymap({"n", "v"}, "<Leader>y", '"+y', opts)
	keymap("n", "<Leader>p", '"+p', opts)

	---- Telescope ----
	keymap("n", "<Leader>f", ":Telescope find_files previewer=false theme=get_dropdown<CR>", opts)
	keymap("n", "<Leader>F", ":Telescope current_buffer_fuzzy_find<CR>", opts)
	keymap("n", "<Leader>b", ":Telescope buffers theme=ivy<CR>", opts)
	keymap("n", "<Leader>g", ":Telescope live_grep<CR>", opts)
	keymap("n", "<Leader>G", ":Telescope grep_string<CR>", opts)
	keymap("n", "<Leader>o", ":Telescope oldfiles<CR>", opts)
	keymap("n", "<Leader>m", ":Telescope marks bufnr=0<CR>", opts)
	keymap("n", "<Leader>s", ":Telescope lsp_document_symbols<CR>", opts)

	---- LSP ----
	-- LSP keybindings (these will be overridden by buffer-local keymaps when LSP attaches)
	keymap("n", "gR", ":Telescope lsp_references<CR>", opts)
	keymap("n", "gD", vim.lsp.buf.declaration, opts)
	keymap("n", "<leader>ld", ":Telescope lsp_definitions<CR>", opts)
	keymap("n", "gd", vim.lsp.buf.definition, opts)
	keymap("n", "<leader>li", ":Telescope lsp_implementations<CR>", opts)
	keymap("n", "gi", vim.lsp.buf.implementation, opts)
	keymap("n", "gt", ":Telescope lsp_type_definitions<CR>", opts)
	keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
	keymap("n", "<leader>D", ":Telescope diagnostics bufnr=0<CR>", opts)
	keymap("n", "<leader>ld", vim.diagnostic.open_float, opts)
	keymap("n", "]d", vim.diagnostic.goto_next, opts)
	keymap("n", "[d", vim.diagnostic.goto_prev, opts)
	keymap("n", "K", vim.lsp.buf.hover, opts)
	keymap("n", "<leader>rs", ":LspRestart<CR>", opts)

	-- Legacy telescope keybindings (kept for compatibility)
	keymap("n", "<Leader>r", ":Telescope lsp_references<CR>", opts)

	---- Visual ----
	keymap("v", "<", "<gv", opts)
	keymap("v", ">", ">gv", opts)

	---- Plugins ----
	-- NvimTree
	keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", opts)

	---- Salesforce ----
	keymap("n", "<Leader>sd", function()
		vim.cmd("split | terminal sf project deploy start --source-dir " .. vim.fn.expand("%") .. " --wait 10")
	end, { desc = "Deploy current file" })

	keymap("n", "<Leader>st", function()
		local filename = vim.fn.expand("%:t:r")
		vim.cmd("split | terminal sf force apex test run --classnames " .. filename .. " --resultformat human")
	end, { desc = "Test current class" })

	keymap("n", "<Leader>sr", function()
		vim.cmd("split | terminal sf project retrieve start --source-dir " .. vim.fn.expand("%") .. " --json")
	end, { desc = "Retrieve current file" })

	keymap("n", "<Leader>so", ":!sf config set target-org ", { desc = "Set target org" })
end

return M
