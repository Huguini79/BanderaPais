org 100h

global save_video_mode
global set_video_mode
global fill_screen
global step1
global step2
global red
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

exit:
         call red
 ;        mov ah, 0x00
  ;       int 0x16
;        cmp ah, 0x01
;        jmp restore_default_video_mode

;        mov al, [saved_mode]
 ;       call set_video_mode

;        mov ah, 4Ch
 ;       int 21h

red:
        mov byte [es:di], 0x0C
        inc cx
        inc di
        cmp cx, 320*198
                je restore_default_video_mode
        jne red

restore_default_video_mode:
        mov ah, 0x00
        int 0x16
        mov al, [saved_mode_default]
        call set_video_mode
        
        mov ah, 4Ch
        int 21h

        ; Bye bye
