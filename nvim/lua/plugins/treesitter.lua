return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "go",
        "gomod",
        "gowork",
        "gosum",
        "javascript",
        "typescript",
        "tsx", -- React / JSX support
        "html",
        "css",
        "python",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<C-S-Space>",
        },
      },
    },
    config = function(_, opts)
      -- Neovim 0.12+ compatibility shim:
      -- Query matches pass captured nodes as TSNode[] instead of single TSNode.
      -- Unwrap the list if present so method calls like node:type() succeed.
      local query = vim.treesitter.query
      local function unwrap(node)
        if type(node) == "table" then
          return node[#node]
        end
        return node
      end

      local html_script_type_languages = {
        ["importmap"] = "json",
        ["module"] = "javascript",
        ["application/ecmascript"] = "javascript",
        ["text/ecmascript"] = "javascript",
      }

      local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        uxn = "uxntal",
        ts = "typescript",
      }

      local function get_parser_from_markdown_info_string(injection_alias)
        local match = vim.filetype.match({ filename = "a." .. injection_alias })
        return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
      end

      query.add_predicate("kind-eq?", function(match, _, _, pred)
        local node = unwrap(match[pred[2]])
        local types = { unpack(pred, 3) }
        if not node then
          return true
        end
        return vim.tbl_contains(types, node:type())
      end, { force = true })

      query.add_predicate("nth?", function(match, _, _, pred)
        local node = unwrap(match[pred[2]])
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
          return node:parent():named_child(n) == node
        end
      end, { force = true })

      query.add_predicate("is?", function(match, _, bufnr, pred)
        local locals = require("nvim-treesitter.locals")
        local node = unwrap(match[pred[2]])
        local types = { unpack(pred, 3) }
        if not node then
          return true
        end
        local _, _, kind = locals.find_definition(node, bufnr)
        return vim.tbl_contains(types, kind)
      end, { force = true })

      query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local capture_id = pred[2]
        local node = unwrap(match[capture_id])
        if not node then
          return
        end
        local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
        local configured = html_script_type_languages[type_attr_value]
        if configured then
          metadata["injection.language"] = configured
        else
          local parts = vim.split(type_attr_value, "/", {})
          metadata["injection.language"] = parts[#parts]
        end
      end, { force = true })

      query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local capture_id = pred[2]
        local node = unwrap(match[capture_id])
        if not node then
          return
        end
        local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
      end, { force = true })

      query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = unwrap(match[id])
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
        if not metadata[id] then
          metadata[id] = {}
        end
        metadata[id].text = string.lower(text)
      end, { force = true })

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
