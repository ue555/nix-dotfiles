-- ddc.vimの設定
vim.fn['ddc#custom#patch_global']('ui', 'native')
vim.fn['ddc#custom#patch_global']('sources', { 'lsp', 'around' })
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  _ = {
    matchers = { 'matcher_head' },
    sorters = { 'sorter_rank' },
  },
  around = {
    mark = '[A]',
  },
  lsp = {
    mark = '[LSP]',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
    minAutoCompleteLength = 1,
  },
})
vim.fn['ddc#custom#patch_global']('sourceParams', {
  lsp = {
    snippetEngine = vim.fn['denops#callback#register'](function(body)
      return vim.fn['vsnip#anonymous'](body)
    end),
    enableResolveItem = true,
    enableAdditionalTextEdit = true,
  },
})

-- ddcを有効化
vim.fn['ddc#enable']()

-- 補完のキーマッピング
vim.keymap.set('i', '<C-n>', function()
  return vim.fn['ddc#map#manual_complete']()
end, { expr = true })

vim.keymap.set('i', '<Tab>', function()
  if vim.fn['ddc#visible']() then
    return '<Cmd>call ddc#map#select_next_item()<CR>'
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', '<Cmd>call ddc#map#select_previous_item()<CR>', { silent = true })

