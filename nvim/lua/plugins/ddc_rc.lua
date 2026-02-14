vim.fn['ddc#custom#patch_global']('ui', 'native')
vim.fn['ddc#custom#patch_global']('sources', { 'lsp', 'around' })
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  _ = {
    matchers = { 'matcher_head' },
    sorters = { 'sorter_rank' },
  },
  around = {
    mark = 'around',
  },
  ['nvim-lsp'] = {
    mark = 'lsp',
    forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
  },
})
vim.fn['ddc#enable']()

