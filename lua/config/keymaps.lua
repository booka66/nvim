---@diagnostic disable: undefined-global
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Use smart-open for <leader><leader>
map(
  "n",
  "<leader><leader>",
  "<cmd>Telescope smart_open layout_strategy=vertical layout_config={vertical={width=0.9,height=0.9,preview_height=0.6}}<cr>",
  { desc = "Smart Open Files" }
)

-- Copy filename only to clipboard
map("n", "<leader>fY", function()
  local filepath = vim.fn.expand("%:t")
  vim.fn.setreg("+", filepath)
  vim.notify("Copied: " .. filepath)
end, { desc = "Copy filename" })

map("n", "<leader>fy", function()
  local filepath = vim.fn.expand("%:.")
  vim.fn.setreg("+", filepath)
  vim.notify("Copied: " .. filepath)
end, { desc = "Copy relative path from git root" })

-- Override grep to always search from git root
map("n", "<leader>sg", function()
  -- Force git root detection
  local root = vim.fs.find(".git", {
    path = vim.fn.expand("%:p:h"),
    upward = true,
  })[1]

  local git_root = root and vim.fs.dirname(root) or vim.fn.getcwd()

  require("telescope.builtin").live_grep({
    cwd = git_root,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
      preview_height = 0.6,
      width = { padding = 0 },
      height = { padding = 0 },
    },
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    winblend = 3,
  })
end, { desc = "Grep (git root)" })

-- Override word search to always search from git root
map("n", "<leader>sw", function()
  -- Force git root detection
  local root = vim.fs.find(".git", {
    path = vim.fn.expand("%:p:h"),
    upward = true,
  })[1]

  local git_root = root and vim.fs.dirname(root) or vim.fn.getcwd()

  require("telescope.builtin").grep_string({
    cwd = git_root,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
      preview_height = 0.6,
      width = { padding = 0 },
      height = { padding = 0 },
    },
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    winblend = 3,
  })
end, { desc = "Word (git root)" })

-- paste from clipboard
local function pasteFromClipboard()
  local clipboard_content = vim.fn.getreg("+") -- '+' is the system clipboard register
  vim.api.nvim_put({ clipboard_content }, "l", true, true)
end
map("t", "<D-v>", pasteFromClipboard, { silent = true, noremap = true })

-- Add paste support for telescope (insert mode)
map("i", "<D-v>", function()
  local clipboard_content = vim.fn.getreg("+")
  vim.api.nvim_put({ clipboard_content }, "c", false, true)
end, { silent = true, noremap = true })

-- Find and replace!!!
-- Interactive replace without confirmation
map("n", "<leader>rr", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    print("No word under cursor")
    return
  end
  local replacement = vim.fn.input('Replace "' .. word .. '" with: ')
  if replacement ~= "" then
    vim.cmd(":%s/\\<" .. word .. "\\>/" .. replacement .. "/g")
  end
end, { desc = "Interactive replace word under cursor" })

map("v", "<leader>rr", function()
  vim.cmd('noau normal! "vy"')
  local selected = vim.fn.getreg("v")
  local replacement = vim.fn.input('Replace "' .. selected .. '" with: ')
  if replacement ~= "" then
    selected = vim.fn.escape(selected, "/\\")
    vim.cmd(":%s/" .. selected .. "/" .. replacement .. "/g")
  end
end, { desc = "Interactive replace visual selection throughout file" })

-- Interactive replace with confirmation
map("n", "<leader>rc", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    print("No word under cursor")
    return
  end
  local replacement = vim.fn.input('Replace "' .. word .. '" with: ')
  if replacement ~= "" then
    vim.cmd(":%s/\\<" .. word .. "\\>/" .. replacement .. "/gc")
  end
end, { desc = "Interactive replace word under cursor with confirmation" })

map("v", "<leader>rc", function()
  vim.cmd('noau normal! "vy"')
  local selected = vim.fn.getreg("v")
  local replacement = vim.fn.input('Replace "' .. selected .. '" with: ')
  if replacement ~= "" then
    selected = vim.fn.escape(selected, "/\\")
    vim.cmd(":%s/" .. selected .. "/" .. replacement .. "/gc")
  end
end, { desc = "Interactive replace visual selection throughout file with confirmation" })

