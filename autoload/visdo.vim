" Normalizes text to a List of lines as Strings.
function! visdo#ToLOL(text)
  return type(a:text) == type([]) ? a:text : split(a:text, "\n")
endfunct

" Normalizes text to a String.
function! visdo#JoinLOL(text)
  return type(a:text) == type([]) ? join(a:text, "\n") : a:text
endfunction

" Creates a new buffer containing a:contents.
" Runs a:command
" Returns the contents of the changed buffer.
" If a:1 is given, it is used as the local execution context.
" This can be used to make global variables available without g: namespacing.
function! visdo#DoInNewBuffer(command, contents, ...)
  call extend(l:, a:0 ? a:1 : {})
  new
  try
    put =visdo#ToLOL(a:contents)
    normal ggdd
    exec a:command
    return getline('^', '$')
  finally
    bdel!
  endtry
endfunction

" Returns the contents of the current visual selection.
function! visdo#GetVisualSelection()
  let original_unnamed = [getreg('"'), getregtype('"')]
  try
    " Reactivate and yank the current visual selection.
    normal gvy
    let contents = @"
    return contents
  finally
    call call(function('setreg'), ['"'] + original_unnamed)
  endtry
endfunction

" Replaces the current visual selection's contents with a:contents
" a:contents can be a List of Strings or a String.
" Returns the previous contents of the the visual selection.
function! visdo#ReplaceVisualSelection(contents)
  let original_unnamed = [getreg('"'), getregtype('"')]
  try
    " Yank into the unnamed register to learn the regtype.
    " This can also be done with |visualmode()|
    " but that does not set the width for block mode.
    " TODO: Figure out if the width even matters.
    normal gvy
    call setreg('"', visdo#JoinLOL(a:contents), getregtype('"'))
    " let @" = visdo#JoinLOL(a:contents)
    " Reactivate the current visual selection and paste into it.
    normal gvp
    let previous_contents = @"
    return previous_contents
  finally
    call call(function('setreg'), ['"'] + original_unnamed)
  endtry
endfunction
