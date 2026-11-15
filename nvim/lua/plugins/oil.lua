return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "echasnovski/mini.icons", opts = {} },
      {
        "malewicz1337/oil-git.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = {
          -- Performance optimizations for large repositories:
          -- 1. Async & debounced execution avoids blocking Neovim thread
          -- 2. Disabling crawling ignored files (e.g. node_modules, build artifacts)
          -- 3. Disabling deep directory tree walking prevents lag in massive repos
          show_ignored_files = false,
          show_directory_highlights = false,
          show_file_highlights = true,
          show_status_symbols = true,
        },
      },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = false,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["q"] = "actions.close",
      },
    },
  },
}
