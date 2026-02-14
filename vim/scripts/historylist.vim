let g:access_history = []

augroup AccessHistoryTracker
  autocmd!
  autocmd BufRead,BufNewFile * call s:UpdateAccessHistory()
augroup END

function! s:UpdateAccessHistory() abort
  let l:path = expand('%:p')

  if !filereadable(l:path)
        \ || l:path =~# '^/tmp/'
        \ || l:path =~# '\.git/'
        \ || l:path =~# '^fugitive://'
    return
  endif

  call insert(g:access_history, l:path, 0)

  let seen = {}
  let unique = []
  for file in g:access_history
    if !has_key(seen, file)
      let seen[file] = 1
      call add(unique, file)
    endif
  endfor
  let g:access_history = unique[:14]
endfunction

function! ShowFileList()
  let g:dotfile_original_winid = win_getid()
  new
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nowrap
  setlocal nonumber norelativenumber

  if !exists('g:access_history') || empty(g:access_history)
    call setline(1, [' Access History Files '])
  else
    call setline(1, g:access_history)
  endif

  setlocal readonly
  nnoremap <buffer> <CR> :call OpenSelectedFile()<CR>
endfunction

function! OpenSelectedFile()
  let l:filepath = getline('.')
  let l:filepath = expand(l:filepath)
  let l:history_buf = bufnr('%')
  execute 'bd! ' . l:history_buf
  if filereadable(l:filepath)
    call win_execute(g:dotfile_original_winid, 'edit ' . fnameescape(l:filepath))
  else
    echohl ErrorMsg | echom 'File not found: ' . l:filepath | echohl None
  endif
endfunction

command! AccessHistoryList call ShowFileList()
