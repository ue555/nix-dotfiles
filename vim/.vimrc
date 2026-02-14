set nocompatible
let g:denops#debug = 1
const s:dpp_base = expand('$HOME/.cache/dpp/vim')
const s:dpp_src = '~/.cache/dpp/repos/github.com/Shougo/dpp.vim'
const s:denops_src = '~/.cache/dpp/repos/github.com/vim-denops/denops.vim'
const s:ext_toml = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml'
const s:ext_lazy = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy'
const s:ext_installer = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer'
const s:ext_git = '~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git'
const s:dpp_config = '~/dotfiles/vim/dpp.ts'

execute 'set runtimepath^=' .. s:dpp_src
execute 'set runtimepath^=' .. s:ext_toml
execute 'set runtimepath^=' .. s:ext_lazy
execute 'set runtimepath^=' .. s:ext_git
execute 'set runtimepath^=' .. s:ext_installer
execute 'set runtimepath^=' .. s:denops_src

if s:dpp_base->dpp#min#load_state()
  autocmd User DenopsReady
  \ : echohl WarningMsg
  \ | echomsg 'dpp load_state() is failed'
  \ | echohl NONE
  \ | call dpp#make_state(s:dpp_base, s:dpp_config)
endif

autocmd User Dpp:makeStatePost
      \ : echohl WarningMsg
      \ | echomsg 'dpp make_state() is done'
      \ | echohl NONE

source $HOME/dotfiles/vim/rc/filetype.vim
source $HOME/dotfiles/vim/rc/keymaps.vim
source $HOME/dotfiles/vim/rc/settings.vim
source $HOME/dotfiles/vim/scripts/historylist.vim
