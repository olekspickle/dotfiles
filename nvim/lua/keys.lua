--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- mode: the mode you want the key bind to apply to (e.g., insert mode, normal mode, command mode, visual mode).
-- sequence: the sequence of keys to press.
-- command: the command you want the keypresses to execute.
-- options: an optional Lua table of options to configure (e.g., silent or noremap).

-- alacritty + zellij + nvim are not perfect in unicode handling not even sure this helps
-- it is a failed attempt to get Ctrl + Tab switch buffers working
if vim.env.TERM == 'alacritty' then
  vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
  vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
end

-- remap the key used to leave insert mode
map('i', 'jk', '', {})

-- Toggle plugin stuff
map('n', '<C-b>', [[:NvimTreeToggle<cr>]], {})

map('n', 'L', [[:IndentLinesToggle<cr>]], {})
map('n', 't', [[:TagbarToggle<cr>]], {})
map('n', 'ff', [[:Telescope find_files<cr>]], {})

-- Rust compile
map('n', 'c-r', [[:FloatermNew --height=0.6 --width=0.4 --wintype=float --name=floaterm1 --position=topleft --autoclose=2 ranger --cmd="echo lol"]], {})

-- Buffer switch
map('n', '<c-i>', [[:bn<cr>]], {})
--map('n', 'c-i', [[:bn<cr>]], {})
--map('n', 'c-s-H', [[:bp<cr>]], {})
--map('n', 'cs-Right', [[:bn<cr>]], {})
--map('n', 'cs-Left', [[:bp<cr>]], {})
