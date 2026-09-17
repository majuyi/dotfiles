-- lua/plugins/moonfly.lua

-- Moonfly
return {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = true, -- on demand: loaded when <leader>cs picks it
    -- Was lazy = false, priority = 1000. colorscheme.lua defaults to
    -- solarized-osaka and applies it last, so everything below — the
    -- custom_colors table and the two NvimTree highlights — ran on every
    -- startup only to be overwritten a moment later. priority goes with it:
    -- it only orders plugins that load at startup.
    config = function()
        -- Set dark background
        vim.opt.background = "dark"

        -- Basic Configuration Options
        vim.g.moonflyCursorColor = true         -- Enable colored cursor
        vim.g.moonflyTerminalColors = true      -- Apply colors to terminal
        vim.g.moonflyTransparent = false        -- No transparency
        vim.g.moonflyUndercurls = true          -- Enable undercurls for diagnostics

        vim.g.moonflyItalics = true
        vim.g.moonflyNormalFloat = false
        vim.g.moonflyTerminalColors = true
        vim.g.moonflyUnderlineMatchParen = true
        vim.g.moonflyVirtualTextColor = true
        vim.g.moonflyWinSeparator = true

        -- Plugin Integration (e.g., nvim-tree)
        vim.cmd([[
            highlight NvimTreeNormal guibg=#080808
            highlight NvimTreeVertSplit guifg=#080808 guibg=#080808
            ]])

        require("moonfly").custom_colors({
            bay = "#4d5d8d",
            bg = "#000000",             -- originally #080808
            black = "#000000",          -- originally #080808
            blue = "#525FEB",           -- originally #80a0ff
            cinnamon = "#e9958e",
            coral = "#f09479",
            cranberry = "#FF5C46",      -- originally #e65e72
            crimson = "#ff5189",
            emerald = "#36c692",
            green = "#8cc85f",
            grey0 = "#323437",
            grey1 = "#373c4d",
            grey11 = "#1c1c1c",
            grey15 = "#262626",
            grey16 = "#292929",
            grey18 = "#2e2e2e",
            grey23 = "#3a3a3a",
            grey27 = "#444444",
            grey30 = "#4e4e4e",
            grey35 = "#585858",
            grey39 = "#626262",
            grey50 = "#808080",
            grey58 = "#949494",
            grey62 = "#9e9e9e",
            grey7 = "#121212",
            grey70 = "#b2b2b2",
            grey89 = "#e4e4e4",
            khaki = "#FFF12A",          -- originally #c6c684
            lavender = "#8A8AFF",       -- originally #adadf3
            lime = "#85dc85",
            mineral = "#314940",
            orange = "#E89E6A",         -- originally #de935f
            orchid = "#e196a2",
            purple = "#8643FF",         -- originally #ae81ff
            red = "#EF0505",            -- originally #ff5d5d
            sky = "#3891FF",
            slate = "#748999",
            turquoise = "#95FEEA",      -- originally #79dac8
            violet = "#C862EB",         -- originally #cf87e8
            white = "#ffffff",          -- originally #c6c6c6
            yellow = "#e3c78a"          -- originally #e3c78a
        })
    end,
}
