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
    isVolatile = true,
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
-- <C-Space>: 手動で補完トリガー
vim.keymap.set('i', '<C-Space>', function()
  return vim.fn['ddc#map#manual_complete']()
end, { expr = true })

-- <Tab>/<S-Tab>: 候補を選択して確定（newlineなし）
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  else
    return '<S-Tab>'
  end
end, { expr = true })

-- <CR>: 常に改行（Tabで確定済みのため）
vim.keymap.set('i', '<CR>', '<CR>', {})

