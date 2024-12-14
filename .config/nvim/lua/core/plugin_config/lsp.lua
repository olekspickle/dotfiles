-- Setup language servers.
local zero = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_sources = 'recommended',
        set_extra_mappings = true,
    }
})

-- zero.format_on_save({
--     servers = {
--         ['lua_ls'] = {'lua'},
--         ['rust_analyzer'] = {'rust'},
--     }
-- })

zero.on_attach(function(client, bufnr)
    -- Buffer local mappings.
    -- see :help lsp-zero-keybindings or :help vim.lsp.*
    -- to learn the available actions
    zero.default_keymaps({buffer = bufnr})
    local bufnr = vim.api.nvim_get_current_buf()

    vim.keymap.set('n', '<leader>o', '<c-o>', { buffer = bufnr, desc = "back"})
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "decl"})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "def"})
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = "type def"})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "hover"})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "refs"})
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = bufnr, desc = "rename"})
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action"})
    -- vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "sig help"})

    if client.supports_method('textDocument/rename') then
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "rename"})
    end
    if client.supports_method('textDocument/implementation') then
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "impl"})
    end
    if client.supports_method('textDocument/formatting') then
        vim.keymap.set('n', '<leader>i', function() vim.lsp.buf.format { async = true } end,
            { buffer = bufnr, desc = "fmt"})

        -- format_on_save
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({bufnr = bufnr, id = client.id }) end,
        })
    end

end)




local cmp = require('cmp')
local cmp_action = zero.cmp_action()
local cmp_format = zero.cmp_format()
local select_opts = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip', option = { show_autosnippets = true } },
    },
    mapping = {
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
    },
    formatting = cmp_format,
    snippet = {
        expand =  function(args)
            require('luasnip').lsp_expand(args.body)
        end
    }
})

local ls = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()
ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

-- load all snippet files
for _,ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/core/snippets/*.lua", true)) do
    loadfile(ft_path)()
end

-- hik Ctrl+k to jump around snippet nodes
vim.keymap.set({"i", "s"}, "<c-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end,
    {silent = true})

