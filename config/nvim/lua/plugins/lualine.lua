-- lua/plugins/lualine.lua

-- Lualine Statusline
--
-- craftzdog's statusline, which is LazyVim's default layout plus one override
-- on the filename. He doesn't configure most of it, so the source for this is
-- lua/lazyvim/plugins/ui.lua (v16.0.1), ported without LazyVim:
--
--   NORMAL  main   2  lua/plugins/lualine.lua     3  1      42%  12:5    14:03
--   mode    branch  diagnostics  path            git diff      progress  location  clock
--
-- Left out: LazyVim's root_dir segment (it only appears when the project root
-- differs from cwd, which a tmux-window-per-project layout never produces) and
-- the noice/dap/lazy-updates segments, which need plugins that aren't here.

-- The file path, relative to cwd, with the filename bold — or in MatchParen's
-- colour when modified — and a lock when read-only. His override sets
-- length = 0, so no middle directories are elided.
--
-- LazyVim styles the filename with a "Bold" highlight group that only exists
-- when LazyVim defines it; here it is undefined, so bold is set directly.
local function styled(self, text, spec)
	text = text:gsub("%%", "%%%%")
	self.hl_cache = self.hl_cache or {}
	local key = vim.inspect(spec)
	if not self.hl_cache[key] then
		self.hl_cache[key] = self:create_hl(spec, "PrettyPath" .. vim.tbl_count(self.hl_cache))
	end
	return self:format_hl(self.hl_cache[key]) .. text .. self:get_default_hl()
end

local function pretty_path(self)
	local path = vim.fn.expand("%:p")
	if path == "" then
		return ""
	end

	-- Relative to cwd only on a real path boundary: a plain prefix match would
	-- treat /a/bc/file as living under /a/b.
	local cwd = vim.fn.getcwd()
	if path:sub(1, #cwd + 1) == cwd .. "/" then
		path = path:sub(#cwd + 2)
	else
		path = vim.fn.fnamemodify(path, ":~")
	end

	local parts = vim.split(path, "/", { plain = true })
	local name = parts[#parts]
	local dir = #parts > 1 and table.concat(parts, "/", 1, #parts - 1) .. "/" or ""

	local utils = require("lualine.utils.utils")
	if vim.bo.modified then
		name = styled(self, name, { fg = utils.extract_highlight_colors("MatchParen", "fg"), gui = "bold" })
	else
		name = styled(self, name, { gui = "bold" })
	end

	local readonly = ""
	if vim.bo.readonly then
		readonly = styled(self, " 󰌾 ", { fg = utils.extract_highlight_colors("MatchParen", "fg") })
	end
	return dir .. name .. readonly
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
		require("lualine").setup({
			options = {
				-- "auto" resolves to lua/lualine/themes/<colorscheme>.lua, which
				-- solarized-osaka ships — and it re-resolves on ColorScheme, so
				-- <leader>cs recolours the statusline too.
				theme = "auto",
				-- One statusline across every split, as his laststatus = 3 gives.
				globalstatus = true,
				-- No separator overrides: lualine's defaults are the powerline
				-- arrows in his screenshots. Setting them to '' is what made the
				-- old statusline flat.
				icons_enabled = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ pretty_path },
				},
				lualine_x = {
					-- LazyVim reads these counts from gitsigns; lualine's own diff
					-- source runs git itself, so no extra plugin is needed.
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
					},
					-- Not in his layout — LazyVim drops these. Encoding appears only
					-- when it is not plain utf-8 (a latin1 file, or utf-8 carrying a
					-- BOM), since utf-8 on every file says nothing. fileformat is the
					-- Tux logo on Unix line endings, and the one to notice when it
					-- changes to a CRLF file. Filetype is the icon before the path.
					{
						"encoding",
						cond = function()
							local fenc = vim.bo.fileencoding
							return (fenc ~= "" and fenc ~= "utf-8") or vim.bo.bomb
						end,
						fmt = function(str)
							return vim.bo.bomb and str .. " [BOM]" or str
						end,
					},
					"fileformat",
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "nvim-tree", "lazy" },
		})
	end,
}
