;org 0x7c00    ; where the code will be running
;    mov    ax, cs
;    mov    ds, ax
;    mov    es, ax
;    call    DispStr ; let's display a string
;    jmp    $ ; and loop forever
;DispStr:
;    mov    ax, BootMessage
;    mov    bp, ax    ; ES:BP = string address
;    mov    cx, 0x10    ; CX = string length
;    mov    ax, 0x1301    ; AH = 13, AL = 01h
;    mov    bx, 0x000c    ; RED/BLACK
;    mov    dl, 0
;    int    0x10
;    ret
;BootMessage: db    "Hello, OS-hacker!"
;times 510-($-$$) db    0    ; fill zeros to make it exactly 512 bytes
;dw 0xaa55    ; boot record signature

org 0x7c00         ; where the code will be running
    mov    ax, cs
    mov    ds, ax
    mov    es, ax
    call   msgprint ; let's display a string
    jmp    $        ; and loop forever
msgprint:
    mov    ax, BootMessage
    mov    bp, ax    ; ES:BP = string address
    mov    cx, 0x11     ; CX = string length
    mov    ax, 0x1301    ; AH = 13, AL = 01h
    mov    bx, 0x000c ; RED/BLACK
    mov    dl, 0
    int    0x10
    ret
BootMessage: db    "Hello, os-hacker!"
times 510-($-$$) db    0    ; fill zeros to make it exactly 512 bytes
dw 0xaa55    ; boot record signature
