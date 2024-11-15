--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = " "
vim.g.localleader = "\\"

-- disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
require('vars')                     -- Variables
require('opts')                     -- Options
require('keys')                     -- Keymaps
require('plugins')                  -- Plugins
require('ra')                       -- rust-analyzer
require('comment')                  -- comments plugin
require('themes')
require('log-cfg')                  -- adds BaleiaColorize cmd for [m[3m logs
require('tree')                     -- nvim-tree config
require('ollama')                   -- ollama stuff

require('impatient')                -- speedup start up times
require('treesitter')               -- treesitter highlight
require('nvim-autopairs').setup{}   -- Paired elements ({["'
require("ibl").setup{
    -- indent = { char = "|" }
}

-- require("codesnap").setup({
--     mac_window_bar = true,
--     opacity = true,
--     watermark = "pickle.share",
--     preview_title = "CodeSnap.nvim", -- (Optional) preview page title
--     editor_font_family = "CaskaydiaCove Nerd Font", -- (Optional) preview code font family
--     watermark_font_family = "Pacifico", -- (Optional) watermark font family
-- })
