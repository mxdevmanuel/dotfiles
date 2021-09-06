setlocal formatprg=gofmt
setlocal makeprg=go\ build

setlocal errorformat =%-G#\ %.%#                                 " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
setlocal errorformat+=%-G%.%#panic:\ %m                          " Ignore lines containing 'panic: message'
setlocal errorformat+=%Ecan\'t\ load\ package:\ %m               " Start of multiline error string is 'can\'t load package'
setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m    " Start of multiline unspecified string is 'filename:linenumber:'
setlocal errorformat+=%C%*\\s%m                                  " Continuation of multiline error message is indented
setlocal errorformat+=%-G%.%#
