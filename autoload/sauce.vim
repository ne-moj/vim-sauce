"{{{ Private functions

" Create a new sauce file with the given name
function! sauce#SauceNew(name,skel)
	let names=sauce#SauceNames()
	if index(names,a:name) >= 0
		echohl Error | echo "A sauce with this name already exists" | echohl None
		return 0
	endif
	let fname = g:sauce_path.a:name.".".g:sauce_extension
	exec "silent e ".fname." | silent 0r ".a:skel
    return 1
endfunction

" Create a new sauce file with the given name
function! sauce#SauceCopy(name)
	let cfname = g:sauce_path.a:name.".".g:sauce_extension
	if filereadable(cfname)
        let l:ret = 0
        while l:ret == 0
            let l:name = input("Please enter a name for the new sauce: ")
            let l:ret = sauce#SauceNew(l:name,cfname)
        endwhile
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Create a new sauce file with the given name
function! sauce#SauceRename(name)
	let cfname = g:sauce_path.a:name.".".g:sauce_extension
	if filereadable(cfname)
        let l:ret = 1
        let l:name = input("Please enter a new name for the sauce: ")
        let l:ret = rename(cfname,g:sauce_path.l:name.".".g:sauce_extension)
        if l:ret == 0
          echohl Error | echo "Renamed sauce file ".a:name." to ".l:name | echohl None
        else
          echohl Error | echo "Failed to rename sauce file ".a:name | echohl None
        endif
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Edit a sauce file with the given name
function! sauce#SauceEdit(name)
	let fname = g:sauce_path.a:name.".".g:sauce_extension
	if filereadable(fname)
		exec "silent e ".fname
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Delete a sauce file with the given name
function! sauce#SauceDelete(name)
	let fname = g:sauce_path.a:name.".".g:sauce_extension
	if filereadable(fname)
		let response = confirm("Are you sure you want to delete the sauce '".a:name."'? ","&Yes\n&No",2)
		if response == 1
			let delret = delete(fname)
			if 0 == delret
				echohl Error | echo "Deleted sauce file: ".fname | echohl None
			else
				echohl Error | echo "Failed to delete sauce file: ".fname | echohl None
			endif
		else
			echom "Cancelled delete"
		endif
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction
"
" Delete a sauce file with the given name
function! sauce#SauceDelete(name)
	let fname = g:sauce_path.a:name.".".g:sauce_extension
	if filereadable(fname)
		let response = confirm("Are you sure you want to delete the sauce '".a:name."'? ","&Yes\n&No",2)
		if response == 1
			let delret = delete(fname)
			if 0 == delret
				echohl Error | echo "Deleted sauce file: ".fname | echohl None
			else
				echohl Error | echo "Failed to delete sauce file: ".fname | echohl None
			endif
		else
			echom "Cancelled delete"
		endif
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Get all sauces as a list
function! sauce#SauceNames()
    let l:sources = []
    if has("unix") || has("windows")
        if has("unix")
            let l:findop=system("find ".g:sauce_path." -name \"*.".g:sauce_extension."\" |awk -F/ '{print $NF}'")
        else
            let l:findop=system("powershell Get-ChildItem -Path ".g:sauce_path." -Filter \"*.".g:sauce_extension."\" -Name")
        endif
        let l:sourcefiles=split(l:findop,"\n")
        let l:sourcename = ""
        for fname in l:sourcefiles
            let l:sourcename = substitute(fname,".".g:sauce_extension,"","")
            call add(l:sources,l:sourcename)
        endfor
    endif
	return l:sources
endfunction

" Load a source file
function sauce#LoadSauce(source)
	let saucefile = g:sauce_path.a:source.".".g:sauce_extension
	if filereadable(saucefile)
		if 1 == g:sauce_output
			echo "Loading sauce file ".saucefile
		endif
		exec "source ".saucefile
	else
		echohl Error | echo "Invalid sauce file: ".saucefile | echohl None
	endif
endfunction
"}}}
