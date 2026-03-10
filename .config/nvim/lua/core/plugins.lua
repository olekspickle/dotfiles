-- [[ lazy.lua ]]

-- o.rocks.enabled = false
return require('lazy').setup({
    {
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            dependencies = { "MunifTanjim/nui.nvim", "hrsh7th/nvim-cmp" }
        },
        -- {
        --     "aikhe/wrapped.nvim",
        --     dependencies = { "nvzone/volt" },
        --     cmd = { "WrappedNvim" },
        --     opts = {},
        -- },
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
        {
            'nvim-tree/nvim-tree.lua',
            event = "VeryLazy",
            keys = {{ "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" }},
            config = function()
                require("nvim-tree").setup({
                    sort = { sorter = "case_sensitive" },
                    view = { width = 30 },
                    renderer = { group_empty = true },
                })
            end,
        },
        -- fuzzy search
        {
            "nvim-telescope/telescope.nvim",
            tag = "v0.2.0",
            dependencies = { "nvim-lua/plenary.nvim" }
        },

        -- [[ Dev ]]
        -- git
        'tpope/vim-fugitive',

        -- KDL syntax highlight
        'imsnif/kdl.vim',

        -- Syntax AST highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            -- commit = "c91122d2012682301df68307cfc049a57c3fd286"
        },

        -- Log syntax highlighting
        'mtdl9/vim-log-highlighting',
        { 'm00qek/baleia.nvim', tag = 'v1.4.0' },

        -- cool screenshot maker
        { 'mistricky/codesnap.nvim', build = 'make' },

        -- Rust LSP
        { 'mrcjkb/rustaceanvim', version = '^6', lazy = false },
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
        -- 'hrsh7th/cmp-path',      -- get completions based on path
        -- 'hrsh7th/cmp-buffer',    -- get completiong based on buffer (works without LSP)
        -- 'hrsh7th/cmp-nvim-lsp',
        -- 'hrsh7th/cmp-nvim-lua',

        -- Ollama with zephyr setup
        "David-Kunz/gen.nvim",
        "supermaven-inc/supermaven-nvim",
        {
            "ThePrimeagen/99",
            config = function()
                local _99 = require("99")

                -- For logging that is to a file if you wish to trace through requests
                -- for reporting bugs, i would not rely on this, but instead the provided
                -- logging mechanisms within 99.  This is for more debugging purposes
                local cwd = vim.uv.cwd()
                local basename = vim.fs.basename(cwd)
                _99.setup({
                    -- provider = _99.Providers.ClaudeCodeProvider,  -- default: OpenCodeProvider
                    logger = {
                        level = _99.DEBUG,
                        path = "/tmp/" .. basename .. ".99.debug",
                        print_on_error = true,
                    },
                    -- When setting this to something that is not inside the CWD tools
                    -- such as claude code or opencode will have permission issues
                    -- and generation will fail refer to tool documentation to resolve
                    -- https://opencode.ai/docs/permissions/#external-directories
                    -- https://code.claude.com/docs/en/permissions#read-and-edit
                    tmp_dir = "/tmp/",

                    --- Completions: #rules and @files in the prompt buffer
                    completion = {
                        --- A list of folders where you have your own SKILL.md
                        --- Expected format:
                        --- /path/to/dir/<skill_name>/SKILL.md
                        ---
                        --- Example:
                        --- Input Path:
                        --- "scratch/custom_rules/"
                        ---
                        --- Output Rules:
                        --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
                        --- ... the other rules in that dir ...
                        ---
                        custom_rules = {
                            "~/.config/opencode/",
                        },

                        --- Configure @file completion (all fields optional, sensible defaults)
                        files = {
                            -- enabled = true,
                            -- max_file_size = 102400,     -- bytes, skip files larger than this
                            -- max_files = 5000,            -- cap on total discovered files
                            exclude = { ".env", ".env.*", "node_modules", ".git", "target" },
                        },
                        --- File Discovery:
                        --- - In git repos: Uses `git ls-files` which automatically respects .gitignore
                        --- - Non-git repos: Falls back to filesystem scanning with manual excludes
                        --- - Both methods apply the configured `exclude` list on top of gitignore

                        --- What autocomplete engine to use. Defaults to native (built-in) if not specified.
                        source = "native", -- "native" (default), "cmp", or "blink"
                    },

                    --- WARNING: if you change cwd then this is likely broken ill likely fix this in a later change
                    ---
                    --- md_files is a list of files to look for and auto add based on the location
                    --- of the originating request.  That means if you are at /foo/bar/baz.lua
                    --- the system will automagically look for:
                    --- /foo/bar/AGENT.md
                    --- /foo/AGENT.md
                    --- assuming that /foo is project root (based on cwd)
                    md_files = {
                        "AGENT.md",
                    },
                })

                -- take extra note that i have visual selection only in v mode
                -- technically whatever your last visual selection is, will be used
                -- so i have this set to visual mode so i dont screw up and use an
                -- old visual selection
                --
                -- likely ill add a mode check and assert on required visual mode
                -- so just prepare for it now
                vim.keymap.set("v", "<leader>9v", function()
                    _99.visual()
                end)

                --- if you have a request you dont want to make any changes, just cancel it
                vim.keymap.set("n", "<leader>9x", function()
                    _99.stop_all_requests()
                end)

                vim.keymap.set("n", "<leader>9s", function()
                    _99.search()
                end)
            end,
        },


        -- uncomment reload and run :Bloat. It will produce file in /home/$USER that you can upload to https://esbuild.github.io/analyze/
        -- {
        --     "dundalek/bloat.nvim",
        --     cmd = "Bloat",
        -- },

        -- brutal vim motions enforcer
        -- unfortunately brutally gucks up mouse selection
        -- {
        --     "m4xshen/hardtime.nvim",
        --     lazy = false,
        --     dependencies = { "MunifTanjim/nui.nvim" },
        --     opts = {
        --         disabled_keys = {
        --             -- disable up/down for touchpad scrolling
        --             ["<Up>"] = false,
        --             ["<Down>"] = false,
        --         },
        --     },
        -- },
    }
})