-- git stuff
map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("v", "<leader>hs", function()
  require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage hunk" })
map("v", "<leader>hr", function()
  require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset hunk" })
map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "<leader>hb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
map("n", "<leader>hd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
map("n", "<leader>hD", function()
  require("gitsigns").diffthis("~")
end, { desc = "Diff this ~" })
map("n", "<leader>ht", "<cmd>Gitsigns toggle_deleted<cr>", { desc = "Toggle deleted" })

-- coc

-- Function to jump to diagnostic and copy error message
local function jump_and_copy_diagnostic(direction)
  -- Jump to diagnostic
  if direction == "next" then
    vim.fn.CocActionAsync("diagnosticNext")
  else
    vim.fn.CocActionAsync("diagnosticPrevious")
  end

  -- Wait for jump, then get current diagnostic info
  vim.defer_fn(function()
    -- Try different coc methods to get current diagnostic
    local success = false

    -- Method 1: Try to get diagnostic under cursor
    local ok, diagnostic_info = pcall(vim.fn.CocAction, "diagnosticInfo")
    if ok and type(diagnostic_info) == "table" and diagnostic_info.message then
      local error_message = diagnostic_info.message
      local full_error = string.format("[%s:%d] %s", vim.fn.expand("%:."), vim.fn.line("."), error_message)
      vim.fn.setreg("+", full_error)
      print("Copied: " .. error_message:sub(1, 60) .. "...")
      success = true
    end

    -- Method 2: Fallback to position-based search
    if not success then
      local diagnostics = vim.fn.CocAction("diagnosticList")
      if type(diagnostics) == "table" and #diagnostics > 0 then
        local current_line = vim.fn.line(".")
        local current_col = vim.fn.col(".")

        local best_diagnostic = nil
        local closest_distance = math.huge

        -- Find diagnostic closest to cursor on current line
        for _, diagnostic in ipairs(diagnostics) do
          if type(diagnostic) == "table" and diagnostic.lnum == current_line then
            local distance = math.abs((diagnostic.col or 0) - current_col)
            if distance < closest_distance then
              closest_distance = distance
              best_diagnostic = diagnostic
            end
          end
        end

        if best_diagnostic and best_diagnostic.message then
          local error_message = best_diagnostic.message
          local full_error = string.format(
            "[%s:%d:%d] %s",
            vim.fn.expand("%."),
            best_diagnostic.lnum,
            best_diagnostic.col or 0,
            error_message
          )
          vim.fn.setreg("+", full_error)
          print("Copied: " .. error_message:sub(1, 60) .. "...")
          success = true
        end
      end
    end

    if not success then
      print("No diagnostic found to copy")
    end
  end, 200) -- Longer delay to ensure everything loads
end

map("n", "]e", function()
  jump_and_copy_diagnostic("next")
end, { silent = true })
map("n", "[e", function()
  jump_and_copy_diagnostic("previous")
end, { silent = true })
map("n", "]r", "<cmd>CocNext<cr>", { desc = "Coc Next" })
map("n", "[r", "<cmd>CocPrev<cr>", { desc = "Coc Previous" })

-- Quick log entry with Timeline > Month > Day structure
vim.keymap.set("n", "<leader>wl", function()
  local log_file = vim.fn.expand("~/work-log.md")
  local entry = vim.fn.input("Log entry: ")

  if entry ~= "" then
    -- Read file
    local lines = {}
    if vim.fn.filereadable(log_file) == 1 then
      lines = vim.fn.readfile(log_file)
    else
      lines = { "# Work Log", "" }
    end

    -- Check for Timeline header
    local has_timeline = false
    for _, line in ipairs(lines) do
      if line:match("^# Timeline") then
        has_timeline = true
        break
      end
    end

    if not has_timeline then
      table.insert(lines, "")
      table.insert(lines, "# Timeline")
      table.insert(lines, "")
    end

    -- Check for month header
    local month_header = "## " .. os.date("%B %Y")
    local has_month = false
    for _, line in ipairs(lines) do
      if line == month_header then
        has_month = true
        break
      end
    end

    if not has_month then
      table.insert(lines, month_header)
      table.insert(lines, "")
    end

    -- Check for date header
    local date_header = "### " .. os.date("%Y-%m-%d (%A)")
    local has_today = false
    for _, line in ipairs(lines) do
      if line == date_header then
        has_today = true
        break
      end
    end

    if not has_today then
      table.insert(lines, date_header)
      table.insert(lines, "")
    end

    -- Add entry with proper spacing
    local timestamp = "**" .. os.date("%I:%M %p") .. "** - "

    -- Ensure there's a blank line before the new entry if needed
    -- Check if last line is a timestamp entry (starts with **) or is not empty
    if #lines > 0 then
      local last_line = lines[#lines]
      if last_line ~= "" and (last_line:match("^%*%*") or last_line ~= "") then
        table.insert(lines, "")
      end
    end

    table.insert(lines, timestamp .. entry)
    table.insert(lines, "")

    -- Write file
    vim.fn.writefile(lines, log_file)
    print(" ✓ Logged: " .. entry)
  end
end, { desc = "Add work log entry" })

-- Open at Timeline section
vim.keymap.set("n", "<leader>wo", function()
  vim.cmd("e ~/work-log.md")
  vim.fn.search("^# Timeline")
  vim.cmd("normal! zz")
end, { desc = "Open work log at Timeline" })
