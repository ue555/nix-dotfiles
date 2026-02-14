" DppUpdate
command! DppUpdate call dpp#async_ext_action('installer', 'update')
" DppInstall
command! DppInstall call dpp#async_ext_action('installer', 'install')

set number
