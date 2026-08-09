-- lua/plugins/nightfox.lua

-- Nightfox
return {
    "EdenEast/nightfox.nvim",
    lazy = true, -- on demand: loaded when <leader>cs picks it
    config = function()
        require("nightfox").setup({
            options = {
                compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- Speed up startup with compiled theme
                transparent = false, -- Enable/disable transparency
                terminal_colors = true, -- Use terminal colors
                dim_inactive = true, -- Dim inactive windows
                styles = {
                    comments = "italic",
                    keywords = "bold",
                    functions = "italic,bold",
                    variables = "bold",
                    strings = "NONE", -- Example: No special styling for strings
                },
                inverse = {
                    match_paren = true, -- Inverse highlighting for matching parentheses
                    visual = false, -- Disable inverse visual selection
                },
                modules = {
                    -- Enable specific plugin integrations
                    nvimtree = true,
                    telescope = true,
                    gitsigns = true,
                    lualine = true,
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = "italic",
                            hints = "italic",
                            warnings = "italic",
                            information = "italic",
                        },
                        underlines = {
                            errors = "underline",
                            hints = "underline",
                            warnings = "underline",
                            information = "underline",
                        },
                    },
                },
            },
        })
    end,
}
