-- lua/plugins/doom-one.lua

-- Doom One
return {
    "NTBBloodbath/doom-one.nvim",
    lazy = true, -- on demand: loaded when <leader>cs picks it
    init = function()
        -- Global Doom One settings
        vim.g.doom_one_cursor_coloring = true  -- Add color to the cursor
        vim.g.doom_one_terminal_colors = true  -- Enable terminal colors
        vim.g.doom_one_italic_comments = true  -- Italicize comments
        vim.g.doom_one_enable_treesitter = true  -- Enable Treesitter support
        vim.g.doom_one_diagnostics_text_color = false  -- Underline diagnostic text only
        vim.g.doom_one_transparent_background = false  -- Disable transparency

        -- Pumblend transparency
        vim.g.doom_one_pumblend_enable = true
        vim.g.doom_one_pumblend_transparency = 20

        -- Plugins integration
        local plugins = {
            "neorg",
            "barbar",
            "telescope",
            "neogit",
            "nvim_tree",
            "dashboard",
            "startify",
            "whichkey",
            "indent_blankline",
            "vim_illuminate",
            "lspsaga",
        }

        for _, plugin in ipairs(plugins) do
            vim.g["doom_one_plugin_" .. plugin] = (plugin ~= "barbar" and plugin ~= "telescope")
        end
    end,
}
