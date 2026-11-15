return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })

      -- HTML/JSX attribute rule: typing '=' on an attribute expands to `=""`
      -- with cursor positioned inside quotes
      local function is_html_attribute(line, col)
        local prefix = line:sub(1, col - 1)
        local tag_pattern = "<[%a_][%w%._%-]*%s+[^>]*$"
        if not prefix:match(tag_pattern) then
          return false
        end
        local last_char = prefix:sub(-1)
        return last_char:match("[%a%d%-_]") ~= nil
      end

      npairs.add_rules({
        Rule("=", '""', {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "tsx",
          "jsx",
          "xml",
          "vue",
          "svelte",
        })
          :with_pair(cond.not_inside_quote())
          :with_pair(function(opts)
            return is_html_attribute(opts.line, opts.col)
          end)
          :set_end_pair_length(1)
          :with_move(cond.none()),
      })

      -- nvim-cmp integration: auto-insert `()` after selecting functions/methods
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
