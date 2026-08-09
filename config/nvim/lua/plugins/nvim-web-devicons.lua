-- lua/plugins/nvim-web-devicons.lua

return {
    'nvim-tree/nvim-web-devicons',
    lazy = true, -- Load only when required
    config = function()
        require('nvim-web-devicons').setup({ default = true })
    end,
}
