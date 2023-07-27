global long_mode_start
extern BMIK_MAIN

section .text
bits 64
long_mode_start:
    ; load null into all data segment registers
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

; if it works then how the hell?
mov dword [0xb8000], 0x2f4b2f4f

    ; wait for 2 seconds (loop executes ~1 billion times)
    mov ecx, 1000000000
.wait_loop:
    dec ecx
    jnz .wait_loop

    ; time for c func
	call BMIK_MAIN
    