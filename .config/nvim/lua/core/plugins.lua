-- [[ lazy.lua ]]
return require('lazy').setup({
    {
        -- brutal vim motions enforcer
        {
            "m4xshen/hardtime.nvim",
            lazy = false,
            dependencies = { "MunifTanjim/nui.nvim" },
            opts = {
                disabled_keys = {
                    -- disable up/down for touchpad scrolling
                    ["<Up>"] = false,
                    ["<Down>"] = false,
                },
            },
        },
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {
                -- add any options here
            },
            dependencies = {
                "MunifTanjim/nui.nvim",
            }
        },
        -- Awesome lightweight overall life improvement collection of plugins
        { 'echasnovski/mini.nvim', version = false },
        -- [[ Theme ]]
        -- statusline. TODO: configure mini.statusline
        'nvim-lualine/lualine.nvim',
        -- colorizer #000000
        'norcalli/nvim-colorizer.lua',
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
        {
            "nvim-treesitter/nvim-treesitter",
            commit = "c91122d2012682301df68307cfc049a57c3fd286"
        },
        -- Log syntax highlighting
        'mtdl9/vim-log-highlighting',
        { 'm00qek/baleia.nvim', tag = 'v1.4.0' },
        -- cool screenshot maker
        {'mistricky/codesnap.nvim', build = 'make'},

        -- Rust LSP
        { 'mrcjkb/rustaceanvim',
            version = '^6',
            lazy = false, -- This plugin is already lazy
        },
        -- Debugging
        -- Fully fledged debugger inside nvim
        -- 'mfussenegger/nvim-dap',
        -- "rcarriga/nvim-dap-ui",
        -- 'theHamsta/nvim-dap-virtual-text',
        -- 'nvim-telescope/telescope-dap.nvim',

        -- Find and replace with rg
        'MagicDuck/grug-far.nvim',
        'mbbill/undotree',
        {
            "smoka7/multicursors.nvim",
            event = "VeryLazy",
            dependencies = {
                'nvimtools/hydra.nvim',
            },
            opts = {},
            cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
            keys = {
                {
                    mode = { 'v', 'n' },
                    '<leader>t',
                    '<cmd>MCstart<cr>',
                    desc = 'Create a selection for selected text or word under the cursor',
                },
            },
        },

        -- Collection of common configurations for the Nvim LSP client
        'neovim/nvim-lspconfig',    -- popular LSP configs
        'onsails/lspkind.nvim',     -- pictograms for completion

        -- Backup for snippets and completion in case mini.completions\snippets break
        -- 'hrsh7th/nvim-cmp',
        -- 'hrsh7th/cmp-path',      -- get completions based on path
        -- 'hrsh7th/cmp-buffer',    -- get completiong based on buffer (works without LSP)
        -- 'hrsh7th/cmp-nvim-lsp',
        -- 'hrsh7th/cmp-nvim-lua',
        -- 'saadparwaiz1/cmp_luasnip',
        -- 'L3MON4D3/LuaSnip',

        -- Ollama with zephyr setup
        "David-Kunz/gen.nvim",


        -- uncomment reload and run :Bloat. It will produce file in /home/$USER that you can upload to https://esbuild.github.io/analyze/
        -- {
        --     "dundalek/bloat.nvim",
        --     cmd = "Bloat",
        -- },
    }
})

