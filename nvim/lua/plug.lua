-- [[ plug.lua ]]

return require('packer').startup({
    function(use)
        -- File tree 
        use({                                       -- filesystem navigation
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',         -- filesystem icons
        }
    })
    use 'voldikss/vim-floaterm'                     -- floating windows

    -- fuzzy search
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',              -- fuzzy finder
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- [[ Dev ]]
    -- LSP and formatters manager
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    -- Collection of common configurations for the Nvim LSP client
    use 'neovim/nvim-lspconfig'

    -- Debugging
    use 'mfussenegger/nvim-dap'

    use 'majutsushi/tagbar'                         -- code structure
    use 'lukas-reineke/indent-blankline.nvim'       -- see indentation
    use 'tpope/vim-fugitive'                        -- git integration
    use 'junegunn/gv.vim'                           -- commit history
    use 'windwp/nvim-autopairs'                     -- braces autopairing
    use 'numToStr/Comment.nvim'                     -- comments

    -- Rust analyzer support
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
    use 'Mofiqul/dracula.nvim'

    -- Speedup startup time ()
    use 'lewis6991/impatient.nvim'

    -- Persistent undo
    -- use 'mbbill/undotree'


end,
config = {
    package_root = vim.fn.stdpath('config') .. '/site/pack'
},
})

