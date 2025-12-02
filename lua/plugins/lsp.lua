-- lua/plugins/lsp.lua

-- capabilities for nvim-cmp
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

---------------------------------------------------------------------------
-- Global diagnostic config (stricter + more visual)
---------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- nicer symbol for inline diagnostics
    severity = { min = vim.diagnostic.severity.HINT },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


---------------------------------------------------------------------------
-- Common keymaps for ALL LSPs, set on LspAttach (new recommended style)
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
      -- Hover actions / diagnostic float at cursor
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
      -- Run clippy on save with aggressive lints
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
-- (Optional) Neovim Lua config LSP
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
-- Enable the servers (this actually turns them on)
---------------------------------------------------------------------------
vim.lsp.enable({ "pyright", "rust_analyzer", "lua_ls" })

