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

-- if t == 'everforest' or t == 'catppuccin' then
-- vim.o.background = 'light'
-- end

local s2 = string.format("colorscheme %s", t)
cmd(s2)

-- [[ Opts ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable


