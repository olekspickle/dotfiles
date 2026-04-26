local dap = require('dap')

dap.adapters.codelldb = {
    type = 'executable',
    command = 'codelldb',
    args = { '--liblldb', '/home/pickle/.local/lldb/lib/liblldb.so' },
}

dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
    args = {},
}

dap.configurations.rust = {
    {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function()
            local target = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            return target
        end,
        args = {},
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        sourceLanguages = { 'rust' },
    },
    {
        name = 'Debug tests',
        type = 'codelldb',
        request = 'launch',
        cargo = {
            args = { 'test', '--no-run' },
        },
        args = {},
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

vim.keymap.set('n', '<leader>pb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>pc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>ps', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>pi', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>po', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>pr', dap.restart, { desc = 'Restart' })
vim.keymap.set('n', '<leader>pt', dap.terminate, { desc = 'Terminate' })
vim.keymap.set('n', '<leader>pv', function()
    vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site/pack/core/opt/nvim-dap-view')
    vim.cmd('DapViewOpen')
end, { desc = 'Open DapView' })
