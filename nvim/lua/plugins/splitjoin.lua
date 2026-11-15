return {
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Toggle Split / Join Block" },
      { "<leader>j", "<cmd>TSJJoin<cr>", desc = "Join Block" },
      { "gS", "<cmd>TSJSplit<cr>", desc = "Split Block" },
      { "gJ", "<cmd>TSJJoin<cr>", desc = "Join Block" },
      { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Code: Toggle Split / Join" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
      cursor_behavior = "hold",
      notify = true,
      dot_repeat = true,
    },
  },
}
