return {
  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost",
    opts = {
      useLspFoldsWithTreesitterFallback = {
        enabled = false, -- Use instant, synchronous Treesitter foldexpr so views match exactly
      },
      autoFold = {
        enabled = false, -- Preserve user folds; do not force-autofold on open
      },
      pauseFoldsOnSearch = true,
      foldKeymaps = {
        setup = true, -- 'h' on fold closes it, 'l' on fold opens it
      },
    },
  },
}
