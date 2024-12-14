local config = require('nvim-treesitter.configs')
config.setup({
    ensure_installed = { "rust", "ron", "toml", "dockerfile", "lua", "bash", "javascript", "python", "go", "c", "vim", "vimdoc" },
    -- Automatically install missing parsers when entering buffer
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            -- scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
        }
    },

    -- Function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        vim.notify(lang, vim.log.levels.INFO)
        if lang == "rust" or lang == "c" then
            return true
        end
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
})

-- [[ Reset default indent line behavior ]]
vim.g.indentLine_setColors = 0
vim.g.indentLine_enabled = 0

