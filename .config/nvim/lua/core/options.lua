--[[ opts.lua ]]
-- p.s. stole nice structure and comments from merikan
local g = vim.g
local o = vim.opt
local cmd = vim.api.nvim_command

--------------------------------------------------------------------------------
-- Core
--------------------------------------------------------------------------------
o.clipboard:prepend { "unnamed", "unnamedplus" } -- use system buffer (cross-platform), share clipboard between instances
o.fileencoding = "utf-8" -- the encoding written to a file
o.mouse = "a" -- allow the mouse to be used in neovim
o.autoread = true -- automatically reload a file
g.autoformat = false -- disable LazyVim auto format

--------------------------------------------------------------------------------
-- Display
--------------------------------------------------------------------------------
o.termguicolors = true -- set term gui colors (most terminals support this)
o.splitbelow = true -- force all horizontal splits to go below current window
o.splitright = true -- force all vertical splits to go to the right of current window
o.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
o.updatetime = 300 -- faster completion (4000ms default)
o.laststatus = 3 -- only the last window will always have a status line
o.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
--? vim.opt.showbreak     = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.pumheight = 10 -- pop up menu height
o.showmode = false -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 0 -- always show tabs
o.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
o.cmdheight = 1 -- more space in the neovim command line for displaying messages
o.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
-- Font
o.guifont = "JetBrainsMono Nerd Font"

--------------------------------------------------------------------------------
-- Lines
--------------------------------------------------------------------------------
o.number = true -- set numbered lines
o.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
o.relativenumber = true -- use relative number
-- o.cursorline = true -- highlight the current line
o.scrolloff = 2 -- Lines of context

o.expandtab = true -- convert tabs to spaces
o.shiftwidth = 4 -- the number of spaces inserted for each indentation
o.shiftround = true
o.tabstop = 2 -- insert 2 spaces for a tab
o.smartindent = true -- make indenting smarter again
o.ruler = false -- hide the line and column number of the cursor position
o.fillchars.eob = " " -- show empty lines at the end of a buffer as ` ` {default `~`}
o.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
o.iskeyword:append("-") -- treats words with `-` as single words

o.conceallevel = 0 -- so that `` is visible in markdown files
o.list = true -- :set list, :set nolist
o.listchars:append("trail:•") -- trail char
-- o.listchars:append("space:.")
o.listchars:append("eol:↴")
o.listchars:append("tab:» ")
o.listchars:append("extends:❯")
o.listchars:append("precedes:❮")
o.listchars:append("nbsp:_")

--------------------------------------------------------------------------------
-- Backup / Undo / Swap
--------------------------------------------------------------------------------
o.backup = false -- creates a backup file
o.undofile = true -- enable persistent undo
o.swapfile = false -- creates a swapfile
o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

--------------------------------------------------------------------------------
-- Search and Complelete
--------------------------------------------------------------------------------
o.incsearch = true -- use incremental search (nvim default)
o.hlsearch = true -- highlight all matches on previous search pattern
o.ignorecase = true -- ignore case in search patterns
o.smartcase = true -- with ignorecase to force case match if upper
o.completeopt = {'menu', 'menuone', 'noselect', 'noinsert'}
o.grepprg = "rg --vimgrep --smart-case --follow"

o.path:append { "**" } -- gf jump to file under cursor, CTRL-^ to jump back

-- [[ Whitespace ]]
o.shiftwidth = 4               -- num:  Size of an indent
o.softtabstop = 4              -- num:  Number of spaces tabs count for in insert mode
o.tabstop = 4                  -- num:  Number of spaces tabs count for
o.shiftround = true
o.expandtab = true

