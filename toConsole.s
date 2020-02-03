;----------------------------------------------------------------------------------
;-- (c) Rajesh Panicker
;--	License terms :
;--	You are free to use this code as long as you
;--		(i) DO NOT post it on any public repository;
;--		(ii) use it only for educational purposes;
;--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
;--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
;--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
;--		(vi) retain this notice in this file or any files derived from this.
;----------------------------------------------------------------------------------

	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 127 (126 excluding the last line 'halt B halt').

; This sample program prints "Welcome to CG3207" in response to "A\r" (A+Enter) received from Console. 
; There should be sufficient time gap between the press of 'A' and '\r'
		LDR R6, ZERO	; R6 stores the constant 0, which we need frequently as we do not have MOV 
						; implemented. Hence, something like MOV R1, #4 is accomplished by ADD R1, R6, #4
		LDR R7, LSB_MASK ; A mask for extracting out the LSB to check for '\0'
		LDR R8, CONSOLE_OUT_ready	; UART ready for output flag
		LDR R9, CONSOLE_IN_valid	; UART new data flag
		LDR R10, CONSOLE		; UART
		LDR R11, SEVENSEG
		LDR R12, LEDS
		ADD R2, R6, #2
		ADD R2, #"0"
		STR R2, [R11]
; WAIT_A	
		; LDR R3, [R9]	; read the new character flag
		; CMP R3, #0 		; check if there is a new character
		; BEQ	WAIT_A		; go back and wait if there is no new character
		; LDR R3, [R10]	; read UART (first character. 'A' - 0x41 expected)
		

WAIT_OP1
		ADD R2, R6, #3
		ADD R2, #"0"
		STR R2, [R11]
		LDR R3, [R9]	
		CMP R3, #0 		
		BEQ	WAIT_OP1		
		LDR R3, [R10]
		CMP R3, #'0'
		BLT WAIT_OP1
		CMP R3, #'9'
		BGT WAIT_OP1
		SUB R3, #'0'
WAIT_SPACE
		ADD R2, R6, #4
		ADD R2, #"0"
		STR R2, [R11]
		LDR R4, [R9]
		CMP R4, #0
		BEQ WAIT_SPACE
		LDR R4, [R10]
		CMP R4, #' '
		BNE WAIT_SPACE
WAIT_OP2
		ADD R2, R6, #5
		ADD R2, #"0"
		STR R2, [R11]
		LDR R4, [R9]
		CMP R4, #0
		BEQ WAIT_OP2
		LDR R4, [R10]
		CMP R4, #'0'
		BLT WAIT_OP2
		CMP R4, #'9'
		BGT WAIT_OP2
		SUB R4, R4, #'0'
WAIT_COM
		ADD R2, R6, #6
		ADD R2, #"0"
		STR R2, [R11]
		LDR R2, [R9]
		CMP R2, #0
		BEQ WAIT_COM
		LDR R2, [R10]
		CMP R2, #'A'
		BEQ DO_AND
		CMP R2, #'B'
		BEQ DO_EOR
		CMP R2, #'C'
		BEQ DO_SUB
		CMP R2, #'D'
		BEQ DO_RSB
		CMP R2, #'E'
		BEQ DO_ADD
		CMP R2, #'F'
		BEQ DO_ADC
		CMP R2, #'G'
		BEQ DO_SBC
		CMP R2, #'H'
		BEQ DO_RSC
		CMP R2, #'I'
		BEQ DO_TST
		CMP R2, #'J'
		BEQ DO_TEQ
		CMP R2, #'K'
		BEQ DO_CMP
		CMP R2, #'L'
		BEQ DO_CMN
		CMP R2, #'M'
		BEQ DO_ORR
		CMP R2, #'N'
		BEQ DO_MOV
		CMP R2, #'O'
		BEQ DO_BIC
		CMP R2, #'P'
		BEQ DO_MVN
		; CMP R2, #'Q'
		; BEQ GEN_CARRY
		; CMP R2, #'R'
		; BEQ CLEAR_CARRY
		B WAIT_COM		
DO_AND
		AND R5, R3, R4
		B   ECHO_RES
DO_EOR
		EOR R5, R3, R4
		B   ECHO_RES
DO_SUB
		SUB R5, R3, R4
		B   ECHO_RES
