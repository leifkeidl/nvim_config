-- lua/harpoon.lua (or lua/plugins/harpoon.lua)

local ok_mark, mark = pcall(require, "harpoon.mark")
if not ok_mark then
  return
end

local ok_ui, ui = pcall(require, "harpoon.ui")
if not ok_ui then
  return
end

-- Add current file
vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: add file" })

-- Toggle quick menu
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon: quick menu" })

-- Direct jumps
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon: file 1" })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon: file 2" })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon: file 3" })
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon: file 4" })


