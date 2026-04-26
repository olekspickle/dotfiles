-- Setup language servers.
--Neovim now provides these global LSP mappings by default:
-- gra → code actions
-- gri → implementations
-- grn → rename
-- grr → references
-- grt → type definition
-- grx → run codelens
-- gO → document symbols
-- Ctrl-S in Insert mode → signature help


vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
        end

        local client;
        local clients = vim.lsp.get_clients()
        for _, c in ipairs(clients) do
            if c.id and c.attached_buffers[args.buf] then
                client = c
            end
        end

        map('n', '<leader>o', '<c-o>',  "back") -- clash with zellij session
        map('n', 'gd', vim.lsp.buf.declaration, "decl") -- just more convenient than grt

        if client:supports_method('textDocument/formatting') then
            map('n', '<leader>i', function() vim.lsp.buf.format { async = true } end, "fmt")

            -- format_on_save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function() vim.lsp.buf.format({bufnr = args.buf, id = client.id }) end,
            })
        end

    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    float = {
        scope = 'buffer',
    }
})

vim.g.rustaceanvim = {
   tools = { },
   dap = { },
   server = {
     default_settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" }, -- enabled in rustaceanvim by default
            cargo = { allFeatures = true },
            procMacro = { enable = true },
        }
     },
   },
 }

