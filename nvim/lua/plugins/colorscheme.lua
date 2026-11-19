return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
            syn = {
              comment = "#E58B58", -- Warm, soft autumn orange (clearly visible, not harsh or overly red)
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Warm, comfortable orangish comments replacing the harsh reddish tone
          Comment = { fg = "#E58B58", italic = true },
          ["@comment"] = { fg = "#E58B58", italic = true },
          ["@comment.documentation"] = { fg = "#FFA066", italic = true },
          ["@comment.todo"] = { fg = "#1F1F28", bg = "#E58B58", bold = true },
          ["@comment.note"] = { fg = "#1F1F28", bg = "#7FB4CA", bold = true },

          -- Line numbers & active line
          LineNr = { fg = "#727169" },
          CursorLineNr = { fg = "#E58B58", bold = true },

          -- Origami folds (warm and clearly distinguished)
          Folded = { fg = "#FFA066", bg = "#22222E" },
          FoldColumn = { fg = "#E58B58", bg = "none" },

          -- Search and match
          Search = { fg = "#1F1F28", bg = "#FFA066" },
          CurSearch = { fg = "#1F1F28", bg = "#E58B58" },

          -- Disable underline on HTML/JSX links to prevent weird lines through indent whitespace
          htmlLink = { underline = false },
          ["@markup.link"] = { underline = false },
          ["@markup.link.url"] = { underline = false },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
