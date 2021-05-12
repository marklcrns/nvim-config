local lspconfig = require'lspconfig'

-- local pid = vim.fn.getpid()
-- local omnisharp = "/home/markl/Downloads/omnisharp/run"
-- 
-- lspconfig.omnisharp.setup {
--   cmd = { omnisharp, "--languageserver" , "--hostPID", tostring(pid) };
--   filetypes = {'cache', 'cs', 'csproj', 'dll', 'nuget', 'props', 'sln', 'targets'};
--   init_options = {};
--   root_dir = lspconfig.util.root_pattern(".sln", ".git");
-- }

lspconfig.csharp.setup {
  filetypes = { "cs", "vb" };
  init_options = {};
  root_dir = lspconfig.util.root_pattern(".csproj", ".sln", ".git");
}

