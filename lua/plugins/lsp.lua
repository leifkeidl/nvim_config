-- lua/plugins/lsp.lua
-- Minimal LSP setup using vim.lsp.config / vim.lsp.enable
-- Depends on nvim-lspconfig plugin definitions.

if not vim.lsp or not vim.lsp.enable or not vim.lsp.config then
  return
end

-- Global LSP keymaps via LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})


-- TypeScript / JavaScript / JSX / TSX
vim.lsp.config("ts_ls", {
  -- cmd = { "typescript-language-server", "--stdio" }, -- default
  -- You could add settings here later if you want
})

-- Python
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic", -- or "strict"
        useLibraryCodeForTypes = true,
      }
    }
  }
})

-- Rust
vim.lsp.config("rust_analyzer", {
  -- Example of a common tweak:
  -- settings = {
  --   ["rust-analyzer"] = {
  --     cargo = { allFeatures = true },
  --   },
  -- },
})

-- C / C++
vim.lsp.config("clangd", {
  -- cmd = { "clangd" },
})

-- Java
vim.lsp.config("jdtls", {
  -- jdtls is obnoxious to configure fully; this minimal
  -- setup works as long as `jdtls` is on PATH.
})

vim.lsp.enable({
  "ts_ls",         -- js, jsx, ts, tsx
  "pyright",       -- python
  "rust_analyzer", -- rust
  "clangd",        -- c / c++
  "jdtls",         -- java
})

-- Global diagnostic UI settings
vim.diagnostic.config({
  virtual_text = true,      -- inline text next to the error
  signs = true,             -- symbols in the signcolumn
  underline = true,         -- underline the bad code
  update_in_insert = false, -- don't spam while typing
  severity_sort = true,
})

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,         { silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next,         { silent = true })

