-- for small setups of plugins

-- undo-tree
vim.keymap.set('n', '<leader>u', vim.cmd.Undotree, {desc = "toggle undo tree"})

-- vim-fugitive
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, {desc = "git status"})
vim.keymap.set('n', '<leader>gc', function() vim.cmd("Git commit -v") end, {desc = "git commit"})
vim.keymap.set('n', '<leader>gd', function() vim.cmd("Gdiff") end, {desc = "git diff"})
vim.keymap.set('n', '<leader>gb', vim.cmd.GitBlame, {desc = "git blame"})
vim.keymap.set('n', '<leader>gl', function() vim.cmd("Glog") end, {desc = "git log"})
vim.keymap.set('n', '<leader>gg', '<cmd>G<cr>', {desc = "git open file in gs"})
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<cr>', {desc = "git push"})
vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<cr>', {desc = "git pull"})

-- enable no-neck-pain on enter
-- require('no-neck-pain').setup{ autocmds = { enableOnVimEnter = true } }
