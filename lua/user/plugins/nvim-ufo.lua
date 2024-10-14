return function()
  ---@diagnostic disable: unused-local, unused-function, undefined-field

  ------------------------------------------enhanceAction---------------------------------------------
  local function peekOrHover()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if winid then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      local keys = { 'a', 'i', 'o', 'A', 'I', 'O', 'gd', 'gr' }
      for _, k in ipairs(keys) do
        -- Add a prefix key to fire `trace` action,
        -- if Neovim is 0.8.0 before, remap yourself
        vim.keymap.set('n', k, '<CR>' .. k, { noremap = false, buffer = bufnr })
      end
    else
      -- nvimlsp
      vim.lsp.buf.hover()
    end
  end

  -- DEPRECATED: Defined in nvim-treesitter-textobjects
  -- local function goPreviousClosedAndPeek()
  --     require('ufo').goPreviousClosedFold()
  --     require('ufo').peekFoldedLinesUnderCursor()
  -- end
  --
  -- local function goNextClosedAndPeek()
  --     require('ufo').goNextClosedFold()
  --     require('ufo').peekFoldedLinesUnderCursor()
  -- end

  local function applyFoldsAndThenCloseAllFolds(providerName)
    require('async')(function()
      local bufnr = vim.api.nvim_get_current_buf()
      -- make sure buffer is attached
      require('ufo').attach(bufnr)
      -- getFolds return Promise if providerName == 'lsp'
      local ranges = await(require('ufo').getFolds(bufnr, providerName))
      if not vim.tbl_isempty(ranges) then
        local ok = require('ufo').applyFolds(bufnr, ranges)
        if ok then
          require('ufo').closeAllFolds()
        end
      end
    end)
  end

  ------------------------------------------enhanceAction---------------------------------------------

  ---------------------------------------setFoldVirtTextHandler---------------------------------------
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ("  %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        -- str width returned from truncate() may less than 2nd argument, need padding
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end
      curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
  end

  ---------------------------------------setFoldVirtTextHandler---------------------------------------

  vim.o.foldcolumn = "0"    -- '0' is not bad
  vim.o.foldlevel = 99      -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = -1 -- Open buffer with all folds closed
  vim.o.foldenable = true

  local ftMap = {
    vim = "indent",
    python = { "indent" },
    git = "",
  }

  ---@param bufnr number
  ---@return Promise
  local function customizeSelector(bufnr)
    local function handleFallbackException(err, providerName)
      if type(err) == 'string' and err:match('UfoFallbackException') then
        return require('ufo').getFolds(bufnr, providerName)
      else
        return require('promise').reject(err)
      end
    end

    return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
      return handleFallbackException(err, 'treesitter')
    end):catch(function(err)
      return handleFallbackException(err, 'indent')
    end)
  end

  require("ufo").setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds_for_ft = {
      default = { 'imports', 'comment' },
      json = { 'array' },
      c = { 'comment', 'region' }
    },
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        -- winhighlight = "Normal:Folded",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-f>",
        scrollD = "<C-b>",
      },
    },
    fold_virt_text_handler = handler,
    -- NOTE: This causes annoying auto closing all folds on buffer write and any movements outside of folds
    provider_selector = function(bufnr, filetype, buftype)
      return ftMap[filetype] or customizeSelector
    end,
  })

  vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
  vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
  vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  vim.keymap.set("n", "K", peekOrHover)

  -- DEPRECATED: Defined in nvim-treesitter-textobjects
  -- vim.keymap.set("n", "]z", goNextClosedAndPeek)
  -- vim.keymap.set("n", "[z", goPreviousClosedAndPeek)

  local hl = Config.common.hl
  local hi, hi_link, hi_clear = hl.hi, hl.hi_link, hl.hi_clear
  hi("Folded", { bg = "NONE" })
  hi_link("UfoFoldedFg", "Normal")
  hi_link("UfoFoldedBg", "Folded")
  hi_link("UfoPreviewSbar", "PmenuSbar")
  hi_link("UfoPreviewThumb", "PmenuThumb")
  hi_link("UfoPreviewWinBar", "UfoFoldedBg")
  hi_link("UfoPreviewCursorLine", "Visual")
  hi_link("UfoFoldedEllipsis", "Comment")
  hi_link("UfoCursorFoldedLine", "CursorLine")
end
