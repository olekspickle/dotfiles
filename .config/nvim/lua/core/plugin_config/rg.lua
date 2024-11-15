local grug = require('grug-far')
local opts = {
  -- extra args that you always want to pass to rg
  extraRgArgs = '',
  -- whether to start in insert mode,
  -- startInInsertMode = false,
  -- row in the window to position the cursor at at start
  startCursorRow = 3,

  -- shortcuts for the actions you see at the top of the buffer
  -- set to '' to unset. Unset mappings will be removed from the help header
  -- They are all mappings for both insert and normal mode except for gotoLocation
  -- which is normal mode only. The distinction is mostly due to how they tend to
  -- be used and in order to show something that is not too busy-looking in the help menu
  keymaps = {
    -- normal and insert mode
    replace = '<leader>p',
    qflist = '',
    syncLocations = '<leader>o',
    close = '',
    -- normal mode only
    gotoLocation = '<enter>',
  },

  -- separator between inputs and results, default depends on nerdfont
  resultsSeparatorLineChar = '',

  -- spinner states, default depends on nerdfont, set to false to disable
  spinnerStates = {
    '󱑋 ', '󱑌 ', '󱑍 ', '󱑎 ', '󱑏 ', '󱑐 ', '󱑑 ', '󱑒 ', '󱑓 ', '󱑔 ', '󱑕 ', '󱑖 '
  },

  -- icons for UI, default ones depend on nerdfont
  -- set individul ones to '' to disable, or set enabled = false for complete disable
  icons = {
    -- whether to show icons
    enabled = true,

    searchInput = ' ',
    replaceInput = ' ',
    filesFilterInput = ' ',
    flagsInput = '󰮚 ',

    resultsStatusReady = '󱩾 ',
    resultsStatusError = ' ',
    resultsStatusSuccess = '󰗡 ',
    resultsActionMessage = '  '
  },

  -- strings to auto-fill in each input area at start
  -- those are not necessarily useful as global defaults but quite useful as overrides
  -- when lauching through the lua api. For example, this is how you would lauch grug-far.nvim
  -- with the current word under the cursor as the search string
  --
  -- require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
  --
  prefills = {
    search = "",
    replacement = "",
    filesFilter = "",
    flags = ""
  }
}

grug.setup(opts)
