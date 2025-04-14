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

-- lua completion and snippets. Saving just as a backup, because so far mini.snippets are a blast
--
-- local cmp = require('cmp')
-- local cmp_action = zero.cmp_action()
-- local lsp_format =
--     lspkind.cmp_format({
--       mode = 'symbol', -- show only symbol annotations
--       maxwidth = {
--         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
--         -- can also be a function to dynamically calculate max width such as
--         -- menu = function() return math.floor(0.45 * vim.o.columns) end,
--         menu = 50, -- leading text (labelDetails)
--         abbr = 50, -- actual suggestion item
--       },
--       ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
--       show_labelDetails = true, -- show labelDetails in menu. Disabled by default
--
--       -- The function below will be called before any actual modifications from lspkind
--       -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
--       before = function (entry, vim_item)
--         -- ...
--         return vim_item
--       end
-- })
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
--         -- { name = 'luasnip', option = { show_autosnippets = true } },
--     },
--     mapping = {
--         ['<Tab>'] = cmp_action.luasnip_supertab(),
--         ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
--         ['<CR>'] = cmp.mapping.confirm({select = true}),
--     },
--     formatting = lsp_format,
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
-- for _,ft_path in ipairs(vim.api.nvim_get_runtime_file("snippets/*.lua", true)) do
--     loadfile(ft_path)()
-- end
--
-- -- hik Ctrl+k to jump around snippet nodes
-- vim.keymap.set({"i", "s"}, "<leader>k", function()
--     if ls.expand_or_jumpable() then
--         ls.expand_or_jump()
--     end
-- end,
--     {silent = true})

