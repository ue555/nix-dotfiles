mkdir -p ~/.cache/dpp/repos/github.com/
cd ~/.cache/dpp/repos/github.com/

directories=(
  "Shougo"
  "vim-denops"
)
for directory in "${directories[@]}" ; do
  mkdir -p ${directory}
done

cd ./Shougo
shougo_items=(
  "dpp.vim"
  "dpp-ext-installer"
  "dpp-protocol-git"
  "dpp-ext-lazy"
  "dpp-ext-toml"
)

for item in "${shougo_items[@]}" ; do
  if [ ! -d ${item} ]; then
    git clone https://github.com/Shougo/${item}
  fi
done

cd ../vim-denops
if [ ! -d denops.vim ]; then
  git clone https://github.com/vim-denops/denops.vim
fi

ln -s ~/dotfiles/vim/.vimrc ~/.vimrc

ln -s ~/dotfiles/nvim/ ~/.config/nvim

# dppキャッシュのdenopsプラグインにdeno.jsonをリンクする関数
# Vimを起動してdpp#make_state()が実行された後に実行する
link_denops_deno_json() {
  local dpp_cache_dir="$HOME/.cache/dpp"
  local repos_dir="$dpp_cache_dir/repos/github.com"

  for vim_type in vim nvim; do
    local denops_cache="$dpp_cache_dir/$vim_type/.dpp/denops"

    if [ ! -d "$denops_cache" ]; then
      continue
    fi

    # メインのdenopsプラグイン (ddc, dpp等)
    for plugin_dir in "$denops_cache"/*/; do
      local plugin_name=$(basename "$plugin_dir")
      # @で始まるディレクトリはスキップ（後で処理）
      if [[ "$plugin_name" == @* ]]; then
        continue
      fi

      # 対応するリポジトリのdeno.jsonを探す
      for repo in "$repos_dir"/*/"$plugin_name".vim/denops/"$plugin_name"/deno.json; do
        if [ -f "$repo" ]; then
          local target="$plugin_dir/deno.json"
          if [ ! -e "$target" ]; then
            ln -sf "$repo" "$target"
            echo "Linked: $target"
          fi
        fi
      done
    done

    # @ddc-sources等のサブディレクトリ
    for at_dir in "$denops_cache"/@*/; do
      if [ ! -d "$at_dir" ]; then
        continue
      fi
      local at_name=$(basename "$at_dir")

      for source_dir in "$at_dir"/*/; do
        if [ ! -d "$source_dir" ]; then
          continue
        fi
        local source_name=$(basename "$source_dir")

        # 対応するリポジトリのdeno.jsonを探す
        for repo in "$repos_dir"/*/*/denops/"$at_name"/"$source_name"/deno.json; do
          if [ -f "$repo" ]; then
            local target="$source_dir/deno.json"
            if [ ! -e "$target" ]; then
              ln -sf "$repo" "$target"
              echo "Linked: $target"
            fi
          fi
        done
      done
    done
  done
}

# 引数に "link" が渡された場合にdeno.jsonリンク処理を実行
if [ "$1" = "link" ]; then
  link_denops_deno_json
fi
