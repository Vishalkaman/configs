-- ==============================================================================
-- Neovim Options - Clean, Distraction-Free & Fast
-- ==============================================================================

local opt = vim.opt

-- Set Leader and LocalLeader to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw in favor of oil.nvim
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line Numbers
-- opt.number = true
-- opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = false -- Disabled: smartindent breaks JS/TS/JSX (imposes archaic C rules)

-- Search Behavior
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Clipboard Integration (fixes clipboard issue between Neovim & OS)
opt.clipboard = "unnamedplus"

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Persistent Undo & Files
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Performance & Delays
opt.updatetime = 200
opt.timeoutlen = 300

-- Folding (Instant Treesitter-based folds with persistent state)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "0"          -- Distraction-free (0 column)
opt.foldlevel = 99
opt.foldlevelstart = -1       -- Do not force-open all folds on buffer load; preserve saved views!
opt.foldenable = true
opt.viewoptions = { "cursor", "folds" }

-- Do not auto-insert comment leader when opening a new line
opt.formatoptions:remove({ "c", "r", "o" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
