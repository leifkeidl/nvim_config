vim.g.mapleader = " "

---------------------------------------------------------------------
-- FILE EXPLORER
---------------------------------------------------------------------
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })

---------------------------------------------------------------------
-- UNIVERSAL FORMAT KEY: <leader>kf
--  - Ruby: uses vim-autoformat (:Autoformat)
--  - Others: use LSP formatting if available
--  - Never runs automatically on save.
---------------------------------------------------------------------
local function leader_format()
    local ft = vim.bo.filetype

    -- Prefer vim-autoformat for Ruby
    if ft == "ruby" and vim.fn.exists(":Autoformat") == 2 then
        vim.cmd("silent! Autoformat")
        return
    end

    -- Fallback: LSP formatting if client attached
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if clients and #clients > 0 then
        vim.lsp.buf.format({ async = true })
        return
    end

    -- Nothing available
    vim.notify("No formatter available for this buffer", vim.log.levels.WARN)
end

vim.keymap.set(
    "n",
    "<leader>kf",
    leader_format,
    { desc = "Format buffer (Ruby via Autoformat, else LSP)", silent = true }
)

---------------------------------------------------------------------
-- PERSISTENT BOTTOM TERMINAL
---------------------------------------------------------------------
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
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        close_term()
    else
        open_term()
    end
end

vim.keymap.set(
    "n",
    "<leader>t",
    ToggleTerminal,
    { desc = "Toggle bottom terminal", nowait = true, silent = true }
)

-- Quit / escape
vim.keymap.set(
    "t",
    "<Esc>",
    [[<C-\><C-n>]],
    { desc = "Exit terminal mode", nowait = true, silent = true }
)

vim.keymap.set(
    { "n", "t" },
    "<leader>q",
    function() close_term() end,
    { desc = "Close terminal", nowait = true, silent = true }
)

---------------------------------------------------------------------
-- RESIZE TERMINAL
---------------------------------------------------------------------
local function resize_terminal(delta)
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        term_height = math.max(5, term_height + delta)
        vim.api.nvim_win_set_height(term_win, term_height)
    end
end

-- Ctrl+Down / Ctrl+Up
vim.keymap.set(
    { "n", "t" },
    "<C-Down>",
    function() resize_terminal(-2) end,
    { desc = "Shrink terminal", nowait = true, silent = true }
)

vim.keymap.set(
    { "n", "t" },
    "<C-Up>",
    function() resize_terminal(2) end,
    { desc = "Grow terminal", nowait = true, silent = true }
)

-- Alt+j / Alt+k
vim.keymap.set(
    { "n", "t" },
    "<M-j>",
    function() resize_terminal(-2) end,
    { desc = "Shrink terminal (Alt+j)", nowait = true, silent = true }
)

vim.keymap.set(
    { "n", "t" },
    "<M-k>",
    function() resize_terminal(2) end,
    { desc = "Grow terminal (Alt+k)", nowait = true, silent = true }
)
