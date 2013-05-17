" This plugin is for viewing fireos source page,
" Not a debugger but can have concepts of items


" exam if python exists
if !has('python')
    echoerr "python can't be found"
    finish
endif

if exists("g:loaded_m_viewer") || &cp
    finish
endif
let s:pattern = ''

let g:loaded_m_viewer=0
highlight iframe term=reverse ctermbg=4 ctermfg=7

function Mload()
    "call this function will enable marionette viewer
    "error if 1. adb forward is not ready
    "         2. m_view.py is not started (as a bridge daemon)
    if g:loaded_m_viewer == 0
        let g:loaded_m_viewer=1
        set syntax=xml
        let s:m_viewer_filename=expand("<sfile>")
        let b:setmodifiable = 1
        call s:refresh()
        nmap <buffer> <Right> :call <SID>stepin()<CR>
        nmap <buffer> <F5> :call <SID>refresh()<CR>
        nmap <buffer> <Left> :call <SID>stepout()<CR>
        nmap <buffer> <F8> :call <SID>sforward()<CR>
        nmap <buffer> <F9> :call <SID>sbackward()<CR>
        let m = matchadd('iframe', "<iframe[^>]*>")
    endif
endfunction


function Munload()
    "unload all function mapping for marionette viewer
    "for unknown reason the unload function seems not completed; keep tracking
    if g:loaded_m_viewer == 1
        if exists('m')
            echo "matched"
            call matchdelete(m)
        endif
        let g:loaded_m_viewer=0
        let b:setmodifiable=0
        nunmap <buffer> <Right>
        nunmap <buffer> <F5>
        nunmap <buffer> <Left>
        nunmap <buffer> <F8>
        nunmap <buffer> <F9>
    endif
endfunction


function CreateIndex()
    "search for current buffer, store position of all iframes
    "SForward() and SBackward use the index

endfunction


function s:sforward()
    call search("<iframe[^>]*>")
endfunction


function s:sbackward()
    call search("<iframe[^>]*>", 'b')
endfunction


function s:stepin()
    if !exists("g:loaded_m_viewer")
        finish
    endif
    let a:src = matchstr(getline('.')[col('.'):], 'src="[a-z]*:\/\/[^ >,;]*"' )
    if empty(a:src)
        echo "No iframe found"
        return
    endif
    normal! ggdG
python << EOF
import sys
import os
import vim

sys.path.append(os.path.expanduser("~/.vim/plugin"))
import m_viewer_client as m
iframe=vim.eval('a:src')
b = vim.current.buffer
lines = m.switch_to_frame(iframe).split("\n")
lines = [x.encode('utf-8') for x in lines]
b.append(lines)
EOF
endfunction

function s:refresh()
    if !exists("g:loaded_m_viewer")
        finish
    endif
    normal! ggdG
python <<EOF
import sys
import os
import vim

sys.path.append(os.path.expanduser("~/.vim/plugin"))
import m_viewer_client as m
lines = m.page_source().split("\n")
b = vim.current.buffer
lines = [x.encode('utf-8') for x in lines]
b.append(lines)
EOF
endfunction

function s:stepout()
    if !exists("g:loaded_m_viewer")
        finish
    endif
    let current = getline('.')
    normal! ggdG
python << EOF
import sys
import os
import vim

sys.path.append(os.path.expanduser("~/.vim/plugin"))
import m_viewer_client as m
lines = m.switch_to_frame().split("\n")
b = vim.current.buffer
lines = [x.encode('utf-8') for x in lines]
b.append(lines)
EOF
endfunction

nmap <buffer> <F6> :call Mload()<CR>
nmap <buffer> <F7> :call Munload()<CR>


