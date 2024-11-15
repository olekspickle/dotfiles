-- [[ packer.lua ]]

return require('packer').startup({
    function(use)

        -- utils used in multiple plugins
        use 'nvim-lua/plenary.nvim'
        -- File Tree
        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
        }
        -- fuzzy search
        use 'nvim-lua/popup.nvim'
        use 'nvim-telescope/telescope-ui-select.nvim'
        use {
            'nvim-telescope/telescope.nvim',              -- fuzzy finder
            requires = { 
                {'nvim-lua/plenary.nvim'},
                { "nvim-telescope/telescope-live-grep-args.nvim" }
            },
            config = function()
                require("telescope").setup({
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown({}),
                        },
                    },
                })
                local builtin = require("telescope.builtin")
                vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
                vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

                require("telescope").load_extension("ui-select")
                require("telescope").load_extension("live_grep_args")
            end,
        }

        -- [[ Dev ]]
        use 'voldikss/vim-floaterm'                     -- floating windows
        -- KDL syntax highlight
        use 'imsnif/kdl.vim'

        -- cool screenshot maker
        use { "mistricky/codesnap.nvim", build = "make" }

        -- Debugging
        -- Syntax AST highlighting
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
        }
        -- Log syntax highlighting
        use 'mtdl9/vim-log-highlighting'
        use { 'm00qek/baleia.nvim', tag = 'v1.3.0' }

        -- Fully fledged debugger inside nvim
        -- use 'vlopes11/rrust.nvim'
        use 'mfussenegger/nvim-dap'
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

        use 'majutsushi/tagbar'                         -- code structure
        use 'lukas-reineke/indent-blankline.nvim'       -- see indentation
        use 'tpope/vim-fugitive'                        -- git integration
        use 'junegunn/gv.vim'                           -- commit history
        use 'windwp/nvim-autopairs'                     -- braces autopairing
        use 'numToStr/Comment.nvim'                     -- comments

        -- Collection of common configurations for the Nvim LSP client
        -- Rust analyzer support
        use 'neovim/nvim-lspconfig'
        use 'simrat39/rust-tools.nvim'
        -- Completion framework
        use 'hrsh7th/nvim-cmp'
        -- LSP completion source for nvim-cmp
        use 'hrsh7th/cmp-nvim-lsp'
        -- Other usefull completion sources
        use 'hrsh7th/cmp-nvim-lua'
        use 'hrsh7th/cmp-nvim-lsp-signature-help'
        use 'hrsh7th/cmp-vsnip'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/vim-vsnip'

        -- [[ Theme ]]
        use 'mhinz/vim-startify'                        -- start screen 'vim/nvim'
        use  'DanilaMihailov/beacon.nvim'               -- cursor jump
        use {
            'nvim-lualine/lualine.nvim',                -- statusline
            requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true
            }
        }

        -- actual themes
        use 'Mofiqul/dracula.nvim'
        use 'neanias/everforest-nvim'
        use 'folke/tokyonight.nvim'
        use { "catppuccin/nvim", as = "catppuccin" }

        -- Speedup startup time ()
        use 'lewis6991/impatient.nvim'

        -- Persistent undo
        -- use 'mbbill/undotree'


    end,
    config = {
        package_root = vim.fn.stdpath('config') .. '/site/pack'
    },
})

