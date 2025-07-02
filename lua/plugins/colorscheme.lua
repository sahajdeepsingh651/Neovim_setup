return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- load immediately
    priority = 1000, -- load before other plugins
    config = function()
      require("kanagawa").setup({
        transparent = false,
        dimInactive = false,
        theme = "wave", -- Options: wave, dragon, lotus, etc.
      })
      vim.cmd("colorscheme kanagawa")
    end,
  }
}

