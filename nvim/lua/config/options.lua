local opt = vim.opt
local g = vim.g
local api = vim.api

-- General options
opt.backup = false
opt.clipboard = "unnamedplus"
opt.cmdheight = 0
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.smartindent = true
opt.swapfile = false
opt.undofile = true
opt.updatetime = 300
opt.timeoutlen = 1000
opt.writebackup = false
opt.termguicolors = true
opt.pumheight = 10
opt.showmode = true
opt.showtabline = 1
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.signcolumn = "yes"
opt.colorcolumn = "100"
opt.mouse = ""
opt.linebreak = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.tags = "tags"
opt.hidden = false
opt.shortmess:append("c")
--opt.whichwrap:append { "<", ">", "[", "]", "h", "l" }
opt.path:append "**"
opt.wildignore:append { "*pyc", ".git/**", "node_modules/**", "python-virtualenv/**", ".venv/**" }
opt.iskeyword:append("-")

-- Filetype overrides
vim.filetype.add({
  extension = {
    cls = "apex",
    trigger = "apex",
    apex = "apex",
  },
})

-- NetRW settings
g.netrw_winsize = 17
g.netrw_banner = 0
g.netrw_altv = 1
g.netrw_liststyle = 3

-- Explore command alias
api.nvim_create_user_command("Explore", function()
  vim.cmd("silent Explore")
end, {})

-- Linting on InsertLeave or BufWritePost
api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then lint.try_lint() end
  end,
})

-- Autocommands
local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- General settings
api.nvim_create_autocmd("FileType", {
  group = augroup("_general_settings"),
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})

api.nvim_create_autocmd("TextYankPost", {
  group = augroup("_yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

api.nvim_create_autocmd("BufWinEnter", {
  group = augroup("_format_options"),
  callback = function()
    pcall(function()
      vim.opt_local.formatoptions:remove("c"):remove("r"):remove("o")
    end)
  end,
})

api.nvim_create_autocmd("FileType", {
  group = augroup("_qf_hidden"),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

api.nvim_create_autocmd("FileType", {
  group = augroup("_ruby_indent"),
  pattern = "ruby",
  callback = function()
    vim.opt_local.indentkeys:remove(".")
  end,
})

-- Git commit
api.nvim_create_autocmd("FileType", {
  group = augroup("_git"),
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Markdown
api.nvim_create_autocmd("FileType", {
  group = augroup("_markdown"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto resize windows
api.nvim_create_autocmd("VimResized", {
  group = augroup("_auto_resize"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Alpha dashboard UI tweaks
api.nvim_create_autocmd("User", {
  group = augroup("_alpha"),
  pattern = "AlphaReady",
  callback = function()
    vim.opt.showtabline = 0
    api.nvim_create_autocmd("BufUnload", {
      buffer = 0,
      callback = function()
        vim.opt.showtabline = 2
      end,
    })
  end,
})

-- Python
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_python"),
  pattern = "*.py",
  callback = function()
    vim.opt_local.colorcolumn = "88"
  end,
})

-- Jinja2
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_jinja2"),
  pattern = "*.jinja2",
  callback = function()
    vim.opt_local.syntax = "django"
  end,
})

-- Apex (Salesforce) indentation
api.nvim_create_autocmd("FileType", {
  group = augroup("_apex"),
  pattern = "apex",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- Go formatting
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("_go"),
  pattern = "*.go",
  callback = function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 2000,
    })
  end,
})
