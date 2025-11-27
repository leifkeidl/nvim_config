-- lua/plugins/autoformat.lua
-- PURPOSE:
--   - Use vim-autoformat for Ruby
--   - No autoformat on save; formatting is manual (via <leader>kf)

return {
    "vim-autoformat/vim-autoformat",

    init = function()
        ---------------------------------------------------------------------
        -- Disable verbose mode (prevents rubocop/rbeautify spam)
        ---------------------------------------------------------------------
        vim.g.autoformat_verbosemode = 0

        ---------------------------------------------------------------------
        -- Ruby formatters to try in order
        --
        -- REQUIRED terminal installs:
        --   gem install rubocop
        --   gem install ruby-beautify
        ---------------------------------------------------------------------
        vim.g.formatters_ruby = { "rubocop", "rbeautify" }

        ---------------------------------------------------------------------
        -- NOTE:
        -- We DO NOT autoformat on save anymore.
        -- Formatting is triggered manually via <leader>kf (see keybinds.lua).
        ---------------------------------------------------------------------
    end,
}
