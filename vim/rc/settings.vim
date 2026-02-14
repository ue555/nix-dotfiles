set list
set listchars=tab:»·,space:·,trail:~,extends:»,precedes:«,nbsp:␣

" デフォルトのタブ設定
set tabstop=2
set shiftwidth=2
set noexpandtab

" Goファイルはタブ幅2で表示（Goの標準はタブ文字を使う）
autocmd FileType go setlocal tabstop=2 shiftwidth=2 noexpandtab
