vim.g.rustaceanvim = {
    tools = {}, -- Plugin configuration
    server = { -- LSP configuration
        on_attach = function(client, bufnr)
            -- any custom magic you want happening for rust files
            -- local opts = { noremap = true, buffer = bufnr }
            -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, m(opts, {desc = "refs"}))
        end,
        default_settings = { ['rust-analyzer'] = { } },
    },
    dap = { },  -- DAP configuration
}

-- local format_sync_grp = vim.api.nvim_create_augroup("RustaceanFormat", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     buffer = bufnr,
--     pattern = "*.rs",
--     callback = function() vim.lsp.buf.format() end,
--     group = format_sync_grp,
-- })
