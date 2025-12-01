-- lua/plugins/cmp.lua
-- Completion setup: nvim-cmp + LuaSnip + LSP source

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load VSCode-style snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),          -- manually trigger
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept selected

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },    -- LSP suggestions
    { name = "luasnip" },     -- snippet expansions
  }, {
    { name = "buffer" },      -- words from current buffer
    { name = "path" },        -- filesystem paths
  }),
})

