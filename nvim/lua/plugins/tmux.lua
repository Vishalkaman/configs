return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate window left (tmux/nvim)" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate window down (tmux/nvim)" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate window up (tmux/nvim)" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate window right (tmux/nvim)" },
    },
  },
}
