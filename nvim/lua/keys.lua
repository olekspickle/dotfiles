--[[ keys.lua ]]
local map = vim.api.nvim_set_keymap

-- mode: the mode you want the key bind to apply to (e.g., insert mode, normal mode, command mode, visual mode).
-- sequence: the sequence of keys to press.
-- command: the command you want the keypresses to execute.
-- options: an optional Lua table of options to configure (e.g., silent or noremap).

-- remap the key used to leave insert mode
map('i', 'jk', '', {})

-- Toggle plugin stuff
map('n', '<C-b>', [[:NvimTreeToggle<cr>]], {})

map('n', 'l', [[:IndentLinesToggle<cr>]], {})
map('n', 't', [[:TagbarToggle<cr>]], {})
map('n', 'ff', [[:Telescope find_files<cr>]], {})

-- Rust compile
-- map('n', 'c-r', [[:FloatermNew --height=0.6 --width=0.4 --wintype=float --name=floaterm1 --position=topleft --autoclose=2 ranger --cmd="cargo check"]], {})

-- Buffer switch
map('n', 'c-i', [[:bn<cr>]], {})
map('n', 'c-tab', [[:bn<cr>]], {})
--map('n', 'c-s-H', [[:bp<cr>]], {})
--map('n', 'cs-Right', [[:bn<cr>]], {})
--map('n', 'cs-Left', [[:bp<cr>]], {})
