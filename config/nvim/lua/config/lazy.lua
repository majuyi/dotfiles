-- lua/config/lazy.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    -- Every file in lua/plugins/ is a spec and gets imported automatically.
    -- Adding a plugin means adding a file there; nothing to register here.
    spec = {
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- Matches colorscheme.lua's M.default: this was still naming moonfly
    -- after moonfly stopped being the startup scheme.
    install = { colorscheme = { "solarized-osaka" } },
    -- No plugin here needs luarocks. Without this, lazy bootstraps hererocks
    -- (its own Lua+luarocks install) just to satisfy the check.
    rocks = { enabled = false },
    -- automatically check for plugin updates
    checker = {
        enabled = true,      -- keep checking
        notify = false,      -- don't notify at startup
        frequency = 3600 * 240, -- check only once every 240 hours (10 days)
    },
})
