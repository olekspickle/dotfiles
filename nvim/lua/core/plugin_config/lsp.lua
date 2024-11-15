-- Setup language servers.
local zero = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_sources = 'recommended',
        set_extra_mappings = true,
    }
})
zero.on_attach(function(client, bufnr)
    -- Buffer local mappings.
    -- see :help lsp-zero-keybindings or :help vim.lsp.*
    -- to learn the available actions
    zero.default_keymaps({buffer = bufnr})
    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "decl"})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "def"})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "impl"})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "hover"})
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = bufnr, desc = "type def"})
    -- vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "sig help"})
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "rename"})
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action"})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "refs"})
    vim.keymap.set('n', '<leader>i', function()
        vim.lsp.buf.format { async = true }
    end, { buffer = bufnr, desc = "fmt"})
end)

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_action = zero.cmp_action()
local select_opts = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
        {name = 'buffer'},
        {name = 'path'},
        { name = 'luasnip', option = { show_autosnippets = true } },
    },
    mapping = {
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
})

-- custom snippets
-- #[cfg(test)]
-- mod tests {
--     use super::*;
--
--     #[test]
--     fn 
-- }

