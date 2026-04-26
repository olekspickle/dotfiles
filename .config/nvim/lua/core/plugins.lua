local plugins = {
    {
        src = 'folke/noice.nvim',
        dependencies = {
            { src = 'MunifTanjim/nui.nvim' },
            { src = 'hrsh7th/nvim-cmp' },
        },
    },
    { src = 'echasnovski/mini.nvim' },
    { src = 'nvim-lualine/lualine.nvim' },
    { src = 'norcalli/nvim-colorizer.lua' },
    { src = 'folke/tokyonight.nvim' },
    {
        src = 'nvim-tree/nvim-tree.lua',
        config = function()
            require("nvim-tree").setup({
                sort = { sorter = "case_sensitive" },
                view = { width = 30 },
                renderer = { group_empty = true },
            })
            vim.keymap.set('n', '<C-b>', '<cmd>NvimTreeToggle<cr>', { desc = "Toggle NvimTree" })
        end,
    },
    {
        src = 'nvim-telescope/telescope.nvim',
        dependencies = {
            { src = 'nvim-lua/plenary.nvim' },
        },
    },
    { src = 'tpope/vim-fugitive' },
    { src = 'imsnif/kdl.vim' },
    {
        src = 'nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    { src = 'mtdl9/vim-log-highlighting' },
    { src = 'm00qek/baleia.nvim', version = 'v1.4.0' },
    {
        src = 'mistricky/codesnap.nvim',
        build = function() vim.cmd('make') end,
    },
    { src = 'mrcjkb/rustaceanvim', version = 'v9.0.1' },
    { src = 'mfussenegger/nvim-dap' },
    {
        src = 'igorlfs/nvim-dap-view',
        version = 'v1.1.1',
    },
    { src = 'MagicDuck/grug-far.nvim' },
    {
        src = 'smoka7/multicursors.nvim',
        dependencies = {
            { src = 'nvimtools/hydra.nvim' },
        },
    },
    { src = 'neovim/nvim-lspconfig' },
    { src = 'David-Kunz/gen.nvim' },
    { src = 'supermaven-inc/supermaven-nvim' },
    {
        src = 'ThePrimeagen/99',
        config = function()
            local _99 = require("99")
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)
            _99.setup({
                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    print_on_error = true,
                },
                tmp_dir = "/tmp/",
                completion = {
                    custom_rules = {
                        "~/.config/opencode/",
                    },
                    files = {
                        exclude = { ".env", ".env.*", "node_modules", ".git", "target" },
                    },
                    source = "native",
                },
                md_files = {
                    "AGENT.md",
                },
            })

            vim.keymap.set("v", "<leader>9v", function() _99.visual() end)
            vim.keymap.set("n", "<leader>9x", function() _99.stop_all_requests() end)
            vim.keymap.set("n", "<leader>9s", function() _99.search() end)
        end,
    },
}

vim.cmd("packadd! nvim.undotree")
vim.cmd("packadd! nvim.difftool")

_G.setup_plugins(plugins)
