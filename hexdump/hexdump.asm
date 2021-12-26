section .bss  ;section containing uninitialised data
Bufflen equ 16  ;length of the buffer is 16 byte
Buff resb Bufflen  ;text buffer itself


section .data  ;section containing initialised data
Hexstr: db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10  
Hexlen equ $-Hexstr

Digits: db"0123456789ABCDEF"

section .text  ;section containing code

global _start  ;linker need this to find the entry point

_start:

       nop  ;this is necessary for gdb
       
Read: 
     
     mov eax,3  ;specify sys_read call
     mov ebx,0  ;specify file descriptor 0=stdin 
     mov ecx,Buff  ;moving the offset of the buffer to read
     mov edx,Bufflen  ;passing the length of the buffer
     int 80h  ;call sys_read to fill the buffer
    mov esi,eax  ;copy the number of char read from the file to esi
     
     cmp eax,0  ;compare eax with 0 
     je Exit  ;jump to Exit if eax is zero
     
     mov edi,Buff  ;
    
     xor ecx,ecx  ;clear ecx to zero
     
     
Scan: 
     
     xor eax,eax  ;clear eax to zero
     mov edx,ecx  ;copy loop counter ecx to edx
     shl edx,1  ;multiply edx by two
     add edx,ecx  ;completes multiplication by 3
     
     mov al,byte [edi+ecx]  ;put byte of data from input buffer to eax
     mov ebx,eax  ;copy eax to ebx 
     and al,0Fh  ;masking out higher 4 bits
     mov al,byte [Digits+eax]  ;replace al byte with corresponding ascii byte
     mov byte [Hexstr+edx+2],al  ;write lsb char to Hexstr
     shr bl,4  ;cutting down last 4 bits by shr 4
     mov bl,byte [Digits+ebx]  ;replace al byte with corresponding ascii byte
     mov byte [Hexstr+edx+1],bl  ;write msb char to Hexstr
     inc ecx  ;increment the loop counter
     cmp ecx,esi  ;compare ecx with esi 
     jna Scan  ;jump to Scan if ecx is not above to esi
     
     
     
 

      mov eax,4  ;specify sys_write call 
      mov ebx,1  ;specify file descriptor 1=stdout
      mov ecx,Hexstr ;passing offset of buffer to ecx to write 
      mov edx,Hexlen  ;passing number of char to write
      int 80h  ;call sys_write call
      
      jmp Read  ;jump to Read
      
Exit: 
     
     
     mov eax,1  ;specify sys_exit call
     mov ebx,0  ;return code of zero 
     int 80h  ;call sys_exit 
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
