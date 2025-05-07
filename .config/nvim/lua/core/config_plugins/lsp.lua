-- Setup language servers.
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

        map('n', '<leader>o', '<c-o>',  "back")
        map('n', 'gD', vim.lsp.buf.definition, "def")
        map('n', 'gd', vim.lsp.buf.declaration, "decl")
        map('n', 'gt', vim.lsp.buf.type_definition, "type def")
        map('n', 'gre', vim.lsp.buf.references, "references")

        if client:supports_method('textDocument/rename') then
            map('n', 'grn', vim.lsp.buf.rename, "rename")
        end

        if client:supports_method('textDocument/implementation') then
            map('n', 'gi', vim.lsp.buf.implementation, "impl")
        end

        vim.keymap.set('n', 'gK', function()
            local new_config = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_config })
        end, { desc = 'Toggle diagnostic virtual_lines' })
        if client:supports_method('textDocument/formatting') then
            map('n', '<leader>i', function() vim.lsp.buf.format { async = true } end, "fmt")

            -- format_on_save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function() vim.lsp.buf.format({bufnr = args.buf, id = client.id }) end,
            })
        end

        -- TODO: rust specific bindings
        -- local filetype = vim.bo[args.buf].filetype
        -- -- Only apply these mappings for lua and rust files
        -- if not vim.tbl_contains({ "rust" }, filetype) then
        --     print("filetype"..filetype)
        --     map('n', '<leader>ca', vim.cmd.RustLsp('openCargo'), "open cargo toml")
        -- end

    end,
})
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    float = {
        scope = 'buffer',
    }
})
vim.lsp.enable({'rust-analyzer'})

-- neat icons on LSP completion
local lspkind = require('lspkind')
lspkind.init({
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- override preset symbols
    symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
    },
})

-- local cmp = require('cmp')
-- local cmp_action = zero.cmp_action()
-- local cmp_format = zero.cmp_format()
-- local select_opts = {behavior = cmp.SelectBehavior.Select}
-- cmp.setup({
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
--     preselect = 'none',
--     completion = {
--         completeopt = 'menu,menuone,noinsert'
--     },
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'nvim_lua' },
--         { name = 'buffer' },
--         { name = 'path' },
--     },
--     mapping = {
--         ['<Tab>'] = cmp_action.luasnip_supertab(),
--         ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
--         ['<CR>'] = cmp.mapping.confirm({select = true}),
--     },
--     formatting = cmp_format,
--     snippet = {
--         expand =  function(args)
--             require('luasnip').lsp_expand(args.body)
--         end
--     }
-- })
--
-- local ls = require('luasnip')
-- require("luasnip.loaders.from_vscode").lazy_load()
-- ls.config.set_config({
--     history = true,
--     updateevents = "TextChanged,TextChangedI",
-- })
--
-- -- load all snippet files
-- for _,ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/core/snippets/*.lua", true)) do
--     loadfile(ft_path)()
-- end
--
-- -- hik Ctrl+k to jump around snippet nodes
-- vim.keymap.set({"i", "s"}, "<c-k>", function()
--     if ls.expand_or_jumpable() then
--         ls.expand_or_jump()
--     end
-- end,
--     {silent = true})
--
