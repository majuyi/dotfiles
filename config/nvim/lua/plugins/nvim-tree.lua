-- lua/plugins/nvim-tree.lua

-- nvim-tree
return {
    -- Load the main 'nvim-tree' plugin
    "nvim-tree/nvim-tree.lua", 
    
    -- Specify dependencies for this plugin
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Adds file and folder icons to 'nvim-tree'
    },
    
    -- Disable lazy loading to ensure the tree is available on startup
    lazy = false, 
    
    -- Configuration function for 'nvim-tree'
    config = function()
        require("nvim-tree").setup({
            
            -- Configure the view settings of the file tree
            view = {
                width = 30,       -- Set the width of the tree window to 30 columns
                side = "left",    -- Display the file tree on the left side of the screen
            },
            
            -- Renderer settings to manage icons and display
            renderer = {
                icons = {
                    show = {
                        file = true,            -- Show icons next to file names
                        folder = true,          -- Show icons next to folder names
                        folder_arrow = true,    -- Show folder arrow icons
                        git = true,             -- Show git icons
                    },
                },
            },
        })
    end,
}
