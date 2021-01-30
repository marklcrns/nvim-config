# Neovim Configs

⚡ Fast startup, lazy-loaded plugins, and featureful Neovim configurations made
with obsession 🤤 and ❤

![Dashboard](./demo/dashboard.png)
![Neovim](./demo/neovim.png)
![Demo](./demo/demo.gif)

Statusline and tabline plugin from [rafi/vim-config](https://github.com/rafi/vim-config).

## Requirements

- Neovim 0.5+
- Nodejs and npm
- Python 3+
- Python 2+ (Required for taskwiki.vim)
- pandoc (Required for vimwiki)
- yarn (Optional for markdown-preview.vim)
- cargo (Optional for minimap.vim)

## Installation

Clone repository into `~/.config/nvim`

```bash
git clone --ff-only --branch master https://github.com/marklcrns/nvim-config ~/.config/nvim
```

Then simply run `make` to install all the necessary dependencies and
directories.

```bash
cd ~/.config/nvim

make
# or
make install
```

This will install all dependencies and create `env` python virtual environment
in root directory for `python_host_prog` and `python3_host_prog` instead of
using global python.

### Full / Minimal / Skip / Disable Plugins

Easy switch between `full`, `minimal`, `skip`, and `disable` plugin handler mode.

Just edit the global variable in `/core/core.vim`

```vim
" NOTE: Must run `:call dein#recache_runtimepath()` when switching between modes
" and toggling g:init_secondary_config
" To delete unused plugins, run `:call map(dein#check_clean(), "delete(v:val, \"rf\")")`
" -----
" full    = loads /config/plugins.yaml (default)
" minimal = loads /config/plugins_minimal.yaml
" skip    = no load plugins (excluding ~/.local-nvim.d/config/plugins.yaml)
"	disable = disable package manager (no plugins will be loaded)
let g:handle_plugins = 'full'
let g:init_secondary_config = 0
```

Secondary init.vim config should be located in `~/.local-nvim.d/init.vim` and
would be loaded when `g:init_secondary_config = 1`. This will be sourced after
all the main configs in `core` are sourced and can be modified freely.

Also, local plugins can be installed in the same relative directory as the main
one `~/.local-nvim.d/config/plugins.yaml`

### Negating Existing Plugins In Local Config

If you wan't to disable some plugins but don't want to mess with the main
configuration, you can create a local config files as an extension of the main.

The main configuration uses `/config/plugins.yaml` to manage plugins with
[dein](https://github.com/Shougo/dein.vim) which most are lazy-loaded and can
easily be disabled. see
[manage-vim-plugins-via-yaml](http://genkisugimoto.com/blog/manage-vim-plugins-via-yaml/)
blog post for more.

By default, it uses `~/.local-nvim.d/config/plugins.yaml` as the secondary
plugins installer file. Just simply add the plugins you want to disable as such:

```vim
- repo: andrep/vimacs
  if: 0
" Much cleaner syntax
- {repo: andrep/vimacs, if: 0}
```

## Notable Plugins

Productivity plugins I use on the daily for all sorts of reason.

### Vimwiki

A powerful personal wiki creator for all sorts of needs.

- [vimwiki/vimwiki](https://github.com/vimwiki/vimwiki)

![Vimwiki](./demo/vimwiki.gif)

[Demo](https://marklcrns.github.io/wiki/docs/html/index.html) Wiki with custom
css and [wiki2html script](https://github.com/marklcrns/nvim-config/blob/master/config/plugins/wiki2html.sh)

### Taskwiki

Task warrior and Vimwiki integration

![Taskwiki](./demo/taskwiki.gif)

### UltiSnips

[honza/vim-snippets](https://github.com/honza/vim-snippets) will automatically
be installed which contains various community-maintained programming languages
snippets.

Additionally, UltiSnips is configured to source custom personal snippets from
`$HOME/.vim/UltiSnips` directory.

Run `:UltiSnipsEdit!` in vim command line to edit all snippets for the current
buffer filetype

- [My personal UltiSnips snippets](https://github.com/marklcrns/ultisnips-snippets)

<br>
<br>

## Credits

Thanks to the following (Neo)Vim configs and to all the geniuses behind the
plugins that made this repo possible.

- [ThinkVim](https://github.com/hardcoreplayers/ThinkVim)
- [Rafi's vim-config](https://github.com/rafi/vim-config)
- [66RING's .vim](https://github.com/66RING/.vim)

