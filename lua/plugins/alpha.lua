local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- try to load ascii.nvim
local has_ascii, ascii = pcall(require, "ascii")

-- fallback header (your cabin)
local default_header = {
  [[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
  [[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
  [[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
  [[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
}

-- start with fallback
local header = default_header

if has_ascii then
  local ok, art = pcall(function()
    -- global pool, scoped to text/neovim
    return ascii.get_random("text", "neovim")
  end)

  if ok and type(art) == "table" and #art > 0 then
    header = art
  end
end

dashboard.section.header.val = header

dashboard.section.buttons.val = {
  dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
  dashboard.button("t", "  Browse cwd", ":NvimTreeOpen<CR>"), -- this assumes you actually have nvim-tree
  dashboard.button("r", "  Browse src", ":e ~/.local/src/<CR>"),
  dashboard.button("s", "󰯂  Browse scripts", ":e ~/scripts/<CR>"),
  dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
  dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/config/mappings.lua<CR>"),
  dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
  -- ascii browser from dashboard
  dashboard.button("a", "󰉿  ASCII browser", ":lua require('ascii').preview()<CR>"),
  dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
}

dashboard.section.footer.val = function()
  return vim.g.startup_time_ms or "[[  ]]"
end

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)

