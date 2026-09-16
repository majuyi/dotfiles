-- lua/plugins/solarized-osaka.lua

-- Solarized Osaka — craftzdog's Solarized palette built on the tokyonight
-- engine, which is why the same colours exist for kitty and tmux under the
-- plugin's extras/ (both vendored into this repo).
--
-- Unlike the other schemes here this one is not lazy: it is the default, so it
-- has to be on disk and loaded before lua/colorscheme.lua runs its
-- `colorscheme` command. priority 1000 puts it ahead of every other start
-- plugin for the same reason.
return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = false,
		styles = {
			-- tmux-256color advertises sitm, and kitty draws SF Mono's real
			-- italic, so these actually render rather than turning into
			-- reverse video.
			comments = { italic = true },
			keywords = { italic = true },
		},
	},
}
