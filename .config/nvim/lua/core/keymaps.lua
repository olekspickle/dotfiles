--[[ keys.lua ]]
-- most of this magic is a soup I respectfully yanked from:
-- ThePrimeagen, mhinz, merikan
-- and other wonderful people I was not smart enough to record here

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- merge options
function m(...)
    local result = {}
    for _, tbl in ipairs{...} do
        for key, value in pairs(tbl) do
            result[key] = value
        end
    end
    return result
end

local map = vim.keymap.set
local defaults = { noremap = true, silent = true }

-- intuitive copy in visual mode
map({'v', "n"}, '<C-c>', '"+y', { noremap = true, desc = "copy" })
-- Previous end of word
map("n", "E", "ge", { desc = "Previous end of word" })
-- make Y behave like C and D
map("n", "Y", "y$", { desc = "Yank to end of line" })
-- paste without yank
map("v", "p", '"_dP', { desc = "Paste without yank" })
-- delete without yanking
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without yank" })
-- delete char without yanking
map({ "n", "v" }, "x", '"_x', { desc = "Delete char without yank" })
map({ "n", "v" }, "X", '"_X', { desc = "Delete char without yank" })
-- reselect pasted text
map("n", "gp", "[v`]", { desc = "Reselect pasted text" })

-- scroll through buffers with Tab
-- kind of useless using mini.tabline with it's neat hjkl motions
-- map('n', '<C-i>', [[:bn<cr>]], {})

-- Unload current buffer
map('n', '<leader>d', [[:bd<cr>]], { desc = "write and unload current"})
-- map for quick quit, save files using leader key
map('n', '<Leader>q', ':q<cr>', { desc = "quit" })
map('n', '<Leader>s', ':w<cr>', m(defaults, { desc = "save" }))
map('n', '<C-x>', ':wq<cr>', { desc = "save and quit" })
map('n', '<Leader>a', ':wqa<cr>', { desc = "save and quit all" })

map('n', '<leader>i', "gg=G''<cr>", m(defaults, { desc = "indent file"}))

-- highlight the current line
map('n', '<Leader>cc', ':set cursorline!<cr>', { desc = "toggle hl current line" })
-- use U for redo :))
map('n', 'U', '<C-r>', {})

-- lazy deps managing panel
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move through buffers
map("n", "<S-h>", "<cmd>bp<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bp<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bn<cr>", { desc = "Next Buffer" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines by Ctrl+[HJKL]
map("n", "<c-j>", "<cmd>m .+1<cr>==", { desc = "move line down" })
map("n", "<c-k>", "<cmd>m .-2<cr>==", { desc = "move line up" })
map("i", "<c-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down" })
map("i", "<c-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move line up" })
map("v", "<c-j>", ":m '>+1<cr>gv=gv", { desc = "move line down" })
map("v", "<c-k>", ":m '<-2<cr>gv=gv", { desc = "move line up" })

-- move up and down a page but leave cursor in the middle: far less disorienting
map("n", "<c-d>", "<C-d>zz", m(defaults, { desc = "Half page down" }))
map("n", "<c-u>", "<C-u>zz", m(defaults, { desc = "half page up" }))
-- search and stay in the middle
map("n", "n", "nzzzv", m(defaults, { desc = "Next search result" }))
map("n", "N", "Nzzzv", m(defaults, { desc = "Prev search result" }))
-- leave cursor in place after join
map("n", "J", "mzJ`z", { desc = "move line up" })
-- duplicate line(s) with Alt+d
map("i", "<A-d>", "<Esc>yypi", { desc = "Duplicate line(s)" })
map("n", "<A-d>", "<Esc>yyp", { desc = "Duplicate line(s)" })
map("v", "<A-d>", "oYPgv<Esc>gv=gv", { desc = "Duplicate line(s)" })

map('n', '<leader>h', ':lua vim.o.hlsearch = not vim.o.hlsearch<CR>', m(defaults, {desc = "toggle hlsearch"}))

-- quickfix nav (TODO: figure out later)
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- better diagnostic
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

--  Mode letters:
--    n: normal only
--    v: visual and select
--    o: operator-pending
--    x: visual only
--    s: select only
--    i: insert
--    c: command-line
--    t: terminal window
--    l: insert, command-line, regexp-search (and others. Collectively called "Lang-Arg" pseudo-mode)
