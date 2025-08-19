-- This utility detects and activates Python virtual environments for the current project.

local M = {}

local ORIGINAL_PATH = vim.fn.getenv("PATH") or ""
M.cur_env = nil

-- Reads the first line of a file.
local function read_file_line(path)
    local lines = vim.fn.readfile(path)
    if lines and #lines > 0 then
        return lines[1]
    end
    return nil
end

local function find_env()
    local root = vim.fs.root(0, { ".git", "pyproject.toml" })
    if not root then
        return nil
    end
    local path = root .. "/.venv"

    local stat = vim.loop.fs_stat(path)
    if stat then
        if stat.type == "directory" then
            return path
        elseif stat.type == "file" then
            local env_path = read_file_line(path)
            if env_path and #env_path > 0 then
                return vim.fn.expand("~/.virtualenvs/" .. env_path)
            end
        end
    end
    return nil
end

function M.setup()
    local virtual_env = find_env()
    if not virtual_env or M.cur_env == virtual_env then
        return
    end

    M.cur_env = virtual_env
    vim.fn.setenv("PATH", virtual_env .. "/bin:" .. ORIGINAL_PATH)
    vim.fn.setenv("VIRTUAL_ENV", virtual_env)
end

return M
