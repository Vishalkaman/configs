-- ==============================================================================
-- Neovim Autocmds - Preserving Folds Across Sessions
-- ==============================================================================

local fold_augroup = vim.api.nvim_create_augroup("PersistentFolds", { clear = true })

local function should_save_view(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype
  local filename = vim.api.nvim_buf_get_name(buf)

  if buftype ~= "" or filename == "" then
    return false
  end

  local ignored_ft = {
    oil = true,
    lazy = true,
    mason = true,
    TelescopePrompt = true,
    help = true,
    gitcommit = true,
    gitrebase = true,
    nofile = true,
    quickfix = true,
  }

  if ignored_ft[filetype] then
    return false
  end

  return vim.fn.filereadable(filename) == 1
end

-- Save folds whenever leaving a window or writing the buffer
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
  group = fold_augroup,
  pattern = "*",
  callback = function(args)
    if should_save_view(args.buf) then
      vim.cmd("silent! mkview")
    end
  end,
})

-- Load folds whenever entering a window
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = fold_augroup,
  pattern = "*",
  callback = function(args)
    if should_save_view(args.buf) then
      vim.cmd("silent! loadview")
    end
  end,
})

-- Highlight on yank
local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Prevent multiline HTML <a> tags in JSX/TSX from underlining leading whitespace
vim.api.nvim_create_autocmd({ "FileType", "ColorScheme" }, {
  group = vim.api.nvim_create_augroup("NoHtmlLinkUnderline", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "htmlLink", { underline = false })
  end,
})
