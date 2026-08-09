-- lua/plugins/colorscheme.lua

local M = {}

-- List of available colorschemes (this list may not satisfy particular standards for completeness)
M.schemes = {
    "catppuccin",
    "doom-one",
    "moonfly",
    "nightfly",
    "nightfox",
    "oxocarbon",
    "kanagawa",
    "default", -- Fallback to the default Neovim colorscheme
}

-- Default colorscheme to load on startup
M.default = "moonfly"

-- Function to apply a colorscheme safely
function M.apply(scheme)
    scheme = scheme or M.default
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
    if not status_ok then
        vim.notify("Colorscheme '" .. scheme .. "' not found! Falling back to default.", vim.log.levels.WARN)
        vim.cmd("colorscheme default")
    end
end

-- Set up a keybinding to easily switch colorschemes
function M.setup_keymaps()
    vim.keymap.set("n", "<leader>cs", function()
        vim.ui.select(M.schemes, {
            prompt = "Select Colorscheme:",
        }, function(choice)
            if choice then
                M.apply(choice)
            end
        end)
    end, { desc = "Switch Colorscheme" })
end

-- Apply the default colorscheme
M.apply()

-- Set up keybindings
M.setup_keymaps()

return M
