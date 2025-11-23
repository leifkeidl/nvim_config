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

    -- Apply theme safely
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

        -- Only set lualine theme if it exists
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

-- Global for Telescope
_G.ApplyColorScheme = apply_colorscheme

return {
    {
        "folke/tokyonight.nvim",
        config = function()
            local saved = load_saved_theme()
            apply_colorscheme(saved or "tokyonight", false)
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            theme = "tokyonight", -- overridden by apply_colorscheme
        },
    },
}
