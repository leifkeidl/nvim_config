-- lua/plugins/autoformat.lua
-- PURPOSE:
--   - Use vim-autoformat for Ruby
--   - Autoformat BEFORE saving with no spam output

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
        -- Autoformat Ruby BEFORE saving
        -- (THIS ensures the formatted version is written to disk)
        ---------------------------------------------------------------------
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.rb", "Gemfile", "Rakefile" },
            callback = function()
                vim.cmd("Autoformat")
            end,
        })

        ---------------------------------------------------------------------
        -- NOTE:
        -- vim-autoformat requires the Neovim Python provider.
        -- Install one of the following once (you choose):
        --
        -- Arch:
        --   sudo pacman -S python-pynvim
        --
        -- Pip:
        --   pip install --user pynvim
        --
        -- Verify:
        --   :checkhealth provider
        ---------------------------------------------------------------------
    end,
}
