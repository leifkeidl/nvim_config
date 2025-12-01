-- lua/plugins/formatter.lua

local M = {}

function M.setup()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      svelte = { { "prettierd", "prettier", stop_after_first = true } },
      astro = { { "prettierd", "prettier", stop_after_first = true } },
      javascript = { { "prettierd", "prettier", stop_after_first = true } },
      typescript = { { "prettierd", "prettier", stop_after_first = true } },
      javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
      typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
      json = { { "prettierd", "prettier", stop_after_first = true } },
      graphql = { { "prettierd", "prettier", stop_after_first = true } },
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      ruby = { "standardrb" },
      markdown = { { "prettierd", "prettier", stop_after_first = true } },
      erb = { "htmlbeautifier" },
      html = { "htmlbeautifier" },
      bash = { "beautysh" },
      proto = { "buf" },
      rust = { "rustfmt" },
      yaml = { "yamlfix" },
      toml = { "taplo" },
      css = { { "prettierd", "prettier", stop_after_first = true } },
      scss = { { "prettierd", "prettier", stop_after_first = true } },
      sh = { "shellcheck" },
      go = { "gofmt" },
      xml = { "xmllint" },
    },
  })

  -- Actual formatting keymap: <Space> c f
  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 2000,
    })
  end, { desc = "Format buffer or selection" })
end

M.setup()

return M

