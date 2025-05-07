return {
    'echasnovski/mini.files',
    version = '*',
    config = function ()
        require('mini.files').setup()
    end,
    keys = {
        {'<leader>of', ':lua MiniFiles.open()<CR>', desc = "[O]pen [F]ile-explorer"}
    }
}
