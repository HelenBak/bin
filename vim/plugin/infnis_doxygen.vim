"$HOME/.vim/plugin 에 복사

if exists("infnis_doxygen")
  finish
endif
let infnis_doxygen = 1

" 함수 설명 추가
let g:Dox_cr            ="\<cr>"
let g:Dox_hdr           ="/* -------------------------------- */"
let g:Dox_classTag      ="* \\class       "
let g:Dox_fileTag       ="* \\file        "
let g:Dox_briefTag      ="* \\brief       "
let g:Dox_paramTag      ="* \\param       "
let g:Dox_returnTag     ="* \\return      "
let g:Dox_blockHeader   ="/*!"
let g:Dox_blockFooter   ="*/"
let g:Dox_NoteTag       ="* \\note        "
let g:Dox_IngroupTag    ="* \\ingroup     "
let g:Dox_ExcepTag      ="* \\exception   "
let g:Dox_err_msg       ="* \\warning     "
let g:Dox_CurrentDate 	= 1
"------------------------------------------------------------------------
"
if !exists("g:Dox_CurrentDate")
    let g:Dox_CurrentDate=0
endif

if g:Dox_CurrentDate != 0
    let date = strftime("%Y.%m.%d")
    let g:Dox_dateTag="* \\date        ". date
else
    let g:Dox_dateTag="* \\date        "
endif

if hostname() == "racoon"
    let g:Dox_Author 		= system("id -P | awk -F':' '{print $8}'")
else
    let g:Dox_Author 		= "자신의 이름을 넣으세요!!!"
endif

if exists("g:Dox_Author")
    if g:Dox_Author != "DevUser"
        let g:Dox_authorTag="* \\author      ". g:Dox_Author
    else
        let g:Dox_authorTag="* \\author      chpass로 \"Full Name\" 변경하세요!!"
    endif
else
    let g:Dox_authorTag="* \\author      "
endif

" 소스 파일 문서화 
" c,cpp 이외의 언어에 대한 고려 필요
function PrintDoxygen(desc)
    let l:index = 0
    let l:total = len(a:desc) - 1

    if (l:total < 2)
        return
    endif

    while (l:index < l:total)
        if (l:index == 0)
	        exec "normal O".a:desc[l:index]
        else
            exec "normal o".a:desc[l:index]
        endif
        let l:index = l:index + 1
    endwhile
	exec "normal a". a:desc[l:index].g:Dox_cr
endfunction

function PrintDoxygen2(desc)
    let l:index = 0
    exec "normal {"
	exec "normal O".a:desc[0]
    for str in a:desc
        if l:index == 0
            let l:index = l:index + 1
            continue
        endif
	    exec "normal o".str
    endfor
endfunction

function PrintDesc(desc)
	exec "set nocindent"
	exec "normal a" .g:Dox_hdr .g:Dox_cr .a:desc .g:Dox_cr .g:Dox_hdr .g:Dox_cr .g:Dox_cr
	exec "set cindent"
endfunction

" exclude tag 삽입
function InsertExcludeTag()
	let cond  ="#ifndef DOXYGEN_SHOULD_SKIP_THIS" .g:Dox_cr
    let ccond ="/* code that must be skipped by Doxygen */".g:Dox_cr
	let econd ="#endif /* DOXYGEN_SHOULD_SKIP_THIS */"

	exec "set nocindent"
	exec "normal o" .cond .ccond .econd
	exec "set cindent"
endfunction


function InsertFileDesc()
    let desc = []
    let file_name=expand("%")

    call add(desc, g:Dox_blockHeader)
    call add(desc, g:Dox_fileTag.file_name)
    call add(desc, g:Dox_briefTag."파일 설명을 적어 주세요")
    call add(desc, g:Dox_authorTag)
    call add(desc, g:Dox_blockFooter)

    call PrintDoxygen(desc)
endfunction

