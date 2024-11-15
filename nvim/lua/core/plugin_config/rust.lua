local rt = require("rust-tools")

--local mason_registry = require("mason-registry")
--local codelldb = mason_registry.get_package("codelldb")
--local extension_path = codelldb:get_install_path() .. "/extension/"
--local codelldb_path = extension_path .. "adapter/codelldb"
--local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

local function on_attach(client, buffer)
    local opts = { buffer = buffer }
    -- This callback is called when the LSP is atttached/enabled for this buffer
    -- we could set keymaps related to LSP, etc here.
    --       -- Hover actions
    --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --       -- Code action groups
    --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    vim.keymap.set("n", "<leader>k", rt.hover_actions.hover_actions, opts)
    vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, opts)
    vim.keymap.set("n", "<leader>gd", rt.definition.definition, opts)
    vim.keymap.set("n", "gd", rt.definition.definition, opts)

    -- vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
end

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            -- auto = false,
            only_current_line = true,
            -- show_parameter_hints = false,
            -- parameter_hints_prefix = "<-",
            -- other_hints_prefix = "=>",
            -- max_len_align = false,
            -- max_len_align_padding = 1,
            -- right_align = false,
            -- right_align_padding = 7,
            highlight = "Comment",
        },
    },
    hover_actions = {
        auto_docus = true,
        -- the border that is used for the hover window
        -- see vim.api.nvim_open_win()
        border = {
            { "╭", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╮", "FloatBorder" },
            { "│", "FloatBorder" },
            { "╯", "FloatBorder" },
            { "─", "FloatBorder" },
            { "╰", "FloatBorder" },
            { "│", "FloatBorder" },
        },
    },
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = {'/home/pickle/.local/bin/rust-analyzer'},
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}

-- Highlight errors, clippy warnings and docs background
vim.api.nvim_set_hl(0, 'NormalFloat', {link='Visual'})
-- vim.api.nvim_set_hl(0, 'NormalFloat', {bg='#fcf6c2'})
rt.setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
    -- preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Add tab support
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },

    -- Installed sources
    sources = {
        { name = 'path' },                              -- file paths
        { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
        { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 2 },        -- source current buffer
        { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
        { name = 'calc'},                               -- source for math calculation
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

-- local keymap_opts = { buffer = buffer }
-- -- Code navigation and shortcuts
-- vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
-- vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
-- vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
-- vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
-- vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
-- vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)
