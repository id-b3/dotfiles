local M = {
    'saghen/blink.cmp',
    event = { 'LspAttach', 'InsertEnter' },
    dependencies = {
        'rafamadriz/friendly-snippets',
        'L3MON4D3/LuaSnip',
        'nvim-tree/nvim-web-devicons',
        'onsails/lspkind.nvim',
        'giuxtaposition/blink-cmp-copilot',
    },
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'none',
            ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide' },
            ['<C-d>'] = { 'scroll_documentation_up' },
            ['<C-f>'] = { 'scroll_documentation_down' },
            ['<CR>'] = { 'accept', 'fallback' },

            ['<Tab>'] = {
                function(cmp)
                    -- If completion menu is visible, select next item
                    if cmp.is_visible() then
                        return cmp.select_next()
                        -- Otherwise, try snippet jump
                    elseif require('luasnip').locally_jumpable(1) then
                        require('luasnip').jump(1)
                        return true
                    end
                    -- If nothing worked, return false to trigger fallback
                    return false
                end,
                'fallback'
            },

            ['<S-Tab>'] = {
                function(cmp)
                    -- If completion menu is visible, select previous item
                    if cmp.is_visible() then
                        return cmp.select_prev()
                        -- Otherwise, try snippet jump backward
                    elseif require('luasnip').locally_jumpable(-1) then
                        require('luasnip').jump(-1)
                        return true
                    end
                    return false
                end,
                'fallback'
            },
        },

        appearance = {
            nerd_font_variant = 'mono'
        },

        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 0,
                treesitter_highlighting = true,
                window = {
                    border = 'rounded',
                },
            },
            ghost_text = {
                enabled = true,
            },
            menu = {
                border = 'rounded',
                auto_show = true,
                draw = {
                    treesitter = { 'lsp' },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local icon = ctx.kind_icon
                                if ctx.source_name == "copilot" then
                                    icon = "" -- Copilot icon
                                elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = require("lspkind").symbolic(ctx.kind, {
                                        mode = "symbol",
                                    })
                                end

                                return icon .. ctx.icon_gap
                            end,

                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if ctx.source_name == "copilot" then
                                    hl = "CmpItemKindCopilot"
                                elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        }
                    }
                }
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                }
            }
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
            per_filetype = {
                codecompanion = { 'codecompanion' },
            },
            providers = {
                buffer = {
                    min_keyword_length = 1,
                },
                path = {
                    min_keyword_length = 0,
                },
                copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 100,
                    async = true,
                },
            }
        },
        snippets = {
            expand = function(snippet)
                require('luasnip').lsp_expand(snippet)
            end,
            active = function(filter)
                if filter and filter.direction then
                    return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
            end,
            jump = function(direction)
                require('luasnip').jump(direction)
            end,
        },

        fuzzy = {
            implementation = "prefer_rust_with_warning"
        }
    },
    opts_extend = { "sources.default" },

    config = function(_, opts)
        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        require('blink.cmp').setup(opts)
    end,
}

return M
