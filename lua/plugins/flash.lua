return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      label = {
        -- Make labels appear after the match
        after = { 0, 0 },
        before = false,
        style = "overlay",
        reuse = "lowercase",
        distance = true,
      },
      highlight = {
        -- Customize the highlight groups
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      -- Set up custom highlights for Flash - gruvbox hard dark theme
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#fe8019", bold = true, bg = "#1d2021" }) -- Orange labels
      vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#83a598", bg = "#3c3836" }) -- Blue for matches
      vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#8ec07c", bg = "#3c3836", bold = true }) -- Green for current
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#665c54" }) -- Dimmed backdrop
    end,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
