return function()
  require('render-markdown').setup({
    -- Window options to use that change between rendered and raw view
    win_options = {
        -- See :h 'conceallevel'
        conceallevel = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value('conceallevel', {}),
            -- Used when being rendered, concealed text is completely hidden
            rendered = 3,
        },
        -- See :h 'concealcursor'
        concealcursor = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value('concealcursor', {}),
            -- Used when being rendered, conceal text in all modes
            -- rendered = 'nvic',
            rendered = 'c',
        },
    },
    code = {
        -- Turn on / off code block & inline code rendering
        enabled = true,
        -- Determines how code blocks & inline code are rendered:
        --  none: disables all rendering
        --  normal: adds highlight group to code blocks & inline code
        --  language: adds language icon to sign column and icon + name above code blocks
        --  full: normal + language
        style = 'full',
        -- Highlight for code blocks & inline code
        highlight = 'ColorColumn',
    },
    heading = {
        -- Turn on / off heading rendering
        enabled = true,
    }
  })
end
