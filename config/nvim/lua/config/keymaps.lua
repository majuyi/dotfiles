-- lua/config/keymaps.lua

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Open NvimTree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Set the undo tree toggle keybinding
vim.api.nvim_set_keymap('n', '<Leader>u', ':UndotreeToggle<CR>', { noremap = true, silent = true })

-- Navigation and File Jumps
-- vim.keymap.set('n', 'gf', '<C-w>f', { desc = 'Open File Under Cursor in a New Split' })
-- splitright/splitbelow (config/options.lua) already drop you into the new
-- window, so the old compensating <C-w>l / <C-w>j are gone.
vim.keymap.set('n', 'gvf', '<C-w>vgf', { desc = 'Open File Under Cursor in a Vertical Split' })
vim.keymap.set('n', 'gsf', '<C-w>sgf', { desc = 'Open File Under Cursor in a Horizontal Split' })

vim.keymap.set('n', 'gl', ':ls<CR>', { desc = 'List Buffers' })
vim.keymap.set('n', 'gd', ':bd<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', 'gw', ':bwipeout<CR>', { desc = 'Wipeout Buffer' })

vim.keymap.set('n', 'gb', ':b#<CR>', { desc = 'Go to Alternate Buffer' })
vim.keymap.set('n', 'gN', ':bprev<CR>', { desc = 'Go to Previous Buffer' })     -- <C-o> might be more desirable (Go Back in Jumplist)
vim.keymap.set('n', 'gn', ':bnext<CR>', { desc = 'Go to Next Buffer' })         -- <C-i> might be more desirable (Go Forward in Jumplist)
vim.keymap.set('n', 'gF', ':bfirst<CR>', { desc = 'Go to First Buffer' })
vim.keymap.set('n', 'gL', ':blast<CR>', { desc = 'Go to Last Buffer' })

-- Split Creation
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>s', '<C-w>s', { desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>e', '<C-w>=', { desc = 'Equalize Splits' })
vim.keymap.set('n', '<leader>x', '<C-w>c', { desc = 'Close Current Split' })
vim.keymap.set('n', '<leader>o', '<C-w>o', { desc = 'Close Other Splits' })

-- Window Navigation (Leader + hjkl)
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Move to the Left Window' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Move to the Window Below' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Move to the Window Above' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Move to the Right Window' })

-- Split Movement and Repositioning
vim.keymap.set('n', '<leader>H', '<C-w>H', { desc = 'Move Split to the Far Left' })
vim.keymap.set('n', '<leader>J', '<C-w>J', { desc = 'Move Split to the Bottom' })
vim.keymap.set('n', '<leader>K', '<C-w>K', { desc = 'Move Split to the Top' })
vim.keymap.set('n', '<leader>L', '<C-w>L', { desc = 'Move Split to the Far Right' })

-- Window Resizing
vim.keymap.set('n', '<leader>=', ':vertical resize +5<CR>', { desc = 'Increase Window Width' })
vim.keymap.set('n', '<leader>-', ':vertical resize -5<CR>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<leader>+', ':resize +2<CR>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<leader>_', ':resize -2<CR>', { desc = 'Decrease Window Height' })

-- Window Management
vim.keymap.set('n', '<leader>r', '<C-w>r', { desc = 'Rotate Splits' })
-- vim.keymap.set('n', '<leader>ss', '<C-w>x', { desc = 'Swap Splits' })
-- vim.keymap.set('n', '<leader>st', '<C-w>T', { desc = 'Move to New Tab' })

-- Toggle Maximize Split (Using 'm' for maximize)
-- vim.keymap.set('n', '<leader>sm', '<C-w>_|<C-w>|', { desc = 'Maximize Current Split' })
-- vim.keymap.set('n', '<leader>s=', '<C-w>=', { desc = 'Equalize Splits' })

-- Vertical Help
-- vim.keymap.set("n", "<leader>vh", function()
    -- local word = vim.fn.expand("<cword>")
    -- vim.cmd("vertical help " .. word)
    -- vim.cmd("vertical resize 80")
-- end, { desc = "Open help vertically and resize to 80" })

-- Horizontal Help
-- vim.keymap.set("n", "<leader>bh", function()
    -- local word = vim.fn.expand("<cword>")
    -- vim.cmd("belowright help " .. word)
    -- vim.cmd("resize 10")
-- end, { desc = "Open help at the bottom and resize to 10" })
