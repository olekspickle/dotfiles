return {
    -- If you spent a lotta time to find what goes here, here you go
    -- https://neovim.io/doc/user/lsp.html#vim.lsp.Config
    -- settings = {
    --     ["rust-analyzer"] = {
    --         checkOnSave = { command = "clippy" }, -- enabled in rustaceanvim by default
    --         cargo = { allFeatures = true },
    --         procMacro = { enable = true },
    --     }
    -- },
    root_markers = {'Cargo.toml', 'Cargo.lock'},
    filetypes = {'rs'}
}
