-- lua/plugins/render-markdown.lua

-- Draw markdown in the buffer rather than leaving it as raw punctuation:
-- tables get box-drawn borders and aligned columns, headings get a coloured
-- background, code blocks a filled block, list bullets a proper glyph.
--
-- It renders by concealing the source characters and drawing extmarks over
-- them, so it only ever changes what you SEE. The file on disk keeps whatever
-- ragged pipes you typed — aligning the actual bytes is a formatter's job.
--
-- anti_conceal (on by default) un-conceals the line the cursor is on, so the
-- row you are editing shows its real text and the rest of the table stays
-- drawn. That is the behaviour to judge it on; if it grates, this file is the
-- only thing to delete.
--
-- conceallevel/concealcursor are set per-window by the plugin itself, so
-- nothing global changes for other filetypes.
--
-- ft, not lazy = false: dormant until a markdown buffer opens, so it costs
-- nothing at startup.
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- markdown + markdown_inline parsers
		"nvim-tree/nvim-web-devicons", -- the icon in a fenced block's label
	},
	ft = { "markdown" },
	opts = {},
}
