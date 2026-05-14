return function()
  -- Map filetypes to TS parsers
  for ft, parser in pairs({
    handlebars = "glimmer",
  }) do
    vim.treesitter.language.register(ft, parser)
  end

  require("nvim-treesitter.configs").setup({
    -- Only install what has been seen at least once
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,  -- nvim-treesitter's highlight is enough; also stops repeated syntax/markdown.vim sourcing (~60ms on md open)
      disable = function(lang, bufnr)
        local kb = Config.common.utils.buf_get_size(bufnr)

        if kb > 320 then return true end

        return vim.tbl_contains({
          -- "vim",
          -- "help",
          -- "markdown", -- NOTE: Parser seems immature. Revisit later.
          -- "c", -- NOTE: Performance is abysmal in files of any notable length.
          -- "cpp",
          "latex",
          "comment",
          "haxe",
        }, lang)
      end,
    },
    indent = {
      enable = true,
      disable = {
        -- NOTE: This cause some issues with `gw` (format line) in normal mode not
        -- being properly indented in markdown files bullet points
        "markdown",
      }
    },

    -- Defined in nvim-treesitter-textobjects
    -- textobjects = {
    --   select = {
    --     enable = true,
    --     keymaps = {
    --       -- You can use the capture groups defined in textobjects.scm
    --       ["af"] = "@function.outer",
    --       ["if"] = "@function.inner",
    --       ["ac"] = "@class.outer",
    --       ["ic"] = "@class.inner",
    --     },
    --   },
    -- },

    -- Plugin: nvim-treesitter-textsubjects
    textsubjects = {
      enable = true,
      prev_selection = ";", -- (Optional) keymap to select the previous selection
      keymaps = {
        ["<cr>"] = "textsubjects-smart",
      },
    },
    -- Plugin: vim-matchup
    matchup = {
      enable = true,
    },
    -- Plugin: nvim-treesitter-endwise
    endwise = {
      enable = false,
    },
  })

  -- Patch nvim-treesitter's directives for Nvim 0.12+ TSNode[] arrays.
  -- Neovim 0.12+ changed match values to TSNode[] arrays, but the archived
  -- nvim-treesitter still treats them as single nodes — causing
  -- "attempt to call method 'range' (a nil value)" on markdown with fenced
  -- code blocks (set-lang-from-info-string!, downcase!) and HTML scripts
  -- (set-lang-from-mimetype!). Patches each directive with a handler that
  -- normalizes match values before extracting node text.
  do
    local query = vim.treesitter.query
    if query and query.add_directive then
      -- Helper: extract a single TSNode from a match value (may be array in 0.12+)
      local function extract_node(node)
        if type(node) == "table" and not vim.is_callable(node) then
          node = node[1]
        end
        if not node or not vim.is_callable(node.range) then return nil end
        return node
      end

      query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local node = extract_node(match[pred[2]])
        if not node then return end
        local text = vim.treesitter.get_node_text(node, bufnr)
        if not text then return end
        metadata["injection.language"] = (text:lower():match("^%s*(%S+)") or text)
      end, { force = true, all = false })

      query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = extract_node(match[id])
        if not node then return end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
        if not metadata[id] then metadata[id] = {} end
        metadata[id].text = string.lower(text)
      end, { force = true, all = false })

      -- HTML mimetype → language (for <script type="..."> injections)
      local html_mime = {
        ["application/json"] = "json",
        ["application/ld+json"] = "json",
        ["text/javascript"] = "javascript",
        ["application/javascript"] = "javascript",
        ["text/x-typescript"] = "typescript",
      }
      query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
        local node = extract_node(match[pred[2]])
        if not node then return end
        local val = vim.treesitter.get_node_text(node, bufnr)
        if not val then return end
        local configured = html_mime[val]
        if configured then
          metadata["injection.language"] = configured
        else
          local parts = vim.split(val, "/", {})
          metadata["injection.language"] = parts[#parts]
        end
      end, { force = true, all = false })
    end
  end
end
