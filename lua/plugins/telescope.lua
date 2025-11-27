return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local builtin      = require("telescope.builtin")
        local pickers      = require("telescope.pickers")
        local finders      = require("telescope.finders")
        local conf         = require("telescope.config").values
        local actions      = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        -- Basic Telescope binds
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

        ---------------------------------------------------------------------
        -- 20 guaranteed-good themes (no broken ones)
        ---------------------------------------------------------------------
        local schemes = {
            "tokyonight",
            "tokyonight-storm",
            "tokyonight-night",
            "tokyonight-day",
            "tokyonight-moon",

            "industry",
            "evening",
            "morning",
            "blue",
            "desert",
            "elflord",
            "habamax",
            "koehler",
            "luna",
            "murphy",
            "peachpuff",
            "quiet",
            "ron",
            "slate",
            "torte",
            "wildcharm",
        }

        ---------------------------------------------------------------------
        -- Color Picker
        ---------------------------------------------------------------------
local function colorscheme_picker()
    local schemes = vim.fn.getcompletion("", "color")

    pickers.new({}, {
        prompt_title = "Colorschemes",
        finder = finders.new_table(schemes),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local function apply(close_after, save)
                local entry = action_state.get_selected_entry()
                if not entry then return end
                local name = entry[1]

                if _G.ApplyColorScheme then
                    _G.ApplyColorScheme(name, save)
                else
                    pcall(vim.cmd.colorscheme, name)
                end

                if close_after then
                    actions.close(prompt_bufnr)
                end
            end

            map("i", "<CR>", function() apply(true, false) end)
            map("n", "<CR>", function() apply(true, false) end)

            map("i", "<C-p>", function() apply(false, false) end)
            map("n", "<C-p>", function() apply(false, false) end)

            map("i", "<C-s>", function() apply(true, true) end)
            map("n", "<C-s>", function() apply(true, true) end)

            return true
        end,
    }):find()
end

vim.keymap.set("n", "<leader>yc", colorscheme_picker, { desc = "Telescope colorschemes" })
                      

        -- YOUR KEYBIND: Change "tc" to "yc" if you want
        vim.keymap.set("n", "<leader>yc", colorscheme_picker, { desc = "Telescope colorschemes" })
    end,
}
