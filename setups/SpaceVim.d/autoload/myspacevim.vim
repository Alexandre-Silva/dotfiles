function! myspacevim#before() abort
  set clipboard^=unnamed,unnamedplus
endfunction


function! myspacevim#after() abort
  lua << EOF
    require('telescope').load_extension('fzf')

    -- execute myspacevim_after.lua
    require('myspacevim_after')
EOF
endfunction
