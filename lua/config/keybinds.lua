vim.g.mapleader = " "

-- File explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })

-- Persistent bottom terminal
local term_buf, term_win = nil, nil
local term_height = 15

local function open_term()
vim.cmd("botright split")
vim.api.nvim_win_set_height(0, term_height)
term_win = vim.api.nvim_get_current_win()
if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
    else
        vim.api.nvim_win_set_buf(term_win, term_buf)
        end
        vim.cmd("startinsert")
        end

        local function close_term()
        if term_win and vim.api.nvim_win_is_valid(term_win) then
            vim.api.nvim_win_close(term_win, true)
            term_win = nil
            end
            end

            function ToggleTerminal()
            if term_win and vim.api.nvim_win_is_valid(term_win) then close_term() else open_term() end
                end

                vim.keymap.set("n", "<leader>t", ToggleTerminal, { desc = "Toggle bottom terminal", nowait = true, silent = true })

                -- Quit / escape
                vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode", nowait = true, silent = true })
                vim.keymap.set({ "n", "t" }, "<leader>q", function() close_term() end, { desc = "Close terminal", nowait = true, silent = true })

                -- Reliable resize keys:
                -- Ctrl+Down / Ctrl+Up  (works in Konsole, Kitty, Alacritty, etc.)
                local function resize_terminal(delta)
                if term_win and vim.api.nvim_win_is_valid(term_win) then
                    term_height = math.max(5, term_height + delta)
                    vim.api.nvim_win_set_height(term_win, term_height)
                    end
                    end
                    vim.keymap.set({ "n", "t" }, "<C-Down>", function() resize_terminal(-2) end, { desc = "Shrink terminal", nowait = true, silent = true })
                    vim.keymap.set({ "n", "t" }, "<C-Up>",   function() resize_terminal( 2) end, { desc = "Grow terminal",   nowait = true, silent = true })

                    -- Optional alternates if you prefer home-row:
                    -- Alt+j / Alt+k (usually reliable in Konsole)
                    vim.keymap.set({ "n", "t" }, "<M-j>", function() resize_terminal(-2) end, { desc = "Shrink terminal (Alt+j)", nowait = true, silent = true })
                    vim.keymap.set({ "n", "t" }, "<M-k>", function() resize_terminal( 2) end, { desc = "Grow terminal (Alt+k)",   nowait = true, silent = true })
