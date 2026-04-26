vim.loader.enable()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function normalize_src(src)
    if src:match("^[a-z]+://") then
        return src
    end
    return "https://github.com/" .. src:gsub("^/", "")
end

local function setup_specs(specs_ext)
    local specs = {}
    local configs = {}

    for _, spec in ipairs(specs_ext) do
        if spec.dependencies then
            for _, dep in ipairs(spec.dependencies) do
                table.insert(specs, { src = normalize_src(dep.src), version = dep.version })
            end
        end
        table.insert(specs, vim.tbl_extend("force", spec, { src = normalize_src(spec.src) }))
        if spec.config then
            table.insert(configs, spec.config)
        end
    end

    vim.pack.add(specs)

    for _, config in ipairs(configs) do
        config()
    end
end

_G.setup_plugins = function(specs)
    setup_specs(specs)
end

require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.config_plugins")
