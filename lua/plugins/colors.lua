local theme_file = vim.fn.stdpath("data") .. "/colorscheme.txt"

local function enable_transparency()
    local groups = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
        "SignColumn", "MsgArea", "TelescopeNormal", "TelescopeBorder",
        "TelescopePromptNormal", "TelescopePromptBorder",
        "TelescopeResultsNormal", "TelescopeResultsBorder",
        "TelescopePreviewNormal", "TelescopePreviewBorder",
        "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
        "StatusLineNC", "CursorLine", "CursorColumn",
        "LineNr", "CursorLineNr",
        "EndOfBuffer",
    }

    for _, group in ipairs(groups) do
        pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" })
    end
end

local function save_theme(name)
    local f = io.open(theme_file, "w")
    if f then
        f:write(name)
        f:close()
    end
end

local function load_saved_theme()
    local f = io.open(theme_file, "r")
    if f then
        local theme = f:read("*l")
        f:close()
        return theme
    end
    return nil
end

local function apply_colorscheme(name, save)
    if not name or name == "" then return end
    if save == nil then save = true end

    local ok = pcall(vim.cmd.colorscheme, name)
    if not ok then return end

    enable_transparency()

    if save then
        save_theme(name)
    end

    -- Sync lualine if possible
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine then
        local lualine_theme = "auto"

        if pcall(require, "lualine.themes." .. name) then
            lualine_theme = name
        end

        lualine.setup({
            options = {
                theme = lualine_theme,
            },
        })
    end
end

-- Global for Telescope / anything else
_G.ApplyColorScheme = apply_colorscheme

return {
    -------------------------------------------------------------------------
    -- COLORSCHEME PLUGINS (ALL EAGERLY LOADED)
    -------------------------------------------------------------------------
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local saved = load_saved_theme()
            apply_colorscheme(saved or "tokyonight", false)
        end,
    },

    { "catppuccin/nvim",      name = "catppuccin",      lazy = false, priority = 900 },
    { "ellisonleao/gruvbox.nvim",                       lazy = false, priority = 900 },
    { "rose-pine/neovim",     name = "rose-pine",       lazy = false, priority = 900 },
    { "rebelot/kanagawa.nvim",                         lazy = false, priority = 900 },
    { "EdenEast/nightfox.nvim",                        lazy = false, priority = 900 },
    { "navarasu/onedark.nvim",                         lazy = false, priority = 900 },
    { "shaunsingh/nord.nvim",                          lazy = false, priority = 900 },
    { "nyoom-engineering/oxocarbon.nvim",              lazy = false, priority = 900 },

    -------------------------------------------------------------------------
    -- LUALINE
    -------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = {
            theme = "auto", -- overridden by apply_colorscheme
        },
    },
}

