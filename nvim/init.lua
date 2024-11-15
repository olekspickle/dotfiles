--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- ensure the packer plugin manager is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- IMPORTS
require('vars')             -- Variables
require('opts')             -- Options
require('keys')             -- Keymaps
require('plug')             -- Plugins
require('ra')               -- rust-analyzer
require('comment')          -- comments plugin

require('impatient')        -- speedup start up times
require('nvim-tree').setup{}
require("mason").setup{}
require('lualine').setup {
  options = {
    theme = 'dracula-nvim'
  }
}

require('nvim-autopairs').setup{}  -- Paired elements ({["'

-- Indent blankline customization
vim.opt.list = true
vim.opt.listchars:append "eol:↴"
require("indent_blankline").setup {
    show_end_of_line = true,
}

