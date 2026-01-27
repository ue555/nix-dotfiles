# ~/.local/bin をPATHに追加（ユーザーローカルの実行ファイル用）
export PATH="$HOME/.local/bin:$PATH"

# mise（旧rtx）の初期化 - 複数バージョンのプログラミング言語を管理するツール
eval "$(mise activate zsh)"

# Homebrew の環境変数を設定（Apple Silicon Mac用）
eval "$(/opt/homebrew/bin/brew shellenv)"
