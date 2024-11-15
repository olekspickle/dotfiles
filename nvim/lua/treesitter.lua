local config = require('nvim-treesitter.configs')
config.setup({
  ensure_installed = { "rust", "lua", "javascript", "go", "c", "lua", "vim", "vimdoc" },
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
