-- log colorizer
local baleia = require('baleia').setup({})
function BaleiaColorize()
    baleia.once(vim.fn.bufnr('%'))
end
vim.cmd('command! BaleiaColorize call v:lua.BaleiaColorize()')
