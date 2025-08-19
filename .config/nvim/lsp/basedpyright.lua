return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
    on_attach = function(client, bufnr)
        -- Disable formatting capabilities to prevent conflict with ruff
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        -- Optional: disable semantic tokens if you prefer ruff's highlighting
        client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
        basedpyright = {
            disableLanguageServices = false,
            disableOrganizeImports = true, -- Keep this to let ruff handle imports
            disableTaggedHints = false,
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "recommended",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                    -- Reduce noise for common issues while keeping type safety
                    reportMissingTypeStubs = "warning",
                    reportUnknownMemberType = "warning",
                    reportUnknownArgumentType = "warning",
                    reportUnknownParameterType = "warning",
                    reportUnknownVariableType = "warning",
                    reportAny = "warning",
                    -- Keep these strict for better code quality
                    reportUnusedVariable = "error",
                    reportUnusedImport = "none", -- Let ruff handle this
                    reportMissingImports = "error",
                    reportPrivateUsage = "warning",
                    reportUnreachable = "warning",
                },
                exclude = {
                    "**/node_modules/**",
                    "**/__pycache__/**",
                    "src/experimental"
                },
                logLevel = "Information",
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                    callArgumentNames = false,
                    genericTypes = false,
                },
            },
        }
    },
}
