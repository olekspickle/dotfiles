require('telescope').setup({ file_ignore_patterns = { "node%_modules/.*" } })
local builtin = require('telescope.builtin')

vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live grep"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "grep help tags"})
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "grep file name"})
vim.keymap.set('v', '<leader>f', builtin.grep_string, { desc = "grep selected string"})
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, { desc = "grep old files"})
