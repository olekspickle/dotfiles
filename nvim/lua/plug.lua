-- [[ plug.lua ]]

return require('packer').startup({
    function(use)
        -- File tree 
        use({                                           -- filesystem navigation
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons',         -- filesystem icons
            }
        })
        use 'voldikss/vim-floaterm'                     -- floating windows


        -- [[ Dev ]]
        use 'majutsushi/tagbar'                         -- code structure
        use 'Yggdroot/indentLine'                       -- see indentation
        use 'tpope/vim-fugitive'                        -- git integration
        use 'junegunn/gv.vim'                           -- commit history
        use 'windwp/nvim-autopairs' 

        -- Rust analyzer support
        use 'simrat39/rust-tools.nvim'

        -- Debugging
        use 'mfussenegger/nvim-dap'

        -- fuzzy search
        use 'nvim-lua/popup.nvim'
        use 'nvim-lua/plenary.nvim'
        use {
          'nvim-telescope/telescope.nvim',              -- fuzzy finder
          requires = { {'nvim-lua/plenary.nvim'} }
        }
       
        
        -- Collection of common configurations for the Nvim LSP client
        use 'neovim/nvim-lspconfig'

        -- Completion framework
        use 'hrsh7th/nvim-cmp'
        -- LSP completion source for nvim-cmp
        use 'hrsh7th/cmp-nvim-lsp'
        -- Other usefull completion sources
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-buffer'

        -- [[ Theme ]]
        use 'mhinz/vim-startify'                        -- start screen 'vim/nvim'
        use  'DanilaMihailov/beacon.nvim'               -- cursor jump
        use {
          'nvim-lualine/lualine.nvim',                  -- statusline
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

