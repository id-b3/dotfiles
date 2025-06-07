return {
    cmd = { "pyright" },
    filetypes = { "python" },
    root_markers = { ".git", "pyproject.toml", "setup.py", "requirements.txt" },
    settings = {
        -- Pyright-specific settings (prefixed with `pyright.`)
        pyright = {
            disableLanguageServices = false, -- [boolean]: Disables all language services (hover, completion, etc.).
            disableOrganizeImports = true,  -- [boolean]: Disables the “Organize Imports” command.
            disableTaggedHints = false,      -- [boolean]: Disables hints for unreachable/deprecated code.
        },

        -- Python analysis settings (prefixed with `python.analysis.`)
        python = {
            analysis = {
                -- From your original config (with sensible defaults if not specified)
                autoSearchPaths = true,       -- [boolean]: Auto-adds common search paths like "src".
                diagnosticMode = "workspace", -- ["openFilesOnly", "workspace"]: Scope of analysis.
                useLibraryCodeForTypes = true,-- [boolean]: Analyzes library code for types if stubs are missing.
                typeCheckingMode = "off",     -- ["off", "basic", "standard", "strict"]: Default type-checking level.

                -- Newly added options
                autoImportCompletions = true, -- [boolean]: Offers auto-import completions.

                diagnosticSeverityOverrides = {
                    -- [map]: Override severity for specific diagnostic rules.
                    -- Example:
                    -- reportMissingImports = "warning",
                    -- reportUnusedVariable = "information",
                    -- reportGeneralTypeIssues = "error",
                },

                exclude = {
                    -- [array of paths]: Paths of directories or files to exclude from analysis.
                    -- Example: "**/node_modules/**", "**/__pycache__/**", "src/experimental"
                },

                extraPaths = {
                    -- [array of paths]: Additional paths for import resolution.
                    -- Example: "./src/lib", "/path/to/another_lib"
                },

                ignore = {
                    -- [array of paths]: Suppress diagnostics for these paths.
                    -- Example: "**/tests/data/**", "src/legacy_module"
                },

                include = {
                    -- [array of paths]: Paths of directories or files to explicitly include.
                    -- Example: "src", "tests"
                },

                logLevel = "Information", -- ["Error", "Warning", "Information", "Trace"]: Logging level for Output panel.

                stubPath = nil, -- [path string]: Path to directory containing custom type stub files.
                                -- Example: "./stubs" or "/path/to/project/stubs"

                typeshedPaths = {
                    -- [array of paths]: Paths to look for typeshed modules. (Currently honors only the first path).
                    -- Example: "/path/to/custom/typeshed"
                },
            },
        }
    },
}
