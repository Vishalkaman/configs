return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      -- Helper to restore folds after Telescope opens a file
      -- (Telescope has an internal hack that resets foldmethod="expr", which wipes out views unless reloaded)
      local open_with_folds = function(action)
        return function(prompt_bufnr)
          action(prompt_bufnr)
          vim.defer_fn(function()
            if vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
              vim.cmd("silent! loadview")
            end
          end, 40)
        end
      end

      return {
        defaults = {
          prompt_prefix = " ❯ ",
          selection_caret = "❯ ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          file_ignore_patterns = {
            "node_modules/",
            "node_modules",
            "%.git/",
            "%.cache",
            "%.next",
            "dist/",
            "build/",
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<CR>"] = open_with_folds(actions.select_default),
              ["<C-s>"] = open_with_folds(actions.select_horizontal),
              ["<C-v>"] = open_with_folds(actions.select_vertical),
              ["<C-t>"] = open_with_folds(actions.select_tab),
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ["<CR>"] = open_with_folds(actions.select_default),
              ["<C-s>"] = open_with_folds(actions.select_horizontal),
              ["<C-v>"] = open_with_folds(actions.select_vertical),
              ["<C-t>"] = open_with_folds(actions.select_tab),
              ["q"] = actions.close,
              ["<C-c>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--hidden",
              "--exclude",
              ".git",
              "--exclude",
              "node_modules",
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              borderchars = {
                prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
              },
              width = 0.8,
              previewer = false,
              prompt_title = false,
            }),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
    keys = {
      -- File Pickers
      { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (text search)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Open Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume Last Picker" },
      { "<leader>fc", function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end, desc = "Neovim Config Files" },

      -- LSP & Symbol Pickers (Functions, Variables, Classes, etc.)
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols in Buffer (vars/functions)" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols (project-wide)" },
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

      -- Help & Misc
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },

      -- Git Pickers
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Tracked Files" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
    },
  },
}
