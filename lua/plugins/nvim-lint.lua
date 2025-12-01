-- lua/plugins/nvim-lint.lua

local M = {}

local lint = require("lint")

-- Set which linters run for each filetype
lint.linters_by_ft = {
  -- Lua: use luacheck (much better than luac)
  lua = { "luacheck" },

  -- Python: ruff
  python = { "ruff" },

  -- Shell scripts: use shellcheck (not "bash")
  sh = { "shellcheck" },
  bash = { "shellcheck" },

  -- C: cppcheck
  c = { "cppcheck" },

  -- Rust: clippy (runs via cargo)
  rust = { "clippy" },

  -- CSS / HTML
  css = { "stylelint" },
  html = { "htmlhint" },
}

-- Auto-run linter on write and when leaving insert mode
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    -- try_lint() will pick the right linter based on filetype
    lint.try_lint()
  end,
})

return M

