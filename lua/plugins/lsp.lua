-- lua/plugins/lsp.lua

-- capabilities for nvim-cmp
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

---------------------------------------------------------------------------
-- Global diagnostic config (stricter + more visual)
---------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- inline diagnostic symbol
    severity = { min = vim.diagnostic.severity.HINT },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

---------------------------------------------------------------------------
-- Common keymaps for ALL LSPs, set on LspAttach
---------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local opts = { buffer = bufnr, noremap = true, silent = true }
    local map = vim.keymap.set

    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K",  vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "[d", vim.diagnostic.goto_prev, opts)
    map("n", "]d", vim.diagnostic.goto_next, opts)
    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Rust-only tweaks
    if client.name == "rust_analyzer" then
      map("n", "<leader>rd", function()
        vim.diagnostic.open_float(nil, { scope = "cursor" })
      end, opts)
    end
  end,
})

---------------------------------------------------------------------------
-- PYTHON: pyright
---------------------------------------------------------------------------
vim.lsp.config("pyright", {
  capabilities = cmp_capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})

---------------------------------------------------------------------------
-- RUST: rust-analyzer
---------------------------------------------------------------------------
vim.lsp.config("rust_analyzer", {
  capabilities = cmp_capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = {
        enable = true,
        command = "clippy",
        extraArgs = {
          "--",
          "--no-deps",
          "-Dclippy::correctness",
          "-Dclippy::complexity",
          "-Wclippy::perf",
          "-Wclippy::pedantic",
        },
      },
      diagnostics = {
        enable = true,
        enableExperimental = true,
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        enable = true,
      },
    },
  },
})

---------------------------------------------------------------------------
-- JAVASCRIPT / JSX (+ TS/TSX if you ever use it): ts_ls
---------------------------------------------------------------------------
vim.lsp.config("ts_ls", {
  capabilities = cmp_capabilities,

  -- make sure it actually attaches to JS/JSX files
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  settings = {
    -- tighten checks for plain JS/JSX
    javascript = {
      suggest = {
        autoImports = true,
      },
      implicitProjectConfig = {
        checkJs = true,        -- type-check JS
        strictNullChecks = true,
      },
    },
    -- if you ever touch TS/TSX this keeps it strict too
    typescript = {
      implicitProjectConfig = {
        strictNullChecks = true,
      },
    },
  },

  -- let prettier/conform/etc handle formatting instead
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

---------------------------------------------------------------------------
-- Neovim Lua config LSP
---------------------------------------------------------------------------
vim.lsp.config("lua_ls", {
  capabilities = cmp_capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

---------------------------------------------------------------------------
-- Enable the servers
---------------------------------------------------------------------------
vim.lsp.enable({
  "pyright",
  "rust_analyzer",
  "lua_ls",
  "ts_ls",   -- <- THIS WAS MISSING, so JS/JSX had no LSP
})

