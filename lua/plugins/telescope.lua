-- lua/plugins/telescope.lua
local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

telescope.setup({
  defaults = {
    prompt_prefix = "  ",
    selection_caret = " ",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
      width = 0.9,
      height = 0.9,
    },
  },
})

