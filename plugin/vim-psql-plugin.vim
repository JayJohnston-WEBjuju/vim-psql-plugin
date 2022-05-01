" Plugin: vim-psql-plugin
" Author: Jay Johnston <github@webjuju.com>
" License: Apache License, Version 2.0
" Origin: https://github.com/JayJohnston-WEBjuju/vim-psql-plugin

if exists("g:vim_psql_plugin_loaded") || &cp
	finish
endif

let g:vim_psql_plugin_loaded = 1
let g:vim_psql_plugin_sqleof = ';'

fun! g:P_RunShellCommand(shell_command)
	echohl String | echon '$ ' . a:shell_command[0:winwidth(0)-11] . '...' | echohl None
	redraw

	silent! exe "noautocmd botright pedit ¦"
	noautocmd wincmd P
	setl stl =Running...please\ wait
	redraw
	setlocal modifiable
	setlocal nowrap
	normal ggdG

	set buftype=nofile
	silent! exe "noautocmd .! " . a:shell_command

	normal gg
"	normal ggG
"	let time = getline(".")
"	exe 'setl stl=Done\ in\ ' . time[6:]
"	normal kdG
	exe 'setl stl=Done'

	setlocal nomodifiable
	noautocmd wincmd p
	redraw!

	echohl Comment | echon '$ '. a:shell_command[0:winwidth(0)-11] . '...' | echohl None
endfun

fun! g:P_GetSelection()
	let [row1, col1] = getpos("'<")[1:2]
	let [row2, col2] = getpos("'>")[1:2]
	let lines = getline(row1, row2)
	if len(lines) == 0
		return []
	endif
	let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]
	return lines
endfun

fun! g:P_RunArray(sqlarray, timing)
	if len(a:sqlarray) == 0
		echohl Error | echon 'Nothing Selected' | echohl None
		return
	endif
	if a:timing
		let l:thesql = a:sqlarray
	else
		let l:thesql = a:sqlarray
	endif
	call writefile(l:thesql, '/tmp/vim-psql-plugin.sql')
	let l:Command = s:P_GetCommand() . ' < /tmp/vim-psql-plugin.sql'
	call g:P_RunShellCommand(l:Command)
endf

fun! g:P_RunSelection()
	let l:Selection = g:P_GetSelection()
	call g:P_RunArray(l:Selection, 1)
endfun


func! g:P_SelectCursorTable()
	let l:Table = expand('<cword>')
	call P_RunArray(['SELECT * FROM `' . l:Table . '` LIMIT 100' . g:vim_psql_plugin_sqleof], 0)
endfun

func! g:P_DescriptCursorTable()
	let l:Table = expand('<cword>')
	call P_RunArray(['select column_name, data_type, character_maximum_length, column_default, is_nullable from INFORMATION_SCHEMA.COLUMNS where table_name = ' . shellescape(l:Table) . g:vim_psql_plugin_sqleof], 0)
endfun

fun! s:P_GetInstruction()
	let l:p = ';'
	let l:PrevSemicolon = search(l:p, 'bnW')
	let l:NextSemicolon = search(l:p, 'cnW')
	let out = getline(l:PrevSemicolon, l:NextSemicolon)[1:]
	return out
endfun

fun! g:P_RunInstruction()
	let l:Lines = s:P_GetInstruction()
	call g:P_RunArray(l:Lines, 1)
endfun

fun! g:P_RunExplain()
	let l:Lines = s:P_GetInstruction()
	call g:P_RunArray(['explain '] + l:Lines, 1)
endfun

fun! g:P_RunExplainSelection()
	let l:Selection = g:P_GetSelection()
	call g:RunArray(['explain '] + l:Selection, 1)
endfun

fun! s:P_GetCommand()
	let l:Command = 'psql '
	let l:LineNum = 1
	let l:Line = getline(l:LineNum)
	while l:Line != '--'
		let l:arg = substitute(l:Line, '^--\s*\(\-.*\) \(.*\)$', '\1'.shellescape('\2'), 'g')
		let l:arg = substitute(l:arg, '^--\s*\(\-.*\)\s*$', '\1', 'g')
		let l:Command .= l:arg . ' '
		let l:LineNum = l:LineNum + 1
		let l:Line = getline(l:LineNum)
	endwhile
	return l:Command
endfun

autocmd BufRead,BufNewFile *.psql set filetype=psql
autocmd FileType psql setlocal syntax=sql

autocmd FileType psql nnoremap <silent><buffer> <leader>rr :call g:P_RunInstruction()<CR>
autocmd FileType psql nnoremap <silent><buffer> <leader>ss :call g:P_SelectCursorTable()<CR>
autocmd FileType psql nnoremap <silent><buffer> <leader>ds :call g:P_DescriptCursorTable()<CR>
autocmd FileType psql nnoremap <silent><buffer> <leader>rs :call g:P_RunSelection()<CR>
autocmd FileType psql vnoremap <silent><buffer> <leader>rs :<C-U>call g:P_RunSelection()<CR>
autocmd FileType psql nnoremap <silent><buffer> <leader>re :call g:P_RunExplain()<CR>
autocmd FileType psql vnoremap <silent><buffer> <leader>re :call g:P_RunExplainSelection()<CR>
