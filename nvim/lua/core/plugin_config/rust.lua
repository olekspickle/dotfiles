vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
            vim.keymap.set('n', 'gD', vim.cmd.RustLsp {}, merge(opts, {desc = ""}))
            vim.keymap.set('n', 'gd', vim.cmd.RustLsp {'definition'}, merge(opts, {desc = "definition"}))
            -- vim.keymap.set('n', 'gi', vim.cmd.RustLsp {''}, merge(opts, {desc = ""}))
            vim.keymap.set('n', 'K', vim.cmd.RustLsp {'hover'}, merge(opts, {desc = ""}))
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, merge(opts, {desc = ""}))
            vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, merge(opts, {desc = ""}))
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, merge(opts, {desc = ""}))
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.cmd.RustLsp {'hover'}, merge(opts, {desc = ""}))
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(opts, {desc = ""}))
            vim.keymap.set('n', '<leader>i', function()
                vim.lsp.buf.format { async = true }
            end, merge(opts, {desc = ""}))
        end,
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}
