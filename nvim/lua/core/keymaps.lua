--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap
local defaults = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigate vim panes better(conflicts with zellij)
-- vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', {})
-- vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', {})
-- vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', {})
-- vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', {})

-- intuitive copy in visual mode
map('v', '<C-c>', '"+y', { noremap = true })
-- scroll through buffers with Tab
map('n', '<C-i>', [[:bn<cr>]], {})
-- map for quick quit, save files using leader key
-- Write and unload current buffer
map('n', '<C-d>', [[:w<cr>:bd<cr>]], {})
map('n', '<Leader>q', ':q<cr>', {})
map('n', '<Leader>w', ':w<cr>', {})
map('n', '<Leader>a', ':wqa<cr>', {})
map('n', '<Leader>x', ':wq<cr>', {})
-- write and sync current buffer immediately. Useful when editing nvim setup
map('n', '<Leader>s', ':w<cr>:source %<cr>', {})

-- Immediate insert mode
map('i', ';w', '<esc>:write<CR>', {})
map('i', ';x', '<esc>:wq<CR>', {})

-- map for quick open the file init.lua
map('n', '<leader>nv', ':vsplit ~/.config/nvim/init.lua<cr>', {})

-- use U for redo :))
map('n', 'U', '<C-r>', {})



local function rust_fmt()
    -- Set up Rust-specific key mappings
    map('n', '<Leader>i', ':!cargo fmt', {})
end

-- Check if the current file has a ".rs" extension
-- autocmd BufRead,BufNewFile *.rs call s:SetupRust()
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--     pattern = {"*.rs"},
--     callback = function(ev)
--             print(string.format('event fired: s', vim.inspect(ev)))
--     end
-- })
