-- Overriding vim.notify with fancy notify if fancy notify exists
-- local notify = require("notify")
-- vim.notify = notify
-- print = function(...)
--     local print_safe_args = {}
--     local _ = { ... }
--     for i = 1, #_ do
--         table.insert(print_safe_args, tostring(_[i]))
--     end
--     notify(table.concat(print_safe_args, ' '), "info")
-- end
-- notify.setup()

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})
