vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
            local opts = { noremap = true, buffer = bufnr }
            -- seems to be the same as definition in rust
            -- vim.keymap.set('n', 'gD', vim.cmd.RustLsp {'declaration'}, merge(opts, {desc = ""}))
            vim.keymap.set('n', 'gd', vim.cmd.RustLsp {'definition'}, merge(opts, {desc = "definition"}))
            vim.keymap.set('n', 'gi', vim.cmd.RustLsp {'implementation'}, merge(opts, {desc = "impl"}))
            vim.keymap.set('n', 'K', vim.cmd.RustLsp {'hover'}, merge(opts, {desc = "hover"}))
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, merge(opts, {desc = "type def"}))
            vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, merge(opts, {desc = "signature help"}))
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, merge(opts, {desc = ""}))
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.cmd.RustLsp {'hover', 'actions'}, merge(opts, {desc = "code actions"}))
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, merge(opts, {desc = "refs"}))
            vim.keymap.set('n', '<leader>i', vim.cmd.RustLsp {}, merge(opts, {desc = "format"}))
        end,
        default_settings = {
            ['rust-analyzer'] = {
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}

-- local format_sync_grp = vim.api.nvim_create_augroup("RustaceanFormat", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     buffer = bufnr,
--     pattern = "*.rs",
--     callback = function() vim.lsp.buf.format() end,
--     group = format_sync_grp,
-- })
