section .bss  ;section containing uninitialised data
Bufflen equ 1024  ;length of the buffer
Buff: resb Bufflen  ;Buffer itself

section .data   ;section containing initialised data

section .text  ;section containing code

    global _start

_start:

       nop  ;this keeps gdb happy
       
Read: 
     
     mov eax,3  ;specify sys_read call
     mov ebx,0  ;specify file descriptor 0=stdin
     mov ecx,Buff  ;passing address of the buffer
     mov edx,Bufflen  ;tell sys_read to read 1024 char
     
     int 80h  ;call sys_read kernal call
     
     mov esi,eax  ;storing eax in esi for safekeeping
     cmp eax,0  ;compairing value of eax with 0
     je Exit  ;jump if eax is 0
     
     mov ecx,esi  ;
     mov ebx,Buff  ;passing address of buffer
     dec ebx  ;Balancing eax for one byte off error
     
     
Scan:

     cmp byte [ebx+ecx],61h  ;compairing char with "a"
     jb Next  ;jump to next if it is in uppercase
     cmp byte [ebx+ecx],7ah  ;compairing char with "z"
     ja Next  ;jump to next if it is above ascii z
     sub byte [ebx+ecx],20h  ;converting lowercase to uppercase
     
     
Next:

     dec ecx  ;shifting the pointer to previous char
     jnz Scan  ;jump to scan if not 0
     
     
Write:

      mov eax,4  ;specify sys_write kernel call
      mov ebx,1  ;specify file descriptor 1=stdout
      mov ecx,Buff  ;passing the address of buff
      mov edx,esi  ;passing the number of char to write
      int 80h  ;calling sys_write
      jmp Read  ;jump to read
      
      
Exit:

     mov eax,1  ;specify sys_exit kernel call 
     mov ebx,0  ;return code of zero
     int 80h  ;call sys_exit
     
     
     
     
     
