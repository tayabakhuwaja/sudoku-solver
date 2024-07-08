include irvine32.inc
include Macros.inc
isPresentIncol proto, colic:dword,numic:dword
isPresentInRow  proto, rowir:dword,numir:dword
isPresentInBox proto boxStartRow:Dword,boxStartCol:Dword,numbox:Dword
isValidPlace PROTO,
rowval :dword,
colval :dword,
numval :dword
.data
grid Dword 0, 5, 0, 3, 0, 0, 0, 8, 0
	 Dword 7, 0, 0, 0, 0, 6, 0, 0, 0
	 Dword 0, 0, 0, 0, 0, 0, 0, 2, 0
	 Dword 0, 8, 0, 0, 4, 0, 0, 5, 0
	 Dword 0, 0, 0, 0, 0, 9, 6, 0, 0
     Dword 0, 0, 0, 0, 0, 0, 0, 0, 0
     Dword 9, 0, 6, 0, 0, 0, 7, 0, 0
     Dword 0, 0, 0, 8, 2, 0, 0, 0, 0
     Dword 0, 0, 0, 0, 0, 0, 1, 0, 0
coloumn = 9	
prompt byte "no solution exist for this",0
row dword 1
col dword 0
num dword 0
asize dword 4
rowprint dword 0
colprint dword 0
modrow dword ? ; row- row%3
modcol dword ? ; col - col%3
v byte " ",0
direct dword 36 ; equivalent to 9*4 
rowic dword 0 ; row variable in ispresentincol
colir dword 0 ; col variable in ispresentinrow
rowib dword 0 ; row variable in ispresentinbox 
colib dword 0 ; col variable in ispresentinbox
rowcount dword 0 ; empty function
colcount dword 0 ; empty function
one_value dword ?
two_value dword ?
three_value dword ?
col_temp dword ? ; to store col*asize
row_temp dword ? ; to store row*asize
.code
main proc

mov eax, (black+(cyan))
call settextcolor
Mwrite "This is your intial grid"
call crlf
call sodukogrid
call crlf
Mwrite "This is your Final grid"
call crlf
call solvesoduko
cmp eax, 1
je griddy
;mov edx, offset prompt
;call writestring
exit
griddy:
	call sodukogrid
exit
main endp

isPresentIncol proc colic:dword,numic:dword
mov eax, 0
mov rowic, eax
mov ecx,coloumn
mov edx,0
mov eax,colic
mul asize
mov colic,eax
L1:
	
	mov ebx,offset grid	 ;Address of table
	mov edx,0			 ;For multiplication
	mov eax,coloumn		 ; 
	mul rowic
	add ebx,eax
	mov esi,colic
	mov eax,[ebx+esi]
	cmp eax,numic
	jne L2
	mov eax,1
	ret
	L2:
		add rowic, 4
	Loop L1
mov eax,0
ret
isPresentIncol endp

isPresentInRow  proc rowir:dword,numir:dword
mov eax, 0
mov colir, eax
mov ecx,coloumn
mov edx,0
	mov eax,rowir
	mul asize
	mov rowir,eax
L1:
	
	
	mov ebx,offset grid	 ;Address of table
	mov edx,0			 ;For multiplication
	mov eax,coloumn		 ; 
	mul rowir
	add ebx,eax
	mov esi,colir
	mov eax,[ebx+esi]
	cmp eax,numir
	jne L2
	mov eax,1
	ret
	L2:
		add colir, 4
	Loop L1
mov eax,0
ret
isPresentInRow  endp


isPresentInBox proc, boxStartRow:Dword,boxStartCol:Dword,numbox:Dword
mov edx,0
mov eax,boxStartRow
mul direct
mov boxStartRow,eax

mov edx,0
mov eax,boxStartCol
mul asize
mov boxStartCol,eax

mov eax, 0
mov rowib, eax

mov ebx,offset grid	 ;Address of table
mov edx,0			 ;For multiplication
mov eax,coloumn		 ; 
mul rowib
add ebx,eax
mov ecx,3
L1:
	push ecx
	mov eax, 0
	mov colib, eax
	mov esi,colib
	mov ecx,3
	add ebx,boxStartRow
	add esi,boxStartCol
	L2:
		mov eax,[ebx+esi]
		add esi,4
		cmp eax,numbox
		jne L3
		mov eax,1
		pop ecx
		ret 
		L3:
		Loop L2
	
	pop ecx
	add rowib,4
	mov ebx,offset grid	 ;Address of table
	mov edx,0			 ;For multiplication
	mov eax,coloumn		 ; 
	mul rowib
add ebx,eax
Loop L1
mov eax,0
L4:
ret
isPresentInBox endp

findEmptyPlace proc

