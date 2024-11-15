--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command

-- everforest | dracula | tokyonight-day | catpuccin
-- local t = 'everforest'
local t = 'tokyonight-day'
require('lualine').setup {
    options = {
        theme = t
    }
}

-- if t == 'everforest' or t == 'catppuccin' then
-- vim.o.background = 'light'
-- end

local s2 = string.format("colorscheme %s", t)
cmd(s2)

-- [[ Opts ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

