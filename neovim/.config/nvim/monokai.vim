" =============================================================================
" Filename: autoload/lightline/colorscheme/monokai.vim
" Author: kadelam
" License: MIT License
" Last Change: 2018/04/19 02:38:00.
" =============================================================================
"
let s:white = [ '#e8e8e3', 253 ]
let s:black = [ '#272822', 235 ]
let s:grey = [ '#8f908a', 243 ]
let s:pink = [ '#f92772', 197 ]
let s:blue = [ '#66d9ef', 81 ]
let s:green = [ '#a5e22d', 148 ]
let s:red = [ '#e73c50', 196 ]
let s:yellow = [ '#e6db74', 186 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:black, s:grey ], [ s:grey, s:black ] ]
let s:p.normal.middle = [ [ s:grey, s:black ] ]
let s:p.normal.right = [ [ s:pink, s:black ], [ s:black, s:pink ] ]
let s:p.normal.error = [ [ s:pink, s:black ] ]
let s:p.normal.warning = [ [ s:yellow, s:black ] ]
let s:p.insert.left = [ [ s:black, s:green ], [ s:green, s:black ] ]
let s:p.visual.left = [ [ s:black, s:pink ], [ s:pink, s:black ] ]
let s:p.replace.left = [ [ s:black, s:red ], [ s:red, s:black ] ]
let s:p.inactive.left =  [ [ s:pink, s:black ], [ s:white, s:black ] ]
let s:p.inactive.middle = [ [ s:grey, s:black ] ]
let s:p.inactive.right = [ [ s:white, s:pink ], [ s:pink, s:black ] ]
let s:p.tabline.left = [ [ s:grey, s:black ] ]
let s:p.tabline.middle = [ [ s:grey, s:black] ]
let s:p.tabline.right = copy(s:p.normal.right)
let s:p.tabline.tabsel = [ [ s:black, s:grey ] ]

let g:lightline#colorscheme#monokai#palette = lightline#colorscheme#flatten(s:p)
