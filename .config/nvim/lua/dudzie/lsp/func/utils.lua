local M = {}

-- LSP servers to configure
M.lsp_servers = {
    "pyright",
    "lua_ls",
    "bashls",
}

-- Mason packages to install
M.mason_packages = {
    "bash-language-server",
    "lua-language-server",
    "markdownlint",
    "pyright",
    "ruff",
}

-- Mason configuration
M.mason_opts = {
    pip = {
        upgrade_pip = true,
    },
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
}

-- Ensure packages are installed
function M.ensure_installed()
    local mr = require("mason-registry")
    local function install_packages()
        for _, package in ipairs(M.mason_packages) do
            local p = mr.get_package(package)
            if not p:is_installed() then
                p:install()
            end
        end
    end

    if mr.refresh then
        mr.refresh(install_packages)
    else
        install_packages()
    end
end

-- Get enhanced capabilities
function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

return M

