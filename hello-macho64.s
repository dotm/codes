;run from MacOSX cli with:
;nasm -f macho64 -o tmp-9236.o hello-macho64.s && ld -macosx_version_min 10.15.0 -lSystem -o tmp-9236 tmp-9236.o && ./tmp-9236 && rm tmp-9236*
;hello-macho64.s is the name of this file
;tmp-9236 is an arbitrary unique name

global _main

section .text
_main:
  mov rax, 0x2000004  ; write(
  mov rdi, 1          ;   STDOUT_FILENO,
  mov rsi, msg        ;   "Hello, world!\n",
  mov rdx, msg.len    ;   sizeof("Hello, world!\n")
  syscall             ; );

  mov rax, 0x2000001  ; exit(
  mov rdi, 0          ;   EXIT_SUCCESS
  syscall             ; );

section .data
msg:    db      "Hello, world!", 10   ;10 is \n
.len:   equ     $ - msg