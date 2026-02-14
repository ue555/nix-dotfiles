filetype plugin indent on

augroup FiletypeByExtension
  autocmd!
  autocmd BufRead,BufNewFile *.go   set filetype=go
  autocmd BufRead,BufNewFile *.ts   set filetype=typescript
  autocmd BufRead,BufNewFile *.js   set filetype=javascript
  autocmd BufRead,BufNewFile *.vue  set filetype=vue
  autocmd BufRead,BufNewFile *.rb   set filetype=ruby
  autocmd BufRead,BufNewFile *.rs   set filetype=rust
  autocmd BufRead,BufNewFile *.lua  set filetype=lua
  autocmd BufRead,BufNewFile *.vim  set filetype=vim
augroup END
