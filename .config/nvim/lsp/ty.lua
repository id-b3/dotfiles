return {
  name = "ty",
  cmd = { "ty", "server" },
  filetypes = { "python" },
  settings = {
    ty = {
        diagnosticMode = 'workspace',
        configuration = {
            rules = {
                ["possibly-missing-attribute"] = "ignore"
            }
        }
    },
  },
  root_markers = { "pyproject.toml", ".git" },
}
