require("mini.comment").setup {}
require("mini.completion").setup {}
require("mini.pairs").setup {}
require("mini.starter").setup {}
-- require("mini.statusline").setup {}
require("mini.indentscope").setup {}
require("mini.tabline").setup {}
require("mini.trailspace").setup {}
require("mini.files").setup {
  options = {
    use_as_default_explorer = false,
  },
}
require("mini.sessions").setup {
    directory = vim.fn.stdpath "config" .. "/sessions",
}

local minimap = require("mini.map")
minimap.setup {
    symbols = {
        -- - Line - '🮚', '▶'.
        -- - View - '╎', '┋', '┋'.
        scroll_line = '▶',
        scroll_view = '┋',
    },
    window = {
        show_integration_count = false,
        width = 7,
        winblend = 25,
        zindex = 10,
    },
}
require("mini.surround").setup {
    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
    highlight_duration = 1000,
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },
    -- silent = true,
}

-- Mini plugins key mappings
vim.keymap.set('n', '<Leader>mc', minimap.close)
vim.keymap.set('n', '<Leader>mf', minimap.toggle_focus)
vim.keymap.set('n', '<Leader>mo', minimap.open)
vim.keymap.set('n', '<Leader>mr', minimap.refresh)
vim.keymap.set('n', '<Leader>ms', minimap.toggle_side)
vim.keymap.set('n', '<Leader>mt', minimap.toggle)

vim.keymap.set('n', '<leader>b', MiniFiles.open)

