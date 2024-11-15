require("mini.starter").setup {}
require("mini.tabline").setup {}
require("mini.indentscope").setup {}
require("mini.trailspace").setup {}
require("mini.notify").setup {}
require("mini.comment").setup {}
require("mini.bracketed").setup {}
require("mini.pairs").setup {}
require("mini.completion").setup {
    window = {
        -- info = {  border = ["╔","═","╗","║","╝","═","╚","║"]},
        -- signature = { border = ["╔","═","╗","║","╝","═","╚","║"]},
    },
}

-- require("mini.statusline").setup {}
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

-- Have some clue about what you are about to do. Awesome for learning nvim
local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        -- Bracketed
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },

    clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
    window = {
        delay = 300, -- Delay before showing clue window
        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
})

-- Mini plugins key mappings
-- mini.map
vim.keymap.set('n', '<Leader>mc', minimap.close, {desc = "map close"})
vim.keymap.set('n', '<Leader>mo', minimap.open, {desc = "map close"})
vim.keymap.set('n', '<Leader>ms', minimap.toggle_side, {desc = "map toggle side"})
vim.keymap.set('n', '<Leader>mt', minimap.toggle, {desc = "map toggle"})
-- mini.files
vim.keymap.set('n', '<leader>b', MiniFiles.open, {desc = "open file tree"})
-- mini.cpmpletion
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
