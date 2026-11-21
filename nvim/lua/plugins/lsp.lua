return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Load lspconfig defaults
      local lspconfig = require("lspconfig")

      -- Setup Mason
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Global LSP keymaps using the modern LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local map = function(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
          end

          local telescope = function(builtin_func, opts)
            return function()
              require("telescope.builtin")[builtin_func](opts or {})
            end
          end

          -- Navigation via Telescope pickers
          map("n", "gd", telescope("lsp_definitions"), "LSP: Definitions (Telescope)")
          map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to Declaration")
          map("n", "gr", telescope("lsp_references"), "LSP: References (Telescope)")
          map("n", "gi", telescope("lsp_implementations"), "LSP: Implementations (Telescope)")
          map("n", "<leader>lt", telescope("lsp_type_definitions"), "LSP: Type Definitions")

          -- Symbol Pickers (Functions, Variables, Types, Classes)
          map("n", "<leader>ls", telescope("lsp_document_symbols"), "LSP: Buffer Symbols (vars/functions)")
          map("n", "<leader>lS", telescope("lsp_dynamic_workspace_symbols"), "LSP: Workspace Symbols")

          -- Diagnostics
          map("n", "<leader>ld", telescope("diagnostics", { bufnr = 0 }), "LSP: Document Diagnostics")
          map("n", "<leader>lD", telescope("diagnostics"), "LSP: Project Diagnostics")
          map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics (Float)")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

          -- Hover, Rename, Code Actions & Formatting
          map("n", "K", vim.lsp.buf.hover, "LSP: Hover Documentation")
          map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: Rename Symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action (Telescope)")
          map("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format Document")
          map("n", "<leader>lh", function()
            local current = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
            vim.lsp.inlay_hint.enable(not current, { bufnr = ev.buf })
          end, "Toggle Inlay Hints")

          -- JS / TS Specific Code Actions
          map("n", "<leader>co", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports.ts", "source.organizeImports" }, diagnostics = {} },
              apply = true,
            })
          end, "Organize Imports")
          map("n", "<leader>ci", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
              apply = true,
            })
          end, "Add Missing Imports")
          map("n", "<leader>cu", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.removeUnusedImports.ts", "source.removeUnused.ts" }, diagnostics = {} },
              apply = true,
            })
          end, "Remove Unused Imports")
          map("n", "<leader>cf", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.fixAll.ts" }, diagnostics = {} },
              apply = true,
            })
          end, "Fix All TypeScript Issues")
        end,
      })

      -- List of language servers to install
      local servers = {
        "tailwindcss",  -- Tailwind CSS
        "html",         -- HTML
        "cssls",        -- CSS
      }

      -- Faster TypeScript/JavaScript language server: tsgo (Microsoft Go-based TS compiler)
      if vim.fn.executable("tsgo") == 1 then
        lspconfig.tsgo = {
          default_config = {
            cmd = { "tsgo", "--lsp", "--stdio" },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
          },
        }
        vim.lsp.config("tsgo", {
          cmd = { "tsgo", "--lsp", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
          capabilities = capabilities,
        })
        table.insert(servers, "tsgo")
      else
        table.insert(servers, "ts_ls")
      end

      -- Faster Python language server: ty (Astral's Rust-based Python type checker & LSP)
      if vim.fn.executable("ty") == 1 then
        lspconfig.ty = {
          default_config = {
            cmd = { "ty", "server" },
            filetypes = { "python" },
            root_dir = lspconfig.util.root_pattern(
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              "Pipfile",
              ".git"
            ),
          },
        }
        vim.lsp.config("ty", {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            ".git",
          },
          capabilities = capabilities,
        })
        table.insert(servers, "ty")
      else
        table.insert(servers, "basedpyright")
      end

      -- Only include gopls if go is installed on system to avoid errors
      if vim.fn.executable("go") == 1 then
        table.insert(servers, "gopls")
      end

      -- Setup mason-lspconfig with automatic installation
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_filter(function(server)
          -- tsgo and ty are managed externally (native / cargo / uv)
          return server ~= "tsgo" and server ~= "ty"
        end, servers),
        automatic_installation = true,
      })

      -- Configure global capabilities
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      if vim.fn.executable("tsgo") ~= 1 then
        vim.lsp.config("ts_ls", {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        })
      end

      -- Enable all configured language servers
      vim.lsp.enable(servers)

      -- Distraction-free diagnostics: no noisy inline virtual text
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },
}
