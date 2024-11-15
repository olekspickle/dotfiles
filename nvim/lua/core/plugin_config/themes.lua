--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command

-- Installed:
-- everforest | dracula | tokyonight-day | catpuccin
local t = 'tokyonight-day'
-- Theme color depends on time (e.g., 19 for 7 PM)
local now = tonumber(os.date("%H"))
local max = 16
local min = 10
if now > max or now < min then
    t = "tokyonight-storm"
end

local s2 = string.format("colorscheme %s", t)
cmd(s2)

-- Transparensy using package
-- require('transparent')
-- vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { "ExtraGroup" })

require('lualine').setup {
    -- options = {
    --     theme = t
    -- },
    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      }
    }
}

-- [[ Opts ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- transparency Primeagen hack
function ColorMyPencils(color)
    color = color or t
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
end

-- ColorMyPencils()
