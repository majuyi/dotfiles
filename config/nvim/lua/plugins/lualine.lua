-- lua/plugins/lualine.lua

-- Lualine Statusline
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		'EdenEast/nightfox.nvim',
		'nvim-tree/nvim-web-devicons',
	},
	lazy = false,
	config = function()
		require("lualine").setup({
			options = {
				-- "auto" resolves to lua/lualine/themes/<colorscheme>.lua, which
				-- solarized-osaka ships — and it re-resolves on ColorScheme, so
				-- <leader>cs now recolours the statusline too instead of leaving
				-- carbonfox behind.
				theme = "auto",
				section_separators = '',
				component_separators = '',
				icons_enabled = true,
				-- disabled_filetypes = { 'NvimTree', 'packer' }, -- Optional: Exclude certain filetypes
			},
            -- options = {
                -- theme = 'auto', -- Or use a specific theme like 'nightfox' or 'gruvbox'
                -- section_separators = { left = '', right = '' },
                -- component_separators = { left = '', right = '' },
                -- icons_enabled = true,
            -- },
            -- sections = {
                -- lualine_a = {'mode'}, -- Show NORMAL, INSERT, VISUAL, etc.
                -- lualine_b = {'branch', 'diff', 'diagnostics'}, -- Git branch, diff, and diagnostics
                -- lualine_c = {'filename'}, -- File name with icon
                -- lualine_x = {'encoding', 'fileformat', 'filetype'}, -- File encoding, format, and type
                -- lualine_y = {'progress'}, -- Progress through the file (e.g., 37%)
                -- lualine_z = {'location'} -- Line and column number (e.g., 25:0)
            -- },
            -- inactive_sections = {
                -- lualine_a = {},
                -- lualine_b = {},
                -- lualine_c = {'filename'},
                -- lualine_x = {'location'},
                -- lualine_y = {},
				-- lualine_z = {}
			-- },
			-- tabline = {},
			-- extensions = {'fugitive'} -- Optional: Add support for Git with Fugitive
		})
	end,
}
