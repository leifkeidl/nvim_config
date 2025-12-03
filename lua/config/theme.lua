
-- lua/config/theme.lua
-- theme choice is saved in a file for persistence on restart

local theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"

-- { colorscheme_name, lualine_theme_name }
local themes = {
  { "monokai-pro", "monokai-pro" }, -- Monokai Pro first in the cycle + default
  { "catppuccin",  "catppuccin" },
  { "gruvbox",     "gruvbox" },
  { "pywal16",     "pywal16-nvim" },
}

local function find_lualine_theme(colorscheme)
  for _, pair in ipairs(themes) do
    if pair[1] == colorscheme then
      return pair[2]
    end
  end
  -- fallback: try using same name
  return colorscheme
end

local function apply_theme(colorscheme, lualine_theme)
  if not colorscheme or colorscheme == "" then
    return
  end

  -- set colorscheme
  local ok = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not ok then
    return
  end

  -- set lualine theme, if available
  local ok_ll, lualine = pcall(require, "lualine")
  if ok_ll then
    lualine_theme = lualine_theme or find_lualine_theme(colorscheme)
    lualine.setup({ options = { theme = lualine_theme } })
  end
end

_G.load_theme = function()
  local file = io.open(theme_file, "r")
  if not file then
    -- fallback default if file doesn't exist
    apply_theme("monokai-pro", "monokai-pro")
    return
  end

  local colorscheme = file:read("*l")
  local lualine_theme = file:read("*l")
  file:close()

  if colorscheme and colorscheme ~= "" then
    apply_theme(colorscheme, lualine_theme)
  else
    apply_theme("monokai-pro", "monokai-pro")
  end
end

local current_theme_index = 1

_G.switch_theme = function()
  current_theme_index = current_theme_index % #themes + 1
  local colorscheme, lualine_theme = unpack(themes[current_theme_index])

  apply_theme(colorscheme, lualine_theme)

  local file = io.open(theme_file, "w")
  if file then
    file:write(colorscheme .. "\n" .. (lualine_theme or ""))
    file:close()
  end
end

-- Persist ANY colorscheme change (Telescope, :colorscheme, etc.)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colorscheme = vim.g.colors_name
    if not colorscheme or colorscheme == "" then
      return
    end

    local lualine_theme = find_lualine_theme(colorscheme)

    -- write to saved_theme file
    local file = io.open(theme_file, "w")
    if file then
      file:write(colorscheme .. "\n" .. (lualine_theme or ""))
      file:close()
    end

    -- keep lualine theme in sync even when changed via Telescope
    local ok_ll, lualine = pcall(require, "lualine")
    if ok_ll then
      lualine.setup({ options = { theme = lualine_theme } })
    end
  end,
})
