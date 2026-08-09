-- lua/plugins/oxocarbon.lua

-- Oxocarbon
return {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true, -- on demand: loaded when <leader>cs picks it
    config = function()
        -- Set the default background mode
        local default_background = "dark"
        if vim.o.background == "light" then
            default_background = "light"
        end

        -- Apply the background setting
        vim.opt.background = default_background
    end,
}
