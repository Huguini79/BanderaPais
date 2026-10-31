org 100h

global save_video_mode
global set_video_mode
global fill_screen
global step1
global step2
global red
global red_german
global yellow_german
global clean_screen
global next_flag
global exit

saved_mode:             db              0 ; nothing until we save the mode
saved_mode_default:     db              0x03 ; 80x25x3x16
my_mode:               db              0x13 ; 320x200x8bpp

; Initial startup
call save_video_mode

mov al, [my_mode] ; Move to "al" the video mode that we want (320x200x8bpp) 
call set_video_mode ; Now, when we execute this function, we have stored in "al", the mode that we want

; Ok, we have our enviroment ready to go | We are going to draw

jmp fill_screen

fill_screen:
        mov cx, 0
        mov di, 0
        mov ax, 0xA000
        mov es, ax
      
        jmp step1

step1:
        mov byte [es:di], 0x0C
        inc cx
        inc di
        cmp cx, 320*66
                je step2
        jne step1

step2:
        mov byte [es:di], 0x0E
        inc cx
        inc di
        cmp cx, 320*132
                je exit
        jne step2

save_video_mode:
        ; Parameters: none
        mov ah, 0xF
        int 0x10

        mov [saved_mode], al
        ret

set_video_mode:
        ; Parameters: al -> for int 0x10 (10h)
        mov ah, 0x00
        int 0x10
        ret

clean_screen:
        mov di, 0
        mov cx, 0
        mov ax, 0xA000
        mov es, ax
        jmp loop

loop:
        mov byte [es:di], 0x00
        inc di
        inc cx
        cmp cx, 320*200
                je red_german
        jne loop

exit:
         call red
red:
        mov byte [es:di], 0x0C
        inc cx
        inc di
        cmp cx, 320*198
                je next_flag
        jne red

red_german:
        mov cx, 0
        mov di, 320*66
        mov ax, 0xA000
        mov es, ax
        jmp red_german_loop

red_german_loop:
        mov byte [es:di], 0x0C
        inc di
        inc cx
        cmp cx, 320*66
                je yellow_german
        jne red_german_loop        

yellow_german:
        mov byte [es:di], 0x0E
        inc di
        inc cx
        cmp cx, 320*132
                je restore_default_video_mode
        jne yellow_german

next_flag:
        mov ah, 0x00
        int 0x16
        call clean_screen

restore_default_video_mode:
        mov ah, 0x00
        int 0x16
        mov al, [saved_mode_default]
        call set_video_mode
        
        mov ah, 4Ch
        int 21h

        ; Bye bye
