function! myspacevim#before() abort
  set clipboard^=unnamed,unnamedplus
endfunction


function! myspacevim#after() abort
  lua << EOF
    require('telescope').load_extension('fzf')
EOF
endfunction