mov eax, 0
mov rowcount, eax
mov row, eax
mov ebx,offset grid	 ;Address of table
mov edx,0			 ;For multiplication
mov eax,COLOUMN		 ; 
mul row
add ebx,eax
mov ecx,9
L1:
	push ecx
	mov eax, 0
	mov colcount, eax
	mov eax, 0
	mov col, eax
	mov esi,col
	mov ecx,9
	L2:
		mov eax,[ebx+esi]
		add esi,4
		cmp eax, 0
		jne order
		mov eax, rowcount
		mov row, eax
		mov eax, colcount
		mov col , eax
		pop ecx
		mov eax, 1
		ret
		order:
		inc colcount
		Loop L2
	pop ecx
	add row,4
	mov ebx,offset grid	 ;Address of table
	mov edx,0			 ;For multiplication
	mov eax,COLOUMN		 ; 
	mul row
add ebx,eax
inc rowcount
Loop L1
mov eax, 0
ret
findEmptyPlace endp

isValidPlace proc, rowval :dword, colval :dword, numval :dword

mov eax, rowval
mov ebx, 3
mov edx,0
div ebx ; edx is now remainder
mov eax, rowval ; cant transfer from variable to variable
mov modrow, eax
sub modrow, edx ; row- row%3
mov eax, colval
mov ebx, 3
mov edx,0
div ebx ; edx is now remainder
mov eax, colval
mov modcol, eax
sub modcol, edx ; col- col%3

invoke isPresentInRow, rowval, numval
cmp eax,0
je switch
mov eax, 0
jmp nextfun
switch:
mov eax, 1
nextfun:
mov one_value, eax ; one value
invoke isPresentInCol, colval, numval
cmp eax,0
je switch1
mov eax, 0
jmp nextfun1
switch1:
mov eax, 1
nextfun1:
mov two_value, eax ; 2nd value
invoke isPresentInBox, modrow, modcol, numval
cmp eax,0
je switch2
mov eax, 0
jmp nextfun2
switch2:
mov eax, 1
nextfun2:
mov three_value, eax ; 3rd value
; now edx && ecx && ebx
mov ebx, one_value
mov ecx, two_value
mov edx, three_value
cmp edx, 1
je one
mov eax, 0
jmp _end
one:
	cmp ebx,1
	je two
	mov eax, 0
	jmp _end
	two:
		cmp ecx,1
		je three
		mov eax, 0
		jmp _end
		three:
		mov eax, 1

_end:
	ret ; return the value of eax 
	; if eax =1 then true 
	; eax =0 then consider false
isValidPlace endp

solvesoduko proc ; local varaibles: row, col, num
	call findEmptyPlace ; it uses row and col
	cmp eax, 0
	je endtrue
	mov num, 1
	for1:
	cmp num,10
	jge endfalse
	invoke isValidPlace,  row, col ,num
	cmp eax, 0 ; not true
	je endfor1
	; if true then
	push num
	mov eax,col
	mul asize
	mov col_temp,eax

	mov eax,row
	mul asize
	mov row_temp,eax

	mov ebx,offset grid
	mov edx,0
	mov eax,coloumn
	mul row_temp
	add ebx,eax
	mov esi,col_temp
	pop [ebx+esi] ; grid[row][col]=num
	mov eax,[ebx+esi]
	;call writeint
	push num
	push col
	push row
	call solvesoduko
	cmp eax, 1 ; if(solvesoduko==true)
	je endtrue
	pop row
	pop col
	pop num
	mov eax, 0
	push eax
	mov eax,col
	mul asize
	mov col_temp,eax

	mov eax,row
	mul asize
	mov row_temp,eax

	mov ebx,offset grid
	mov edx,0
	mov eax,coloumn
	mul row_temp
	add ebx,eax
	mov esi,col_temp
	pop [ebx+esi] ; grid[row][col]=0 backtracking
	mov eax,[ebx+esi]
	;call writeint
	endfor1:
	inc num
	jmp for1

	endtrue:
	mov eax, 1
	call crlf
	call sodukogrid
	ret
	endfalse:
	mov eax, 0
	ret
solvesoduko endp


sodukogrid proc 
mov rowprint, 0
mov colprint, 0
mov ebx,offset grid	 ;Address of table
mov edx,0			 ;For multiplication
mov eax,COLOUMN		 ; 
mul rowprint
add ebx,eax
mov ecx,9
L1:
	push ecx
	mov esi,colprint
	mov ecx,9
	L2:
		mov eax,[ebx+esi]
		add esi,4
		call writedec
		mov edx,offset v
		call writestring
		Loop L2
		call crlf
	pop ecx
	add rowprint,4
	mov ebx,offset grid	 ;Address of table
	mov edx,0			 ;For multiplication
	mov eax,COLOUMN		 ; 
	mul rowprint
add ebx,eax
Loop L1

ret
sodukogrid endp

end main
