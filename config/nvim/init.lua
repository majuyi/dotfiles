-- init.lua

-- Essential settings and configurations
-- lua/config/options.lua
require("config.options")  -- Load custom options first

-- lua/config/keymaps.lua
require("config.keymaps")   -- Load custom keymaps next

-- lua/config/autocmds.lua
require("config.autocmds")  -- Load autocommands

-- Plugin management with lazy.nvim
-- lua/config/lazy.lua
require("config.lazy")      -- Then set up lazy.nvim

-- Safely Load Colorscheme (avoid race conditions)
-- lua/colorscheme.lua
require("colorscheme")      -- Apply the colorscheme here

-- TODO: migrate completely from vim
