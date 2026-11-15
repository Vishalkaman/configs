return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "Find / Telescope" },
        { "<leader>s", group = "Splits & Windows" },
        { "<leader>l", group = "LSP / Symbols" },
        { "<leader>lh", desc = "Toggle Inlay Hints (Optional)" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>ca", desc = "Code Action (Telescope)" },
        { "<leader>co", desc = "Organize Imports" },
        { "<leader>ci", desc = "Add Missing Imports" },
        { "<leader>cu", desc = "Remove Unused Imports" },
        { "<leader>cf", desc = "Fix All (TS)" },
        { "<leader>e", desc = "File Explorer (Oil)" },
        { "<leader>m", desc = "Toggle Split/Join Block" },
        { "<leader>j", desc = "Join Block" },
        { "<leader>w", desc = "Save buffer" },
        { "<leader>q", desc = "Quit window" },
        { "<leader>h", desc = "Clear search highlight" },
        { "s", desc = "Flash Jump" },
        { "S", desc = "Flash Treesitter (Select via letters)" },
        { "ys", desc = "Surround add" },
        { "ds", desc = "Surround delete" },
        { "cs", desc = "Surround change" },
      },
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
