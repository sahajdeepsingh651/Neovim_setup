require("core.options")
require("core.keymaps")
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.bufferline"),
	require("plugins.colorscheme"),
	require("plugins.neotree"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.autocompletion"),
	require("plugins.lsp"),
	require("plugins.aider"),
	require("plugins.comment"),
	require("plugins.nonels"),
	require("plugins.gitsigns"),
	require("plugins.misc"),
	require("plugins.indentblackline"),
	require("plugins.alpha"),
	require("plugins.markdown"),
})
