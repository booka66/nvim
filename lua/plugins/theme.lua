local theme = "gruvbox" -- Change this variable to switch themes

return {
  {
    "luisiacc/gruvbox-baby",
    config = function()
      if theme == "gruvbox-baby" then
        vim.cmd("colorscheme gruvbox-baby")
      end
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      if theme == "gruvbox" then
        require("gruvbox").setup({
          terminal_colors = true,
          undercurl = true,
          underline = true,
          bold = true,
          italic = {
            strings = true,
            emphasis = true,
            comments = true,
            operators = false,
            folds = true,
          },
          strikethrough = true,
          invert_selection = true,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true,
          contrast = "",
          palette_overrides = {},
          overrides = {},
          dim_inactive = false,
          transparent_mode = false,
        })
        vim.cmd("colorscheme gruvbox")
      end
    end,
  },
  {
    "mellow-theme/mellow.nvim",
    config = function()
      if theme == "mellow" then
        vim.cmd("colorscheme mellow")
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = theme,
      transparent_background = false,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine-moon",
    config = function()
      if theme == "rose-pine-moon" then
        vim.cmd("colorscheme rose-pine-moon")
      end
    end,
  },
  {
    "glepnir/oceanic-material",
    config = function()
      if theme == "oceanic-material" then
        vim.cmd("colorscheme oceanic-material")
      end
    end,
  },
  {
    "savq/melange-nvim",
    config = function()
      if theme == "melange" then
        vim.cmd("colorscheme melange")
      end
    end,
  },
}
