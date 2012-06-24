command! -nargs=+ -count=0 Rtranslate call s:Rtranslate(<count>, <f-args>)
function! s:Rtranslate(count, position, key, ...)
  if a:count > 0
    let value = sj#GetMotion('gv')
    call sj#ReplaceMotion('gv', a:position.'.'.a:key)
    write
  else
    let value = join(a:000, ' ')
  endif

  let saved_view = winsaveview()

  call rtranslate#AddYamlEntry('config/locales/en.yml', a:position, a:key, value)
  write
  exe 'edit '.expand('#')

  call winrestview(saved_view)
endfunction

" function! s:CompleteRtranslate(A, L, P)
"   let lines   = readfile('config/locales/en.yml')
"   let entries = []
"
"   for line in lines
"     call add(entries, substitute(line, '^\s*\(.\{-}\):.*', '\1', ''))
"   endfor
"
"   return join(entries, "\n")
" endfunction
