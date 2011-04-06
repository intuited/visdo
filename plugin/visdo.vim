" Return 1-based column numbers for the start and end of the visual selection.
function! GetVisualCols()
  return [getpos("'<")[2], getpos("'>")[2]]
endfunction

" Convert a 0-based string index to an RE atom using 1-based column index
" :help /\%c
function! ColAtom(index)
  return '\%' . string(a:index + 1) . 'c'
endfunction

" Replace the substring of a:str from a:start to a:end (inclusive)
" with a:repl
function! StrReplace(str, start, end, repl)
  let regexp = ColAtom(a:start) . '.*' . ColAtom(a:end + 1)
  return substitute(a:str, regexp, a:repl, '')
endfunction

" Replace the character-wise visual selection
" with the result of running a:Transform on it.
" Only works if the visual selection is on a single line.
function! TransformCharwiseVisual(Transform)
  let [startCol, endCol] = GetVisualCols()

  " Column numbers are 1-based; string indexes are 0-based
  let [startIndex, endIndex] = [startCol - 1, endCol - 1]

  let line = getline("'<")
  let visualSelection = line[startIndex : endIndex]
  let transformed = a:Transform(visualSelection)
  let transformed_line = StrReplace(line, startIndex, endIndex, transformed)

  call setline("'<", transformed_line)
endfunction

function! ReverseWords(words)
  return join(reverse(split(a:words)))
endfunction

" Use -range to allow range to be passed
" as by default for commands initiated from visual mode,
" then ignore it.
command! -range ReverseCharwiseVisualWords
      \ call TransformCharwiseVisual(function('ReverseWords'))


function! TransformYankPasteVisual(Transform)
  let original_unnamed = [getreg('"'), getregtype('"')]
  try
    " Reactivate and yank the current visual selection.
    normal gvy
    let @" = a:Transform(@")
    normal gvp
  finally
    call call(function('setreg'), ['"'] + original_unnamed)
  endtry
endfunction




command! -range -nargs=1 VisDo
      \ call visdo#ReplaceVisualSelection(
      \   visdo#DoInNewBuffer(<q-args>,
      \                       visdo#GetVisualSelection(),
      \                       g:))
