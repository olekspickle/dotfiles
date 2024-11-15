local config = require('nvim-treesitter.configs')
config.setup({
    ensure_installed = { "rust", "ron", "toml", "dockerfile", "lua", "bash", "javascript", "python", "go", "c", "vim", "vimdoc" },
    -- Automatically install missing parsers when entering buffer
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

-- [[ Reset default indent line behavior ]]
vim.g.indentLine_setColors = 0
vim.g.indentLine_enabled = 0

