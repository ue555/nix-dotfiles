# Copilot Instructions

This is a personal dotfiles repository. The primary focus is the Neovim configuration under `nvim/`.

## Repository Structure

- `nvim/` — Neovim config (Lua + TypeScript via Deno)
- `vim/` — Vim config (shares the same dpp.vim infrastructure)
- `nix/` — Nix configuration
- `ghostty/`, `wezterm/` — Terminal emulator configs
- `dpp_setup.sh` — Bootstrap script for dpp.vim + symlink creation

## Neovim Architecture

Plugin management uses **dpp.vim** (Shougo's plugin manager), which requires **Deno** via **denops.vim**. The boot flow is:

1. `nvim/init.lua` — Manually prepends `~/.cache/dpp/repos/...` paths to `runtimepath` and `package.path` (plugins are NOT on runtimepath by default until dpp loads)
2. `dpp#min#load_state()` reads the compiled state from `~/.cache/dpp/nvim/.dpp`; if missing, fires `DenopsReady` autocmd → `dpp#make_state()` which executes `nvim/dpp.ts`
3. `nvim/dpp.ts` (TypeScript, runs under Deno) loads all three TOML files and merges their plugin definitions via `dpp-ext-lazy`
4. Plugin-specific Lua setup runs via `lua_source` blocks in the TOML files, NOT from `init.lua` requires

**Key implication**: `require('plugins.lspconfig_rc')` etc. must be called from TOML `lua_source` blocks, not directly from `init.lua`, because plugins aren't on runtimepath at init time.

## Plugin Definitions (TOML files in `nvim/tomls/`)

| File | Contents |
|------|----------|
| `dpp.toml` | dpp.vim core + denops.vim extensions |
| `tool.toml` | nvim-tree, lualine, telescope, rainbow-delimiters, nui.nvim |
| `ddc.toml` | ddc.vim (completion), LSP (nvim-lspconfig, efm), neodev.nvim |

Adding a new plugin: add a `[[plugins]]` entry to the appropriate TOML file. Use `lua_source` for Lua config, `on_event`/`on_cmd`/`on_source` for lazy loading.

## Lua Config Layout

```
nvim/lua/
├── keymaps.lua        # Keymaps + user commands (DppUpdate, DppInstall, Format)
├── settings.lua       # Basic vim options (clipboard, number, listchars)
├── tool.lua           # Loads nvim-tree, lualine, rainbow-delimiters configs
├── ddc.lua            # ddc.vim completion config (loaded lazy via TOML)
├── plugins/           # Per-plugin setup files (called from TOML lua_source)
│   ├── lspconfig_rc.lua
│   ├── efmls_rc.lua
│   ├── lualine_rc.lua
│   ├── nvim-tree_rc.lua
│   └── ...
└── scripts/
    ├── historylist.lua
    └── auto-pairs.lua
```

## LSP Setup

Configured in `lua/plugins/lspconfig_rc.lua` using Neovim 0.11+ native `vim.lsp.config` / `vim.lsp.enable` API (not lspconfig's `setup()`):

- **gopls** — Go
- **ts_ls** — TypeScript/JavaScript
- **terraformls** — Terraform
- **efm** — Formatter bridge: stylua (Lua), prettier (TS/JS/TSX/JSX), gofmt (Go), terraform fmt

Auto-format on save is in `keymaps.lua` via `BufWritePre` for: `*.lua *.go *.ts *.js *.tsx *.jsx *.tf *.tfvars`

## Key Commands

### Setup / Bootstrap
```bash
bash dpp_setup.sh          # Clone dpp.vim repos + create ~/.config/nvim symlink
bash dpp_setup.sh link     # Create deno.json symlink (required for denops)
```

### Inside Neovim
```vim
" Initial state generation (run once after first launch)
:call dpp#make_state('~/.cache/dpp/', '~/.config/nvim/dpp.ts')

" Plugin management (also available as :DppInstall / :DppUpdate user commands)
:call dpp#async_ext_action('installer', 'install')
:call dpp#async_ext_action('installer', 'update')

" Manual format
:Format
```

### Debugging
```bash
# Check init.lua syntax
nvim --headless -c "luafile ~/.config/nvim/init.lua" -c "q"
```
```vim
:echo denops#server#status()   " Should return 'running'
:LspInfo
:messages
```

## Conventions

- Plugin Lua config lives in `lua/plugins/<plugin-name>_rc.lua` and is called from TOML `lua_source`, not from `init.lua`
- Keymaps use `]` as a prefix for tool shortcuts (e.g., `]e` = NvimTreeOpen, `]ff` = Telescope find_files)
- Tab width: 2 spaces, using actual tab characters (`expandtab = false`)
- The Vim config (`vim/`) mirrors the Neovim config structure; both share the same `~/.cache/dpp/repos/` plugin cache but have separate TOML/cache paths