DO_RSB
		RSB R5, R3, R4
		B   ECHO_RES
DO_ADD
		ADD R5, R3, R4
		B   ECHO_RES
DO_ADC
		ADC R5, R3, R4
		B   ECHO_RES
DO_SBC
		SBC R5, R3, R4
		B   ECHO_RES
DO_RSC
		RSC R5, R3, R4
		B   ECHO_RES
DO_TST
		TST R3, R4
		B   WAIT_OP1
DO_TEQ
		TEQ R3, R4
		B   WAIT_OP1
DO_CMP
		CMP R3, R4
		B   WAIT_OP1
DO_CMN
		CMN R3, R4
		B   WAIT_OP1
DO_ORR
		ORR R5, R3, R4
		B   ECHO_RES
DO_MOV
		MOV R5, R3
		B   ECHO_RES
DO_BIC
		BIC R5, R3, R4
		B   ECHO_RES
DO_MVN
		MVN R5, R3
		B   ECHO_RES
; DO_MUL
		; MUL R5, R3, R4
		; ADD R5, R5, #'0'
		; B   ECHO_RES
; DO_DIV
		; MLA R5, R3, R4, R4
		; ADD R5, R5, #'0'
		; B   ECHO_RES
; GEN_CARRY
		; ADDS R5, R7, #0xFFFFFFFF
		; B   ECHO_RES
; CLEAR_CARRY
		; ADDS R5, R6, R6
		; B   ECHO_RES

ECHO_RES
		ADD R2, R6, #7
		ADD R2, #"0"
		STR R2, [R11]
		ADD R5, R5, #'0'
		LDR R2, [R8]
		CMP R4, #0
		BEQ ECHO_RES
		STR R5, [R10]
		B   WAIT_OP1
		
		
; ECHO_A
		; LDR R4, [R8]
		; CMP R4, #0
		; BEQ ECHO_A
		; STR R3, [R10]	; echo received character to the console
		; STR R3, [R11]	; show received character (ASCII) on the 7-Seg display
		; CMP R3, #'A'
		; BNE WAIT_A		; not 'A'. Continue waiting
; WAIT_CR					; 'A' received. Need to wait for '\r' (Carriage Return - CR).
		; LDR R3, [R9]	; read the new character flag
		; CMP R3, #0 		; check if there is a new character
		; BEQ	WAIT_CR		; go back and wait if there is no new character
		; LDR R3, [R10] 	; read UART (second character. '\r' expected)
; ECHO_CR
		; LDR R4, [R8]
		; CMP R4, #0
		; BEQ ECHO_CR
		; STR R3, [R10]	; echo received character to the console
		; STR R3, [R11]	; show received character (ASCII) on the 7-Seg display
		; CMP R3, #'A'	; perhaps the user is trying again before completing 
						; ; the pervious attempt, or 'A' was repeated. Just a '\r' needed as we already got an 'A'
		; BEQ WAIT_CR		; wait for '\r' 
		; CMP R3, #'\r'	; Check if the second character is '\r'
		; LDR R0, stringptr	; R0 stores the value to be displayed. This is the argument passed to PRINT_S
		; ADD R14, R15, #0 ; Storing the return value manually since we do not have BL
		; BEQ PRINT_S		; "A\r" received. Call PRINT_S subroutine
		; B WAIT_A		; not the correct pattern. try again.
		
; ; P the null-terminated string at a location pointed to be R0 onto the console.
; ; It is a good idea to 'push' the registers used by this function to the 'stack'.
; ; A stack can be simulated by using R13 as a stack pointer. Loading and storing 
; ; should be accompanied by manually decrementing/incrementing R13. Only one value 
; ; can be 'push'ed or 'pop'ed at a time.
; PRINT_S					
		; LDR R1, [R0]	; load the word (4 characters) to be displayed
		; ;STR	R1, [R11]	; write to seven segment display
		; ADD R3, R6, #4	; byte counter
