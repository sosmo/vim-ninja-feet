function! s:ninja_prepare(mode, direction, count)
	let s:direction = a:direction
	let s:operator = v:operator
	let s:cursor_pos = getpos('.')
	let s:operatorfunc = &operatorfunc
	call feedkeys(a:count.a:mode)
endfunction

function! s:ninja_strike(mode)
	call setpos('.', s:cursor_pos)
	let &operatorfunc = s:operatorfunc
	" note 'v' and 'V' are flipped because of personal mapping
	let mode = a:mode == 'line' ? 'v' : 'V'
	call feedkeys(s:operator.mode.'`'.s:direction)
endfunction

function! s:ninja_insert(mode)
	let op = a:mode == 'line' ? 'O' : 'i'
	call feedkeys('`['.op, 'n')
endfunction

function! s:ninja_append(mode)
	let op = a:mode == 'line' ? 'o' : 'a'
	call feedkeys('`]'.op, 'n')
endfunction

function! s:map_expr(sid, type, direction, count)
	let map = ''
	let map .= "\<Esc>"
	let map .= ":\<C-U>call ".a:sid."ninja_prepare('".a:type."', '".a:direction."', '".a:count."')\<CR>"
	let map .= ":\<C-U>set operatorfunc=".a:sid."ninja_strike\<CR>g@"
	return map
endfunction

function! s:map(lhs, rhs, mode)
	if !hasmapto(a:rhs, a:mode)
		execute a:mode.'map '.a:lhs.' '.a:rhs
	endif
endfunction

onoremap <silent> <expr> <Plug>(ninja-left-foot-inner)  <SID>map_expr("<SID>", 'i', '[', v:count1)
onoremap <silent> <expr> <Plug>(ninja-left-foot-a)      <SID>map_expr("<SID>", 'a', '[', v:count1)
onoremap <silent> <expr> <Plug>(ninja-right-foot-inner) <SID>map_expr("<SID>", 'i', ']', v:count1)
onoremap <silent> <expr> <Plug>(ninja-right-foot-a)     <SID>map_expr("<SID>", 'a', ']', v:count1)

nnoremap <silent> <Plug>(ninja-insert) :<C-U>set operatorfunc=<SID>ninja_insert<CR>g@
nnoremap <silent> <Plug>(ninja-append) :<C-U>set operatorfunc=<SID>ninja_append<CR>g@

if !exists('g:ninja_feet_no_mappings')
	call s:map('[i', "<Plug>(ninja-left-foot-inner)", 'o')
	call s:map('[a', "<Plug>(ninja-left-foot-a)", 'o')
	call s:map(']i', "<Plug>(ninja-right-foot-inner)", 'o')
	call s:map(']a', "<Plug>(ninja-right-foot-a)", 'o')

	call s:map('z[', "<Plug>(ninja-insert)", 'n')
	call s:map('z]', "<Plug>(ninja-append)", 'n')
endif
