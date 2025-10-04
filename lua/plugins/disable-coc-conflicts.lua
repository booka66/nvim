-- Only disable completion engines that conflict with coc.nvim
return {
  -- Disable blink.cmp (LazyVim's default completion) - this is the main culprit
  {
    "saghen/blink.cmp",
    enabled = false,
  },

  -- Disable nvim-cmp if it exists
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },

  {
    "neovim/nvim-lspconfig",
    enabled = false, -- Disable entirely to avoid conflicts with coc.nvim
  },
}
