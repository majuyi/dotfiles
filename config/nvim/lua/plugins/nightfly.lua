-- lua/plugins/nightfly.lua

-- nightfly
return {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = true, -- on demand: loaded when <leader>cs picks it
    config = function()
        -- Set dark background
        vim.opt.background = "dark"

        -- Basic Configuration Options
        vim.g.nightflyCursorColor = true         -- Enable colored cursor
        vim.g.nightflyTerminalColors = true      -- Apply colors to terminal
        vim.g.nightflyUnderlineMatchParen = true -- Underline matching parentheses
        vim.g.nightflyTransparent = false        -- No transparency
        vim.g.nightflyWinSeparator = 2           -- Thin window separators

        -- Plugin Integration (e.g., nvim-tree)
        vim.cmd([[
            highlight NvimTreeNormal guibg=#011627
            highlight NvimTreeVertSplit guifg=#011627 guibg=#011627
        ]])
    end,
}
