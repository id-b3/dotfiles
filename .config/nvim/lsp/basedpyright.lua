return {
    cmd = { "basedpyright" },
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
    settings = {
        basedpyright = {
            disableLanguageServices = false, -- [boolean]: Disables all language services (hover, completion, etc.).
            disableOrganizeImports = true,   -- [boolean]: Disables the “Organize Imports” command.
            disableTaggedHints = false,      -- [boolean]: Disables hints for unreachable/deprecated code.
            analysis = {
                autoSearchPaths = true,        -- [boolean]: Auto-adds common search paths like "src".
                diagnosticMode = "openFilesOnly",  -- ["openFilesOnly", "workspace"]: Scope of analysis.
                useLibraryCodeForTypes = true, -- [boolean]: Analyzes library code for types if stubs are missing.
                typeCheckingMode = "off",      -- ["off", "basic", "standard", "strict"]: Default type-checking level.
                autoImportCompletions = true, -- [boolean]: Offers auto-import completions.
                diagnosticSeverityOverrides = {
                    reportMissingImports = "none",
                    reportUnusedVariable = "none",
                    reportUnusedImport = "none",
                    reportPrivateUsage = "none",
                    reportUnreachable = "none"
                },
                exclude = {
                    -- "**/node_modules/**", "**/__pycache__/**", "src/experimental"
                },
                extraPaths = {
                    -- "./src/lib", "/path/to/another_lib"
                },
                ignore = {
                    -- "**/tests/data/**", "src/legacy_module"
                },
                include = {
                    -- "src", "tests"
                },
                logLevel = "Information", -- ["Error", "Warning", "Information", "Trace"]: Logging level for Output panel.
                stubPath = nil,           -- [path string]: Path to directory containing custom type stub files.
                typeshedPaths = {
                    -- "/path/to/custom/typeshed"
                },
            },
        }
    },
}
