-- lua/plugins/nvim-highlight-colors.lua

-- Paint colour literals in their own colour: #268bd3 gets a blue background,
-- rgb()/hsl() and Tailwind classes likewise. Same options as craftzdog's
-- editor.lua. Loaded on BufReadPre so it costs nothing until a file opens.
--
-- That lazy-load has a gap his config shares: the plugin paints on BufEnter,
-- and opening a file fires BufEnter *before* BufReadPre. So it loads one event
-- too late, and the first file stays unpainted until you scroll, edit or switch
-- buffers. config paints once after setup, scheduled so the file has actually
-- been read by the time it runs. The gap only shows when nvim starts bare and a
-- file is opened afterwards (:e, nvim-tree, telescope); `nvim <file>` was fine.
return {
	"brenoprata10/nvim-highlight-colors",
	event = "BufReadPre",
	opts = {
		render = "background",
		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_hsl_without_function = true,
		enable_ansi = true,
		enable_var_usage = true,
		enable_tailwind = true,
	},
	config = function(_, opts)
		local hc = require("nvim-highlight-colors")
		hc.setup(opts)
		-- turnOn is the public way to paint: it refreshes every listed buffer.
		-- (refresh_highlights exists internally but isn't exported.)
		vim.schedule(hc.turnOn)
	end,
}
