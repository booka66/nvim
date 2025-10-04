---@diagnostic disable: undefined-global
return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      win = {
        layout = "float",
        float = {
          width = 1.0,
          height = 1.0,
        },
        keys = {
          prompt = { "<leader>tp", "prompt", mode = { "n", "v" } },
          exit_term = { "<C-x>", "stopinsert", mode = { "t" } },
        },
      },
      tools = {
        claude = {
          cmd = { "claude", "--continue" },
          url = "https://github.com/anthropics/claude-code",
        },
        dev_terminal = {
          -- Force tmux session for dev terminal only
          cmd = { "tmux", "new-session", "-A", "-s", "sidekick-dev", vim.o.shell },
        },
        test_terminal = {
          cmd = { "tmux", "new-session", "-A", "-s", "sidekick-test", vim.o.shell },
        },
      },
    },
  },
  keys = {
    {
      "<leader>tc",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Open Claude Code",
      mode = { "n" },
    },
    {
      "<leader>td",
      function()
        require("sidekick.cli").toggle({ name = "dev_terminal", focus = true })
      end,
      desc = "Open Dev Terminal",
      mode = { "n" },
    },
    {
      "<leader>tt",
      function()
        require("sidekick.cli").toggle({ name = "test_terminal", focus = true })
      end,
      desc = "Open Test Terminal",
      mode = { "n" },
    },
    {
      "<leader>tk",
      function()
        vim.fn.system("tmux kill-session -t sidekick-dev")
        vim.fn.system("tmux kill-session -t sidekick-test")
        vim.notify("Tmux sessions killed", vim.log.levels.INFO)
      end,
      desc = "Kill Dev Terminal",
      mode = { "n" },
    },
    {
      "<leader>tp",
      function()
        require("sidekick.cli").select_prompt()
      end,
      desc = "Select AI Prompt",
      mode = { "n", "v" },
    },
    {
      "<C-\\>",
      function()
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Toggle Last AI CLI",
      mode = { "n", "v", "i", "t" },
    },
  },
}
