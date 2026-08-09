-- lua/config/options.lua

-- Enable system clipboard in Neovim
-- "unnamedplus" uses the + register to sync with the system clipboard
vim.opt.clipboard = "unnamedplus"   -- This allows copying and pasting between Neovim and other applications

-- Other UI settings
vim.opt.termguicolors = true    -- Enable 24-bit RGB colors
vim.opt.wrap = false            -- Disable line wrapping

-- Basic settings
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers

vim.opt.tabstop = 4        -- A tab character (\t) appears as 4 spaces
vim.opt.shiftwidth = 4     -- Indent operations (<< >>) move by 4 spaces
vim.opt.softtabstop = 4    -- Tab and Backspace feel like 4 spaces
vim.opt.expandtab = true   -- Insert spaces instead of a real tab character
vim.opt.smarttab = true    -- Makes Tab insert correct amount at start of lines
vim.opt.autoindent = true  -- Copy indent from current line when starting a new line
vim.opt.smartindent = true -- Auto-indent inside braces, parentheses, etc (C-like)

vim.opt.smartcase = true   -- Ignore case when searching unless capital letters are used
vim.opt.ignorecase = true  -- Ignore case in general when searching

-- New splits open right and below, which is where <leader>v and <leader>s
-- already jump to. Without these, Neovim puts them left and above.
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 5      -- Keep 5 lines of context above/below the cursor
vim.opt.signcolumn = "yes" -- Always show it, so text doesn't jump when a sign appears
vim.opt.colorcolumn = "80" -- Matches the 80-column marker in ~/.vimrc
vim.opt.updatetime = 250   -- Default 4000ms makes LSP diagnostics feel laggy

-- Remote-plugin hosts. Nothing installed here uses them, so skip the startup
-- probe and the four :checkhealth warnings they otherwise produce.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.o.undofile = true -- Enable persistent undo
-- Set undo levels and reload limits
vim.opt.undolevels = 9999      -- Set the number of undo levels
vim.opt.undoreload = 99999     -- Number of lines to reload for undo
