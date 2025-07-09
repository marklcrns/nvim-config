return function()
  -- Name assigned to the plugin directory.
  local amazonq_name = "amazonq"
  local amazonq_dir = vim.fn.stdpath('data') .. '/lazy/' .. amazonq_name

  -- Update runtime path to include AmazonQ
  if vim.fn.isdirectory(amazonq_dir) == 1 then
    vim.opt.runtimepath:append(amazonq_dir)
  else
    vim.notify('AmazonQNVim not found at ' .. amazonq_dir, vim.log.levels.ERROR)
  end

  require('amazonq').setup({
    -- Note: It's normally not necessary to change default `lsp_server_cmd`.
    lsp_server_cmd = {
      'node',
      amazonq_dir .. '/language-server/build/aws-lsp-codewhisperer-token-binary.js',
      '--stdio',
    },
    -- IAM Identity Center portal for organisation.
    ssoStartUrl = 'https://view.awsapps.com/start',
    inline_suggest = true,
    -- List of filetypes where the Q will be activated.
    -- Docs: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/q-language-ide-support.html
    -- Note: These must be valid Nvim filetypes. For example, Q supports "shell",
    -- but in the filetype name is "sh" (also "bash").
    filetypes = {
        'amazonq', 'bash', 'java', 'python', 'typescript', 'javascript', 'csharp', 'ruby', 'kotlin', 'sh', 'sql', 'c',
        'cpp', 'go', 'rust', 'lua',
    },
    on_chat_open = function()
      vim.cmd[[
        vertical topleft split
        set wrap breakindent nonumber norelativenumber nolist
      ]]
    end,
    -- Enable debug mode (for development).
    debug = false,
  })
end
