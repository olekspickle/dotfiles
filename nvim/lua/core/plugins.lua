-- [[ lazy.lua ]]
return require('lazy').setup({
    {
        -- Awesome lightweight overall life improvement collection of plugins
        { 'echasnovski/mini.nvim', version = false },
        -- [[ Theme ]]
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
        -- git
        'tpope/vim-fugitive',
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
        'mbbill/undotree',

        -- Collection of common configurations for the Nvim LSP client
        {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
        'neovim/nvim-lspconfig',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-path',     -- get completions based on path
        'hrsh7th/cmp-buffer',   -- get completiong based on buffer (works without LSP)
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- 'hrsh7th/cmp-nvim-lsp-signature-help',
        -- 'hrsh7th/cmp-vsnip',
        -- 'hrsh7th/vim-vsnip',

        -- Ollama with zephyr setup
        "David-Kunz/gen.nvim",
    }
})

