-- ==============================================================================
-- Neovim Keymaps - Fast & Distraction-Free
-- ==============================================================================

local map = vim.keymap.set

-- 1. Insert mode navigation & escape
-- Move within a line in insert mode with Ctrl-h and Ctrl-l
map("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })
map("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })

-- Quick escape: 'jk' in insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Toggle comment (Ctrl-/ and Ctrl-_ for all terminal formats)
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle line comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle line comment" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle selection comment" })
map("v", "<C-_>", "gc", { remap = true, desc = "Toggle selection comment" })
map("i", "<C-/>", "<cmd>normal gcc<CR>", { desc = "Toggle line comment" })
map("i", "<C-_>", "<cmd>normal gcc<CR>", { desc = "Toggle line comment" })

-- Add line below (Ctrl-Enter) and line above (Ctrl-Shift-Enter) in both insert and normal mode
-- Equivalent to Esc + o (below) and Esc + O (above)
map("n", "<C-CR>", "o", { desc = "Add line below" })
map("n", "<C-Enter>", "o", { desc = "Add line below" })
map("n", "<Esc>[13;5u", "o", { desc = "Add line below" })

map("i", "<C-CR>", "<Esc>o", { desc = "Add line below" })
map("i", "<C-Enter>", "<Esc>o", { desc = "Add line below" })
map("i", "<Esc>[13;5u", "<Esc>o", { desc = "Add line below" })

map("n", "<C-S-CR>", "O", { desc = "Add line above" })
map("n", "<C-S-Enter>", "O", { desc = "Add line above" })
map("n", "<Esc>[13;6u", "O", { desc = "Add line above" })

map("i", "<C-S-CR>", "<Esc>O", { desc = "Add line above" })
map("i", "<C-S-Enter>", "<Esc>O", { desc = "Add line above" })
map("i", "<Esc>[13;6u", "<Esc>O", { desc = "Add line above" })

-- Incremental selection (init & expand: Ctrl-Space, shrink: Ctrl-Shift-Space or Backspace)
map("n", "<C-space>", function()
  require("nvim-treesitter.incremental_selection").init_selection()
end, { desc = "Init incremental selection" })

map("x", "<C-space>", function()
  require("nvim-treesitter.incremental_selection").node_incremental()
end, { desc = "Expand selection" })

map("x", "<C-S-Space>", function()
  require("nvim-treesitter.incremental_selection").node_decremental()
end, { desc = "Shrink selection" })

map("x", "<C-S-space>", function()
  require("nvim-treesitter.incremental_selection").node_decremental()
end, { desc = "Shrink selection" })

map("x", "<bs>", function()
  require("nvim-treesitter.incremental_selection").node_decremental()
end, { desc = "Shrink selection (fallback)" })

-- 2. Pane Navigation (Ctrl-h, Ctrl-j, Ctrl-k, Ctrl-l)
-- Seamless integration with tmux provided by vim-tmux-navigator plugin

-- 3. Distraction-Free General Keymaps
-- Clear search highlights with <leader>h
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- File Explorer (Oil)
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Explorer (Oil)" })

-- Fast save and quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Better visual mode indentation (stays in visual mode after indenting)
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling half-page
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