; NEXTCHAR
		; LDR R4, [R8]	; check if CONSOLE is ready to send a new character
		; CMP R4, #0
		; BEQ NEXTCHAR	; not ready, continue waiting
		; ANDS R2, R1, R7 ; apply LSB_MASK
		; BEQ DONE_PRINT_S ; null terminator ('\0') detected
		; STR	R1, [R10]	; write to UART the Byte[4-R3] of the original word (composed of 4 characters) 
						; ; in [7:0] of the word to be written (remember, we can only write words, and 
						; ; LEDs/UART displays only [7:0] of the written word)
		; ;STR	R1, [R12]	; write to LEDS
		; ADD R1, R6, R1, LSR #8 ; shift so that the next character comes into LSB
		; SUBS R3, #1
		; BNE NEXTCHAR	; check and print the next character
		; ADD R0, #4	; point to next word (4 characters)
		; B PRINT_S
; DONE_PRINT_S
		; ADD R15, R14, #0 ; return from the subroutine
; halt	
		; B    halt           ; infinite loop to halt computation. // A program should not "terminate" without an operating system to return control to
							; ; keep halt	B halt as the last line of your code.
; misc
		; LDR  R1, LEDS       ; R0 stores total
		; LDR  R2, DIPS
		; LDR  R3, DELAY_VAL
		; LDR  R4, [R2]
		; STR  R4, [R1]
		; ADD  R6, R4, #5
		; MUL  R7, R6, R3
		; ADD  R6, R7
		
		; ; Start of custom instructions
		; EOR  R7, R3, #0x00000000 
		; RSB  R7, R7, #0x0000000F
		; ADDS R7, R7, #0xFFFFFFFF ; generate carry ; implemented
		; ADC  R7, R7 ; add with carry
		; SBC  R7, #0x1 ; subtract with carry
		; RSC  R7, R3, #0xF ; reverse subtract with carry
		; ADDS R7, R7, #1 ; reset carry to 0 ; implemented
		; TST  R7, #0 ; set Z=1
		; TEQ  R7, #0x0000000FF ; set N=1, Z=0
		; ADDS R7, R7, #1 ; implemented
		; MOV  R7, #0xF
		; BIC  R7, R7, #0xFFFFFFFF
		; MVN  R7, #0xFFFFFFFE
; ------- <\code memory (ROM mapped to Instruction Memory) ends>


	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; All constants should be declared in this section. This section is read only (Only LDR, no STR).
; Total number of constants should not exceed 128 (124 excluding the 4 used for peripheral pointers).
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than load it repeatedly.

;Peripheral pointers
LEDS
		DCD 0x00000C00		; Address of LEDs. //volatile unsigned int * const LEDS = (unsigned int*)0x00000C00;  
DIPS
		DCD 0x00000C04		; Address of DIP switches. //volatile unsigned int * const DIPS = (unsigned int*)0x00000C04;
PBS
		DCD 0x00000C08		; Address of Push Buttons. Used only in Lab 2
CONSOLE
		DCD 0x00000C0C		; Address of UART. Used only in Lab 2 and later
CONSOLE_IN_valid
		DCD 0x00000C10		; Address of UART. Used only in Lab 2 and later
CONSOLE_OUT_ready
		DCD 0x00000C14		; Address of UART. Used only in Lab 2 and later
SEVENSEG
		DCD 0x00000C18		; Address of 7-Segment LEDs. Used only in Lab 2 and later

; Rest of the constants should be declared below.
ZERO
		DCD 0x00000000		; constant 0
LSB_MASK
		DCD 0x000000FF		; constant 0xFF
DELAY_VAL
		DCD 0x00000002		; delay time.
variable1_addr
		DCD variable1		; address of variable1. Required since we are avoiding pseudo-instructions // unsigned int * const variable1_addr = &variable1;
constant1
		DCD 0xABCD1234		; // const unsigned int constant1 = 0xABCD1234;
string1   
		DCB  "\r\nWelcome to CG3207..\r\n",0	; // unsigned char string1[] = "Hello World!"; // assembler will issue a warning if the string size is not a multiple of 4, but the warning is safe to ignore
stringptr
		DCD string1			;
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared in this section. This section is read-write.
; Total number of variables should not exceed 128. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it (i.e., write to a location using STR before reading using LDR).

variable1
		DCD 0x00000000		;  // unsigned int variable1;
; ------- <variable memory (RAM mapped to Data Memory) ends>	

		END	
		
;const int* x;         // x is a non-constant pointer to constant data
;int const* x;         // x is a non-constant pointer to constant data 
;int*const x;          // x is a constant pointer to non-constant data
		