" Execs its argument as a command on the visual selection in a new buffer.
" Replaces the visual selection contents with the result.
" Allows commands to be run on character- and block-wise selections
" as though they were entire lines.
" The global variable context is made available to the execed command.
" TODO: What if it's called from within a function?  It should pass `l:`.
command! -range -nargs=1 VisDo
      \ call visdo#ReplaceVisualSelection(
      \   visdo#DoInNewBuffer(<q-args>,
      \                       visdo#GetVisualSelection(),
      \                       g:))
