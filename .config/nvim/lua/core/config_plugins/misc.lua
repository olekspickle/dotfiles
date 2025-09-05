-- for small setups of plugins

-- undo-tree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {desc = "toggle undo tree"})

-- vim-fugitive
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, {desc = "git status"})

-- enable no-neck-pain on enter
-- require('no-neck-pain').setup{ autocmds = { enableOnVimEnter = true } }
