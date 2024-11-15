-- [[ lazy.lua ]]
return require('lazy').setup({
    {
        -- Awesome lightweight overall life improvement collection of plugins
        { 'echasnovski/mini.nvim', version = false },
        "nvim-tree/nvim-web-devicons",
        "nvim-lualine/lualine.nvim",
        -- [[ Theme ]]
        'DanilaMihailov/beacon.nvim',           -- cursor jump
        'nvim-lualine/lualine.nvim',            -- statusline
        -- actual themes
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        'Mofiqul/dracula.nvim',
        'neanias/everforest-nvim',
        'folke/tokyonight.nvim',
        -- File Tree
        'nvim-tree/nvim-tree.lua',
        -- fuzzy search
        { "nvim-telescope/telescope.nvim", tag = "0.1.4", dependencies = { "nvim-lua/plenary.nvim" }},

        -- [[ Dev ]]
        -- KDL syntax highlight
        'imsnif/kdl.vim',
        -- Syntax AST highlighting
        "nvim-treesitter/nvim-treesitter",
        -- Log syntax highlighting
        'mtdl9/vim-log-highlighting',
        { 'm00qek/baleia.nvim', tag = 'v1.4.0' },
        -- cool screenshot maker
        {'mistricky/codesnap.nvim', build = 'make'},

        -- Rust support
        { 'mrcjkb/rustaceanvim', version = '^4',
            lazy = false, -- This plugin is already lazy
        },
        -- Debugging
        -- Fully fledged debugger inside nvim
        'mfussenegger/nvim-dap',
        "rcarriga/nvim-dap-ui",
        'theHamsta/nvim-dap-virtual-text',
        'nvim-telescope/telescope-dap.nvim',

        -- Find and replace with rg
        'MagicDuck/grug-far.nvim',
        -- Collection of common configurations for the Nvim LSP client
        'neovim/nvim-lspconfig',
        -- Completion
        -- "hrsh7th/nvim-cmp",
        -- 'hrsh7th/cmp-nvim-lsp',
        -- 'hrsh7th/cmp-nvim-lua',
        -- 'hrsh7th/cmp-nvim-lsp-signature-help',
        -- 'hrsh7th/cmp-buffer',
        -- 'hrsh7th/cmp-path',
        -- 'hrsh7th/cmp-vsnip',
        -- 'hrsh7th/vim-vsnip',

        -- Ollama with zephyr setup
        "David-Kunz/gen.nvim",
    }
})

