return {
  {
    "dmmulroy/ts-error-translator.nvim",
    config = true,
  },
  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
      "svelte",
      "python",
    },
    opts = {
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte",
        "python",
      },
      jsx_brackets = true,
      remove_template_string = true,
      restore_quotes = {
        normal = [[']],
        jsx = [["]],
      },
    },
  },
}
