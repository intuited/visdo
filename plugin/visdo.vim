" Execs its argument as a command on the visual selection in a new buffer.
" Replaces the visual selection contents with the result.
" Allows commands to be run on character- and block-wise selections
" as though they were entire lines.
" The local or global variable context is made available to the execed command
" as its local context.
command! -range -nargs=1 -complete=command VisDo
      \ call visdo#ReplaceVisualSelection(
      \   visdo#DoInNewBuffer(<q-args>,
      \                       visdo#GetVisualSelection(),
      \                       exists('l:') ? l: : g:))
