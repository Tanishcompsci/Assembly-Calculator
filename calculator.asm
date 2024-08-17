%include "CPsub64.inc"
%include "Macros_CPsub64.inc"

Global main, runOperation

section .text

main:

	mov rdx, welcome
	call WriteString ;print welcome message
	
	mov rdx, messageO
	call WriteString ;request operation type
	
	mov rdx, userDataO
	mov rcx, 255
	call ReadString ;get input
	mov r15,rdx
	
	mov rdx, message
	call WriteString ;request first num
	
	; get input for first operand
	mov rdx, userData1
	mov rcx, 255
	call ReadString ;get input
	
	mov rdx,userData1; convert the input to number
	mov rcx,255
	call ParseInteger64
	mov r9, rax; mov value into r9
	
	mov rdx, message2
	call WriteString ;request second num
	
	mov rdx, userData2; get input for second operand
	mov rcx, 255
	call ReadString ;get input
	
	mov rdx,userData2; convert the input to number
	mov rcx,255
	call ParseInteger64
	mov r8, rax; mov value into r8

	call runOperation;call function
	
	jmp runAgain ;ask if user wants to run again
	
	
;section to ask if user wants to run main program again; if not, program ends
runAgain:
	mov rdx, messageAgain
	call WriteString
	
	; get input for user's choice
	mov rdx, askRun
	mov rcx, 255
	call ReadString
	
	; if choice is 'y'
	mov rsi, askRun
	mov rbx, 255
	mov rdx, [askRun]
	cmp rdx, 'y'
	je main
	
	;goodbye message and end program
	mov rdx, goodBye
	call WriteString
	Exit

;function to perform and print operations
runOperation:
	push rbp
	mov rbp, rsp ;point to top of stack
	
	push rbx ;save callee-saved register
	
	mov rbx, r9 ;move userData1 into rbx
	mov rax, rbx ;move rbx into rax to use writeint
	call WriteInt
	
	mov rdx, space ;print space
	call WriteString
	
	mov rdx, r15 ;print operation sign
	call WriteString
	
	mov rdx, space ;print space
	call WriteString
	
	mov rax, r8 ;move userData2 into rax and print
	call WriteInt
	
	mov rdx, equalSign
	call WriteString
	
	; if multiplication
	mov rsi, r15
	mov rcx, 255
	mov rdx, [r15]
	cmp rdx, '*'
	je multiplication
	
	; if division
	mov rsi, r15
	mov rcx, 255
	mov rdx, [r15]
	cmp rdx, '/'
	je division
	
	; if addition
	mov rsi, r15
	mov rcx, 255
	mov rdx, [r15]
	cmp rdx, '+'
	je addition
	
	; if subtraction
	mov rsi, r15
	mov rcx, 255
	mov rdx, [r15]
	cmp rdx, '-'
	je subtraction


;------------------------ operation cluster -----------------------------
	addition:
		add rax,rbx ;rax += rbx
		call WriteInt
		call Crlf
		
		;return
		jmp runAgain
		
	subtraction:
		sub rbx,rax ;rax -= rbx
		mov rax, rbx
		call WriteInt
		call Crlf
		
		;return
		jmp runAgain

	multiplication:
		mov rax,r8
		mov rdx,0
		mul r9
		mov r8,rax; product
		call WriteInt
		call Crlf
		
		;return
		jmp runAgain

	division:
		mov rax,r9
		mov rdx,0
		div r8
		mov r9,rax; quotient
		call WriteInt
		mov r15,rdx ; move remainder into r15
		
		; display remainder formating
		mov rdx,remainder
		call WriteString
		
		; display remainder
		mov rax, r15
		call WriteInt
		
		;return
		jmp runAgain
	

section .data
messageAgain: DB 0Ah,'Would you like to perform another operation? (y/n)',0Dh,0Ah,00h
welcome: DB 0Ah,'Hello, welcome to my assembly program!',0Dh,0Ah,00h
messageO: DB 0Ah, 'Enter the operation you would like to do: ',0Dh,0Ah,00h
addWelcome: DB 0Ah, 0Ah,'Addition I will do!',0Dh,0Ah,00h
subWelcome: DB 0Ah,0Ah,'Subtraction I will do!',0Dh,0Ah,00h
mulWelcome: DB 0Ah,'Multiplication I will do!',0Dh,0Ah,00h
divWelcome: DB 0Ah,'Division I will do!',0Dh,0Ah,00h
message: DB 0Ah,'Type first operand: ',0Dh,0Ah,00h		;message for requesting input
message2: DB 0Ah,'Type in second operand: ',0Dh,0Ah,00h		;message for requesting second input
goodBye: DB 0Ah,'Thanks for checking out my program!',0Dh,0Ah,00h
space: DB ' ', 00h
equalSign: DB ' = ',00h
remainder: DB ' r: ',00h

section .bss
userDataO: resb 255 ; variable for operation choice
userData1: resb 255	; first input variable
userData2: resb 255	; second input variable
askRun: resb 255
