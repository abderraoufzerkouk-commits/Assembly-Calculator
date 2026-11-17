.model SMALL
.stack 100h

.data
    b equ 16
    h equ 4
    d equ 5
    first db 17 dup(0)
    second db 17 dup(0)
    rstr db 17 dup(0)
    string db "Calculator made by Abderaouf Zerkouk!$"
    choose db "Choose a base [(H)ex, (D)ec, (B)in]:$"
    fmsg db "Enter the first number: $"
    smsg db "Enter the second number: $"
    opmsg db "Choose operation [(A)dd, (S)ub, (M)ult, (D)iv]: $"
    zdiv db "You cannot divide by 0!$"
    outer db " + $"
    op dw 0
    opc db 0
    base db 0
    num1 dw 0
    num2 dw 0
    result dw 0
    read dw 0
    ten dw 0AH

.code
    mov ax, data
    mov ds, ax
    
    mov dx, offset string
    call puts
    call endl
    call endl
    
    ; Code for the selecting the numbers mode!
    
    b_choosing:
        mov dx, offset choose
        call puts
        call endl
        
        call getc
        
        cmp al, 'H'
        je hex
        
        cmp al, 'D'
        je deci
        
        cmp al, 'B'
        je bin
        
        call endl
        jmp b_choosing
    
    hex:
        mov base, 4
        jmp b_end
    deci: 
        mov base, 5
        jmp b_end
    bin:
        mov base, 16
        jmp b_end
        
    b_end:
        call endl
        call endl
        
    
    cmp base, 4
    jne nothex
    mov read, offset htoi
    nothex:
    cmp base, 16
    jne notbin
    mov read, offset btoi
    notbin:
    cmp base, 5
    jne notdec
    mov read, offset dtoi
    notdec:
    
    
    mov dx, offset fmsg
    call puts
    
    mov bh, 0
    mov bl, base
    mov si, offset first
    call gets
    call endl
    call endl
    
    mov dx, offset smsg
    call puts
    
    mov bh, 0
    mov bl, base
    mov si, offset second
    call gets
    call endl
    call endl 
    
    mov si, offset first
    call read
    
    mov num1, ax
    
    mov si, offset second
    call read
    
    mov num2, ax
    
    mov dx, offset opmsg
    call puts
    call endl 
    call endl
    
    call getc
    
    cmp al, 'A'
    jne notadd
    mov op, offset plus
    mov opc, '+'
    notadd:
    cmp al, 'S'
    jne notmoins
    mov op, offset moins 
    mov opc, '-'
    notmoins:
    cmp al, 'M'
    jne notmult
    mov op, offset mult
    mov opc, '*'
    notmult:
    cmp al, 'D'
    jne notdiv
    mov op, offset divi
    mov opc, '/'
    notdiv:
    
    mov ax, op
    
    mov ax, num1
    mov bx, num2
             
    call op
    mov result, ax
    
    call endl
    call endl
    
    
    mov dx, offset first
    call puts
    mov dx, offset outer
    mov bx, dx
    mov cl, opc
    mov [bx+1], cl
    call puts
    mov dx, offset second
    call puts
    mov dx, offset outer
    mov [bx+1], '='
    call puts
    
    decimal_base:
        cmp base, 5
        jne hex_base
        call itod
        mov dx, bx
        call puts
        jmp e
    hex_base:
        cmp base, 4
        jne bin_base
        call itoh
        mov dx, bx
        call puts
        jmp e
            
    bin_base:
        call itob
        mov dx, bx
        call puts
        jmp e
    e:
    
    
     
    
    hlt
    ; Read a character
    getc:
        mov ah, 01h
        int 21h
        ret
    ; Must initialize the SI register to the bit address
    ; Reads a string until linebreak and supports back spaces
    gets:
        push cx
        mov cx, 0
        s_start:
        call getc
        cmp al, 0Dh
        je stop
        cmp al, 08h
        je back
        mov ds:[si], al
        inc cx
        inc si
        cmp cx, bx
        je stop
        jmp s_start
        back:
            dec si
            dec cx
            mov dl, 00h
            call putc
            mov dl, 08h
            call putc
            jmp s_start
        stop:
            mov ds:[si], '$'
        pop cx
        ret
    ; A procedure to break line
    ; Prints a newline character then a carriage return
    endl:
        push ax
        mov ah, 02h
        mov dl, 0Ah ; 0Ah is \n
        int 21h
        mov ah, 02h
        mov dl, 0Dh ; 0Dh is \r
        int 21h
        pop ax
        ret
    ; Works by assigning a value to DX
    ; Displays a string
    puts:
        push ax
        mov ah, 09h
        int 21h
        pop ax
        ret
    ; Works by assigning a value to DL
    ; Displays a single character
    putc:
        mov ah, 02h
        int 21h
        ret
    ;Convert string to decimal
    dtoi:
        mov ax, 0
        mov bx, 0
        mov cx, 0
        mov dx, 0
        
        dtoil:
            cmp cx, 6
            je dtoic
            cmp [si], '$'
            je dtoic
            mov dl, [si]
            mov bx, ax
            shl ax, 2
            add ax, bx
            shl ax, 1
            sub dl, '0'
            add al, dl
            inc si
            inc cx
            jmp dtoil
        dtoic: 
            ret
    ; Convert string to binary.        
    btoi:
        mov ax, 0
        mov bx, 0
        mov cx, 0
        mov dx, 0
        btoil:
            cmp cx, 17
            je btoic
            cmp [si], '$'
            je btoic
            shl ax, 1
            mov dl, [si]
            sub dl, '0'
            add al, dl
            inc si
            inc cx
            jmp btoil
        btoic:
            ret
    ; Convert string to hex.        
    htoi:
        mov ax, 0
        mov bx, 0
        mov cx, 0
        mov dx, 0
        htoil:
            cmp cx, 5
            je htoic
            mov dl, [si]
            cmp [si], '$'
            je htoic
            shl ax, 4
            cmp [si], 'a'
            jae min_letter
            cmp [si], 'A'
            jae maj_letter
            cmp [si], '0'
            jae digit
            min_letter:
                sub dl, 'a'
                add dl, 10
                jmp res
            maj_letter:
                sub dl, 'A'
                add dl, 10
                jmp res
            digit:
                sub dl, '0'
                jmp res
            res:
            add al, dl
            inc si
            inc cx
            jmp htoil
        htoic:
            ret
    itob:
        mov ax, 16
        mov bx, offset rstr
        add bx, ax
        mov [bx], '$'
        dec ax
        mov cx, 0
        mov dx, result
        itobl:
            mov bx, offset rstr
            cmp dx, 0
            je itobc
            mov cx, dx
            and cl, 1
            add bx, ax
            mov [bx], '0'
            add [bx], cl
            dec ax
            shr dx, 1
            jmp itobl
        itobc:
            inc ax
            add bx, ax
            ret
    
    itoh:
        mov ax, 4
        mov bx, offset rstr
        add bx, ax
        mov [bx], '$'
        dec ax
        mov cx, 0
        mov dx, result
        itohl:
            mov bx, offset rstr
            cmp dx, 0
            je itohc
            mov cx, dx
            and cl, 0FH
            mov ch, 0
            add bx, ax
            cmp cl, 10
            jge letter
            mov [bx], '0'
            add [bx], cl
            jmp after
            letter:
            mov [bx], 'A'
            sub cl, 10
            add [bx], cl
            jmp after
            after:
            dec ax
            shr dx, 4
            jmp itohl
        itohc:
            inc ax
            add bx, ax
            ret
    itod:
        mov cx, 5
        mov bx, offset rstr
        add bx, cx
        mov [bx], '$'
        dec cx
        mov ax, result
        mov dx, 0
        mov si, 10
        itodl:
            mov bx, offset rstr
            add bx, cx
            cmp ax, 0
            je itodc
            cmp ax, 10
            jge next1
            mov [bx], '0'
            add [bx], ax
            dec cx
            jmp itodc
            next1:
            xor dx, dx
            div si
            mov [bx], '0'
            add [bx], dx
            dec cx
            jmp itodl
        itodc:
            mov bx, offset rstr
            inc cx
            add bx, cx
            ret
            
                       
    plus:
       add ax, bx
       ret
    
    moins:
        sub ax, bx
        ret
    mult:
        mul bx
        ret
    divi:
        mov dx, 0
        cmp bx, 0
        jne notzero
            call endl
            call endl
            mov dx, offset zdiv
            call puts
            call endl
            hlt
        notzero:
        div bx
        ret

