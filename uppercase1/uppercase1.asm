;Executable Name:uppercase1
;version:1.0
;Creation Date:16/9/18
;Last Update:16/9/18
;Authur:Mass
;Description: A simple filter program which turns the lowercase char into uppercase by one  
;              by one character
;Run it this way: uppercase1 > output file <input file
;Build using this command:
;                        nasm -f elf64 -g -F stabs uppercase1.asm
;                       ld -o uppercase1 uppercase1.o




section .bss  ;section containing uninitialised  data
 Buff resb 1;   ?????????????????????????
 
section .data ;section containing initailised data

section .text  ;section containing code

   global _start
   
_start:

       nop  ;for happiness of gdb
       
       
Read: 
       mov eax,3  ;specify sys_read call
       mov ebx,0  ;specify file descriptor 0=stdin
       mov ecx,Buff  ;pass the address of the buffer to read to 
       mov edx,1  ;tell sys_read to read one char
       
       int 80h  ;call sys_read
       
       cmp eax,0  ;checking sys_read's return value in eax
       je Exit  ; jump if eax return 0
       
       
Scan:  
       cmp byte [Buff],61h  ;compare the value stored in Buff with "a"
       jb write  ;jump if [Buff] is below "a"
       cmp byte [Buff],7ah  ;compare the value stored in Buff with "z"
       ja write  ;jump if [Buff] is above "z"
       sub byte [Buff],20h  ;converting char to upper case

write:  

       mov eax,4  ;specify sys_write call
       mov ebx,1  ;specify file descriptor 1=stdout
       mov ecx,Buff  ;pass the address of the buffer
       mov edx,1  ;tell sys_write to write 1 char
       
       int 80h  ;call sys_write
       jmp Read  ;jump back to Read lebel
       
       
Exit:  
       mov eax,1  ;specify sys_exit call 
       mov ebx,0  ;return a code of zero
       
       int 80h  ;call sys_exit 
       

       
