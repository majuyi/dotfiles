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
		-- Osaka on pitch black (25 Oct): only the base background goes to
		-- #000000. Its teal-black #002c38 / #063540 stay for the cursorline and
		-- borders, so the shading Osaka was designed with is
		-- intact, just over black. bg_float/sidebar/popup are derived from bg
		-- before this hook runs, so they need setting too.
		on_colors = function(c)
			c.bg = "#000000"
			c.bg_float = "#000000"
			c.bg_sidebar = "#000000"
			c.bg_popup = "#000000"
			-- The statusline matches tmux's bar below it: a neutral
			-- near-black, so it reads as a separate surface from the code.
			c.bg_statusline = "#121212"
		end,
		styles = {
			-- tmux-256color advertises sitm, and kitty draws SF Mono's real
			-- italic, so these actually render rather than turning into
			-- reverse video.
			comments = { italic = true },
			keywords = { italic = true },
		},
	},
}
