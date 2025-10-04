return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "npm install",
    event = "VeryLazy",
    config = function()
      -- Configure completion for coc.nvim
      vim.opt.completeopt = "menuone,noinsert,noselect"

      -- Some servers have issues with backup files
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
      -- delays and poor user experience.
      vim.opt.updatetime = 300

      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appear/become resolved.
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end

      -- Use tab for trigger completion with characters ahead and navigate.
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      -- keyset(
      --   "i",
      --   "<TAB>",
      --   'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      --   opts
      -- )
      -- keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use <c-space> to trigger completion.
      keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

      -- Use <Tab> and <S-Tab> for snippet navigation
      -- keyset("i", "<Tab>", 'coc#expandableOrJumpable() ? "<Plug>(coc-snippets-expand-jump)" : "<Tab>"', { silent = true, expr = true })
      -- keyset("i", "<S-Tab>", 'coc#jumpable() ? "<Plug>(coc-snippets-expand-jump)" : "<S-Tab>"', { silent = true, expr = true })

      -- Use `[e` and `]e` to navigate diagnostics
      -- keyset("n", "[e", "<Plug>(coc-diagnostic-prev)", { silent = true })
      -- keyset("n", "]e", "<Plug>(coc-diagnostic-next)", { silent = true })
      keyset("n", "]e", ":call CocAction('diagnosticNext')<CR>", { silent = true, desc = "Next error" })
      keyset("n", "[e", ":call CocAction('diagnosticPrevious')<CR>", { silent = true, desc = "Previous error" })

      -- GoTo code navigation.
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use <C-c> to select current element or to exit visual mode.
      keyset("n", "<C-c>", "<Plug>(coc-cursors-position)", { silent = true })
      keyset("x", "<C-c>", "<Plug>(coc-cursors-range)", { silent = true })

      -- Use K to show documentation in preview window.
      function _G.show_docs()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end

      keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

      -- Highlight the symbol and its references when holding the cursor.
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
      })

      -- Symbol renaming.
      keyset("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true })

      -- Formatting selected code.
      keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Setup formatexpr specified filetype(s).
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s).",
      })

      -- Update signature help on jump placeholder.
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder",
      })

      -- Remap keys for applying codeAction to the current buffer.
      keyset("n", "<leader>ca", "<Plug>(coc-codeaction)", { silent = true })
      -- Run the Code Lens action on the current line.
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", { silent = true })

      -- Map function and class text objects
      keyset("x", "if", "<Plug>(coc-funcobj-i)", { silent = true })
      keyset("o", "if", "<Plug>(coc-funcobj-i)", { silent = true })
      keyset("x", "af", "<Plug>(coc-funcobj-a)", { silent = true })
      keyset("o", "af", "<Plug>(coc-funcobj-a)", { silent = true })
      keyset("x", "ic", "<Plug>(coc-classobj-i)", { silent = true })
      keyset("o", "ic", "<Plug>(coc-classobj-i)", { silent = true })
      keyset("x", "ac", "<Plug>(coc-classobj-a)", { silent = true })
      keyset("o", "ac", "<Plug>(coc-classobj-a)", { silent = true })

      -- Remap <C-f> and <C-b> for scroll float windows/popups.
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Use CTRL-S for selections ranges.
      keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
      keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

      -- Add `:Format` command to format current buffer.
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- Add `:Fold` command to fold current buffer.
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

      -- Add `:OR` command for organize imports of the current buffer.
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

      -- Add (Neo)Vim's native statusline support.
      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

      -- Function to copy all diagnostics to clipboard
      function _G.copy_diagnostics_to_clipboard()
        local diagnostics = vim.fn.CocAction("diagnosticList")
        if #diagnostics == 0 then
          print("No diagnostics found")
          return
        end

        local output = {}
        for _, diagnostic in ipairs(diagnostics) do
          local file = diagnostic.file
          local line = diagnostic.lnum
          local col = diagnostic.col
          local message = diagnostic.message
          local severity = diagnostic.severity

          table.insert(output, string.format("[%s] %s:%d:%d - %s", severity, file, line, col, message))
        end

        local content = table.concat(output, "\n")
        vim.fn.setreg("+", content)
        print("Copied " .. #diagnostics .. " diagnostics to clipboard")
      end

      -- Mappings for CoCList
      keyset("n", "<leader>a", ":<C-u>CocList diagnostics<cr>", { silent = true, nowait = true })
      keyset(
        "n",
        "<leader>cd",
        "<CMD>lua _G.copy_diagnostics_to_clipboard()<CR>",
        { silent = true, desc = "Copy diagnostics to clipboard" }
      )
      -- keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
      -- keyset("n", "<space>c", ":<C-u>CocList commands<cr>", { silent = true, nowait = true })
      -- keyset("n", "<space>o", ":<C-u>CocList outline<cr>", { silent = true, nowait = true })
      -- keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", { silent = true, nowait = true })
      -- keyset("n", "<space>j", ":<C-u>CocNext<CR>", { silent = true, nowait = true })
      -- keyset("n", "<space>k", ":<C-u>CocPrev<CR>", { silent = true, nowait = true })
      -- keyset("n", "<space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true })
    end,
  },
}
