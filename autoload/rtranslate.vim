function! rtranslate#FindYamlLine(filename, position)
  let lines         = readfile(a:filename)
  let path          = split(a:position, '\.')
  let indent        = ''
  let target_lineno = 0
  let lineno        = 0

  for line in lines
    let lineno += 1

    if line =~ '^'.indent.'\s*'.path[0].':'
      let path          = path[1:]
      let indent        = substitute(line, '^\(\s*\).*$', '\1', '')
      let target_lineno = lineno
    endif

    if empty(path)
      break
    endif
  endfor

  return target_lineno
endfunction

function! rtranslate#EditYaml(filename, position)
  let line = rtranslate#FindYamlLine(a:filename, a:position)
  exe 'edit '.a:filename

  if line > 0
    call cursor(line, 0)
    normal! _
    silent! normal! zO
  endif
endfunction

function! rtranslate#AddYamlEntry(filename, position, key, value)
  call rtranslate#EditYaml(a:filename, a:position)

  let base_indent = indent(line('.'))
  let line        = nextnonblank(line('.') + 1)

  while line('.') <= line('$') && indent(line) > base_indent
    let line = nextnonblank(line + 1)
  endwhile

  let @z = a:key.': '.a:value."\n"
  normal! "zp==
endfunction
