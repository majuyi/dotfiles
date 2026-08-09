-- lua/plugins/catppuccin.lua

-- Catppuccin
return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = true, -- on demand: loaded when <leader>cs picks it
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
			transparent_background = false, -- Optional: Enable transparency
			term_colors = true, -- Use terminal colors
			no_italic = false, -- Disable italics if needed
			no_bold = false, -- Disable bold if needed
			integrations = {
				lualine = {
					-- enabled = true, -- Properly enable lualine integration
					style = "mocha", -- Optional: specify the style
				},
				treesitter = true,
				telescope = true,
				nvimtree = true, -- Example: Add NvimTree integration
				gitsigns = true, -- Example: Add GitSigns integration
				which_key = true, -- Example: Add WhichKey integration
				dashboard = true, -- Example: Add Dashboard integration
			},
		})
	end,
}
