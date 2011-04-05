command! -nargs=1 Dump echo <q-args> . ": " . string(<args>)

" Return 1-based column numbers for the start and end of the visual selection.
function! GetVisualCols()
  return [getpos("'<")[2], getpos("'>")[2]]
endfunction

" Convert from a 0-based string index to RE atom using 1-based column index
function! ColAtom(index)
  return '\%' . string(a:index + 1) . 'c'
endfunction

" Replaces the substring of a:str from a:start to a:end (inclusive)
" with a:repl
function! StrReplace(str, start, end, repl)
  let regexp = ColAtom(a:start) . '.*' . ColAtom(a:end + 1)
  return substitute(a:str, regexp, a:repl, '')
endfunction

function! TransformVisual(Transform)
  let line = getline("'<")

  let [startCol, endCol] = GetVisualCols()
  Dump [startCol, endCol]

  " Column numbers are 1-based; string indexes are 0-based
  let [startIndex, endIndex] = [startCol - 1, endCol - 1]

  let visualSelection = line[startIndex : endIndex]
  Dump visualSelection
  let transformed = a:Transform(visualSelection)
  Dump transformed
  let transformed_line = StrReplace(line, startIndex, endIndex, transformed)
  Dump transformed_line
  call setline("'<", transformed_line)
endfunction

function! ReverseWords(words)
  return join(reverse(split(a:words)))
endfunction
