--[[ vars.lua ]]

local g = vim.g
g.t_co = 256
g.background = "light"

-- Update the packpath
local packer_path = vim.fn.stdpath('config') .. '/site'
vim.o.packpath = vim.o.packpath .. ',' .. packer_path


-- -- Configure nvim web icons 
-- local nvim_web_devicons = require "nvim-web-devicons"
-- local current_icons = nvim_web_devicons.get_icons()
-- local new_icons = {}
-- for key, icon in pairs(current_icons) do
--     icon.color = "#ff0088"
--     icon.cterm_color = 198
--     new_icons[key] = icon
-- end
-- nvim_web_devicons.set_icon(new_icons)
