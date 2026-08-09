-- lua/plugins/telescope.lua

-- Telescope
return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8", -- or branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")

        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                    },
                },
            },
        })

        -- Load Telescope extensions here
        -- vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })
    end,
}
