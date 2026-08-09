-- lua/plugins/treesitter.lua

-- Treesitter
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false, -- Load at startup
    config = function()
        require('nvim-treesitter.configs').setup({
            -- Enable syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            -- Incremental selection. Moved off the default 'gnn'/'gr*' keys:
            -- 'gn' is :bnext in config/keymaps.lua, so 'gnn' made every 'gn'
            -- stall for the full timeoutlen while nvim waited for a second 'n'.
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = false,
                    node_decremental = '<BS>',
                },
            },
            -- Enable indentation
            indent = {
                enable = true
            },
            -- Install specific parsers or set to "all"
            ensure_installed = {
                'lua',
                'javascript',
                'typescript',
                'python',
                'html',
                'css',
                'json',
                'bash',
                'markdown',
                'markdown_inline',
                'vim',
                'tsx',
                'cpp',
                'c',
                'php',
            },
            -- Automatically install missing parsers
            auto_install = true,
        })
    end,
}
