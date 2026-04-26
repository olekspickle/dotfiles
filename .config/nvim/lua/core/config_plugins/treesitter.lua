-- Treesitter setup
-- To install parsers manually: :TSInstall <language> (interactive)
-- To reinstall all parsers: :TSUpdate
-- For latest tree-sitter-cli: cargo install tree-sitter-cli
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end,
})

local parsers = { "rust", "ron", "toml", "dockerfile", "lua", "bash", "javascript", "python", "go", "c", "cpp", "vim", "vimdoc", "regex", "glsl", "wgsl" }

local function ensure_installed()
    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then return end

    local installed = {}
    local config = ts.configs or {}
    if config.get_installed then
        installed = config.get_installed() or {}
    end

    local to_install = {}
    for _, parser in ipairs(parsers) do
        local found = false
        for _, inst in ipairs(installed) do
            if inst == parser then
                found = true
                break
            end
        end
        if not found then
            table.insert(to_install, parser)
        end
    end

    if #to_install > 0 then
        ts.install(to_install)
    end
end

ensure_installed()

vim.g.indentLine_setColors = 0
vim.g.indentLine_enabled = 0