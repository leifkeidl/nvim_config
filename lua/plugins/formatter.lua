-- lua/plugins/formatter.lua

local M = {}

function M.setup()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      -- Lua
      lua = { "stylua" },

      -- Python: try ruff_format, then black
      python = { "ruff_format", "black" },

      -- Rust
      rust = { "rustfmt" },

      -- JS / TS / web stuff
      svelte = { "prettierd", "prettier" },
      astro = { "prettierd", "prettier" },
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      graphql = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      scss = { "prettierd", "prettier" },

      -- Other languages you had
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      ruby = { "standardrb" },
      erb = { "htmlbeautifier" },
      html = { "htmlbeautifier" },
      bash = { "beautysh" },
      proto = { "buf" },
      yaml = { "yamlfix" },
      toml = { "taplo" },
      sh = { "shfmt" },      -- formatter, not shellcheck
      go = { "gofmt" },
      xml = { "xmllint" },

      -- Fallback for everything else
      ["*"] = { "trim_newlines", "trim_whitespace" },
    },
  })

  -- <Space> c f: format with Conform
  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 2000,
      stop_after_first = true,  -- first available formatter wins
    })
  end, { desc = "Format buffer or selection" })
end

-- Either call setup here...
M.setup()

return M


