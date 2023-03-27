local CodeGPTModule = require("codegpt")

require('lualine').setup({
    sections = {
        -- ...
        lualine_x = { CodeGPTModule.get_status, "encoding", "fileformat" },
        -- ...
    }
})
