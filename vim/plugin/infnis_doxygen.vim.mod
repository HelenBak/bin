" 인프니스 연구소 내부에서 코딩시 소스 코드 문서화를 위한 vim macro
"$HOME/.vim/plugin 에 복사

if exists("infnis_doxygen")
  finish
endif
let infnis_doxygen = 1

" 함수 설명 추가
let g:Dox_cr            ="\<cr>"
let g:Dox_hdr           ="/* -------------------------------- */".g:Dox_cr
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
let g:Dox_Param 		= 1
"------------------------------------------------------------------------


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

function MakeDoxygenComment()
    mark y

	exec "set nocindent"
    exec "normal {"
	"exec "normal O" . g:Dox_blockHeader .g:Dox_cr .g:Dox_IngroupTag .g:Dox_cr .g:Dox_briefTag
	exec "normal O" . g:Dox_blockHeader
	exec "normal a" .g:Dox_cr .g:Dox_IngroupTag .g:Dox_cr .g:Dox_briefTag

    let l:synopsisLine=line(".")
    let l:synopsisCol=col(".")
    let l:nextParamLine=l:synopsisLine+1

    exec "normal `y"
    let l:line=getline(line("."))
    let l:startPos=match(l:line, "(")
    let l:identifierRegex='\i\+[\s\[\]]*[,)]'

	if g:Dox_Param != 0
    	"exec "normal a" .l:line
    	let l:matchIndex=match(l:line,identifierRegex,l:startPos)
	else
		let l:matchIndex = -1
	endif

   	"exec "normal a" .l:matchIndex
	if ( l:matchIndex < 0 )
		exec "normal 0" . g:Dox_returnTag
   	    exec "normal a" . "Hello"
	else
   	    exec "normal a" . l:matchIndex
		while (l:matchIndex >= 0)
			exec "normal " . (l:matchIndex + 1) . "|"
			let l:param=expand("<cword>")
			exec l:nextParamLine
			exec "normal 0" . g:Dox_paramTag . l:param . " "
			let l:nextParamLine=l:nextParamLine+1
			exec "normal `y"
			let l:startPos=(l:matchIndex+strlen(l:param)+1)
			let l:matchIndex=match(l:line,identifierRegex,l:startPos)
			let l:synopsisLine=l:synopsisLine + 1
		endwhile
		exec l:nextParamLine
		exec "normal 0" .g:Dox_returnTag
	endif
	exec "normal a" .g:Dox_cr .g:Dox_err_msg
	exec "normal a" .g:Dox_cr .g:Dox_dateTag
	exec "normal a" .g:Dox_cr .g:Dox_authorTag
	exec "normal a" .g:Dox_cr .g:Dox_blockFooter

    exec l:synopsisLine+1
    exec "normal " . l:synopsisCol . "|"
	exec "set cindent"
    startinsert!
endfunction


" exclude tag 삽입
function InsertExcludeTag()
	let cond  ="#ifndef DOXYGEN_SHOULD_SKIP_THIS" .g:Dox_cr
    let ccond ="/* code that must be skipped by Doxygen */".g:Dox_cr
	let econd ="#endif /* DOXYGEN_SHOULD_SKIP_THIS */" .g:Dox_cr

	exec "set nocindent"
	exec "normal a" .cond .ccond .econd
	exec "set cindent"
endfunction

function InsertPrototypeDesc()
	let desc  ="/*         Prototype 선언 영역      */" .g:Dox_cr
	let desc2 ="/* extern 함수는 doxygen에서 제외   */" .g:Dox_cr

	exec "set nocindent"
	exec "normal a" .g:Dox_hdr .desc .g:Dox_hdr .g:Dox_cr .desc2 .g:Dox_cr
    call InsertExcludeTag()
	exec "set cindent"
endfunction

function InsertGlobalDesc()
	let desc  ="/*         Global 변수 영역         */" .g:Dox_cr

	exec "normal a" .g:Dox_hdr .desc .g:Dox_hdr .g:Dox_cr
    call InsertExcludeTag()
	exec "set cindent"
endfunction

function InsertDefineDesc()
	let desc  ="/*         Define 영역              */" .g:Dox_cr

	exec "normal a" .g:Dox_hdr .desc .g:Dox_hdr .g:Dox_cr
    call InsertExcludeTag()
	exec "set cindent"
endfunction

function InsertFileInfo()
	let desc ="/*         파일 설명 영역           */" .g:Dox_cr

	exec "set nocindent"
	exec "normal a" .g:Dox_hdr .desc .g:Dox_hdr .g:Dox_cr
	exec "set cindent"
    "let abc=system("id -P")
    "let abc=system("id -P | awk -F':' '{print $8}'")
    "exec "normal a" .abc
endfunction

function InsertFileDesc()
    let file_name  = expand("%")
	let file  ="* \\file    "
	let brief ="* \\brief   파일 설명을 적어 주세요" .g:Dox_cr
    let author="* \\author  " .g:Dox_Author .g:Dox_cr

    call InsertFileInfo()
	exec "set nocindent"
	"exec "normal a" . g:Dox_blockHeader .g:Dox_cr . file .file_name .brief .author .g:Dox_blockFooter .g:Dox_cr
	exec "normal 0" .g:Dox_blockHeader .g:Dox_cr
    exec "normal a" .file .file_name .g:Dox_cr
    exec "normal a" .brief
    exec "normal a" .author
    exec "normal a" .g:Dox_blockFooter .g:Dox_cr
	exec "set cindent"
endfunction

function InsertCodeDesc()
	let desc_code ="/*         Code 영역                */" .g:Dox_cr

	exec "set nocindent"
	exec "normal a" .g:Dox_hdr .desc .g:Dox_hdr .g:Dox_cr
	exec "set cindent"
endfunction

" 소스 파일 문서화 
" c,cpp 이외의 언어에 대한 고려 필요
function InsertSourceFileDesc()
	" 파일 설명 영역
    call InsertFileDesc()
	"define 영역
    call InsertDefineDesc()
	" global variable
    call InsertGlobalDesc()
	" prototype
    call InsertPrototypeDesc()
	" code
    call InsertCodeDesc()
endfunction

" 헤더 파일 문서화
function InsertHeaderFileDesc()
	" 파일 설명 영역
    call InsertFileDesc()
	" prototype
    call InsertPrototypeDesc()
endfunction


"-----------------------------
".vimrc에 추가해서 function key mapping한다.
map <F9>    :call MakeDoxygenComment()<CR>
map <F10> 	:call InsertSourceFileDesc()<CR>
map <F11> 	:call InsertHeaderFileDesc()<CR>
map <F12> 	:call InsertExcludeTag()<CR>
