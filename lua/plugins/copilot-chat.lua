-- Config
local function configure_copilot_chat()
  local copilot_chat = require("CopilotChat")
  copilot_chat.setup({
    debug = false,
    model = "claude-sonnet-4",
    window = {
      layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
      width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
      height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
      -- Options below only apply to floating windows
      relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
      border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      row = nil, -- row position of the window, default is centered
      col = nil, -- column position of the window, default is centered
      title = "Copilot Chat", -- title of chat window
      footer = nil, -- footer of chat window
      zindex = 1, -- determines if window is on top or below other floating windows
    },
  })

  -- Set key mappings
  vim.keymap.set("n", "<leader>i", ":CopilotChatToggle<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<leader>Id", ":CopilotChatDocs<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>Ifd", function()
    local context = vim.diagnostic.get(0)
    if context and #context > 0 then
      vim.cmd("CopilotChatFixDiagnostic " .. context[1].message)
    else
      vim.notify("No diagnostics found in the current buffer", vim.log.levels.WARN)
    end
  end, { noremap = true, silent = true })
end

-- Return the plugin configuration
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  config = configure_copilot_chat,
}
