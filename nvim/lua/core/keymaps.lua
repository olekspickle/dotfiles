--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigate vim panes better(conflicts with zellij)
-- vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
-- vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
-- vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
-- vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- remap the key used to leave insert mode
map('i', 'jk', '', {})

-- intuitive copy in visual mode
map('v', '<C-c>', '"+y', { noremap = true })

-- Toggle plugin stuff
-- Tree toggle
map('n', '<C-b>', [[:NvimTreeToggle<cr>]], {})
-- map('n', '<leader>t', [[:TransparentToggle<cr>]], {})

map('n', '<C-i>', [[:bn<cr>]], {}) -- scroll through buffers with Tab
--map('n', 'cs-Right', [[:bn<cr>]], {})
--map('n', 'cs-Left', [[:bp<cr>]], {})