function! MakeDoxygenComment2()
    while (l:matchIndex >= 0)
        exec "normal " . (l:matchIndex + 1) . "|"
        let l:param=expand("<cword>")
        if (l:param != "void")
            call add(desc, g:Dox_paramTag . l:param . " ")
        endif
        exec "normal `d"
        let l:startPos=(l:matchIndex+strlen(l:param)+1)
        let l:matchIndex=match(l:line,identifierRegex,l:startPos)
        let l:synopsisLine=l:synopsisLine + 1
    endwhile
endfunction

function! InsertClassDesc()
    mark c
    let desc = []
    call add(desc, g:Dox_blockHeader)

    let l:synopsisLine=line(".")
    let l:synopsisCol=col(".")
    let l:nextParamLine=l:synopsisLine+1

    exec "normal `c"
    let l:line=getline(line("."))
    let l:startPos=match(l:line, "class")
    let l:identifierRegex='[\s\[\]]*[:\{]'

    let l:matchIndex=match(l:line,identifierRegex,l:startPos)
    if (l:matchIndex >= 0)
        exec "normal " . (l:matchIndex - 1) . "|"
        let l:class=expand("<cword>")
        call add(desc, g:Dox_classTag . l:class)
    endif

    call add(desc, g:Dox_briefTag."클래스 설명을 적어 주세요")
    call add(desc, g:Dox_authorTag)
    call add(desc, g:Dox_blockFooter)

    exec "normal {"
    call PrintDoxygen(desc)
    exec l:synopsisLine+1
    exec "normal " . l:synopsisCol . "|"
	exec "set cindent"
    startinsert!
endfunction

function! InsertFunctionDesc()
    mark d
    let desc = []
    call add(desc, g:Dox_blockHeader)
    call add(desc, g:Dox_IngroupTag)
    call add(desc, g:Dox_briefTag)

    let l:synopsisLine=line(".")
    let l:synopsisCol=col(".")
    let l:nextParamLine=l:synopsisLine+1

    exec "normal `d"
    let l:line=getline(line("."))
    let l:startPos=match(l:line, "(")
    let l:identifierRegex='\i\+[\s\[\]]*[,)]'
    let l:endPos = -1

    while (l:endPos == -1)
        let l:matchIndex=match(l:line,identifierRegex,l:startPos)
        let l:endPos=match(l:line, ")")
        while (l:matchIndex >= 0)
            exec "normal " . (l:matchIndex + 1) . "|"
            let l:param=expand("<cword>")
            if (l:param != "void")
                call add(desc, g:Dox_paramTag . l:param . " ")
            endif
            exec "normal `d"
            let l:startPos=(l:matchIndex+strlen(l:param)+1)
            let l:matchIndex=match(l:line,identifierRegex,l:startPos)
            let l:synopsisLine=l:synopsisLine + 1
        endwhile
        if (l:endPos != -1)
            break
        endif
        " 다음 줄로 이동
		exec l:nextParamLine
        delmarks d
        mark d
        let l:nextParamLine=l:nextParamLine+1
        let l:line=getline(line("."))
        let l:startPos=0
    endwhile
    delmarks d

    call add(desc, g:Dox_returnTag)
    call add(desc, g:Dox_err_msg)
    call add(desc, g:Dox_dateTag)
    call add(desc, g:Dox_authorTag)
    call add(desc, g:Dox_blockFooter)

    exec "normal {"
    call PrintDoxygen(desc)
    exec l:synopsisLine+1
    exec "normal " . l:synopsisCol . "|"
	exec "set cindent"
    startinsert!
endfunction

"-----------------------------
".vimrc에 추가해서 function key mapping한다.
map <F9>    :call InsertFunctionDesc()<CR>
map <F10> 	:call InsertFileDesc()<CR>
map <F11> 	:call InsertClassDesc()<CR>
map <F12> 	:call InsertExcludeTag()<CR>
