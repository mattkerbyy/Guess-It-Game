section .data
    welcome_msg db 'Welcome to the "Guess It" Game!', 0xA, 0
    welcome_len equ $ - welcome_msg
    
    prompt_msg db 'I have chosen a number between 1 and 100. Can you "guess it"?', 0xA, 0
    prompt_len equ $ - prompt_msg
    
    lives_msg db 'You have 10 lives to guess the number!', 0xA, 0xA, 0
    lives_len equ $ - lives_msg
    
    input_msg db 'Enter your guess: ', 0
    input_len equ $ - input_msg
    
    too_high_msg db 'Too High! Try a smaller number.', 0xA, 0
    too_high_len equ $ - too_high_msg
    
    too_low_msg db 'Too Low! Try a larger number.', 0xA, 0
    too_low_len equ $ - too_low_msg
    
    correct_msg db 'Congratulations! You "guessed it" correctly!', 0xA, 0
    correct_len equ $ - correct_msg
    
    attempts_msg db 'Number of attempts: ', 0
    attempts_len equ $ - attempts_msg
    
    lives_left_msg db 'Lives remaining: ', 0
    lives_left_len equ $ - lives_left_msg
    
    game_over_msg db 'Game Over! You ran out of lives.', 0xA, 0
    game_over_len equ $ - game_over_msg
    
    answer_was_msg db 'The correct answer was: ', 0
    answer_was_len equ $ - answer_was_msg
    
    play_again_msg db 'Would you like to play again? (Y/N): ', 0
    play_again_len equ $ - play_again_msg
    
    thanks_msg db 'Thanks for playing! Goodbye!', 0xA, 0
    thanks_len equ $ - thanks_msg
    
    newline db 0xA, 0
    newline_len equ $ - newline

section .bss                    ; Uninitialized data
    user_input resb 10
    random_number resb 4
    user_guess resb 4
    attempt_count resb 4
    lives_count resb 4
    temp_buffer resb 10
    play_again_input resb 5

section .text
    global _start

_start:
    ; Main game loop
main_game_loop:
    ; Initialize game variables
    mov dword [attempt_count], 0
    mov dword [lives_count], 10
    
    call print_newline
    
    ; Display welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80
    
    ; Display prompt message
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 0x80
    
    ; Display lives message
    mov eax, 4
    mov ebx, 1
    mov ecx, lives_msg
    mov edx, lives_len
    int 0x80
    
    ; Generate random number
    call generate_random
    
game_loop:
    ; Check if lives are exhausted
    cmp dword [lives_count], 0
    je game_over
    
    ; Increment attempt counter
    inc dword [attempt_count]
    
    ; Display input prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_len
    int 0x80
    
    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 0x80
    
    ; Convert string to integer
    call string_to_int
    mov [user_guess], eax
    
    ; Compare with random number
    mov eax, [user_guess]
    mov ebx, [random_number]
    
    cmp eax, ebx
    je correct_guess
    jl too_low_guess
    jg too_high_guess

too_high_guess:
    ; Display "Too High" message
    mov eax, 4
    mov ebx, 1
    mov ecx, too_high_msg
    mov edx, too_high_len
    int 0x80
    
    ; Decrease lives and show remaining
    dec dword [lives_count]
    call show_lives_remaining
    jmp game_loop

too_low_guess:
    ; Display "Too Low" message
    mov eax, 4
    mov ebx, 1
    mov ecx, too_low_msg
    mov edx, too_low_len
    int 0x80
    
    ; Decrease lives and show remaining
    dec dword [lives_count]
    call show_lives_remaining
    jmp game_loop

correct_guess:
    ; Display congratulations message
    mov eax, 4
    mov ebx, 1
    mov ecx, correct_msg
    mov edx, correct_len
    int 0x80
    
    ; Display attempt count
    mov eax, 4
    mov ebx, 1
    mov ecx, attempts_msg
    mov edx, attempts_len
    int 0x80
    
    ; Convert attempt count to string and display
    mov eax, [attempt_count]
    call int_to_string
    call print_string
    
    ; Print newline
    call print_newline
    
    ; Ask if player wants to play again
    jmp ask_play_again

game_over:
    ; Display game over message
    mov eax, 4
    mov ebx, 1
    mov ecx, game_over_msg
    mov edx, game_over_len
    int 0x80
    
    ; Show the correct answer
    mov eax, 4
    mov ebx, 1
    mov ecx, answer_was_msg
    mov edx, answer_was_len
    int 0x80
    
    ; Display the random number
    mov eax, [random_number]
    call int_to_string
    call print_string
    call print_newline
    
    ; Ask if player wants to play again
    jmp ask_play_again

ask_play_again:
    ; Print newline for spacing
    call print_newline
    
    ; Ask if player wants to play again
    mov eax, 4
    mov ebx, 1
    mov ecx, play_again_msg
    mov edx, play_again_len
    int 0x80
    
    ; Read play again input
    mov eax, 3
    mov ebx, 0
    mov ecx, play_again_input
    mov edx, 5
    int 0x80
    
    ; Check first character of input
    movzx eax, byte [play_again_input]
    cmp eax, 'Y'
    je main_game_loop
    cmp eax, 'y'
    je main_game_loop
    cmp eax, 'N'
    je exit_game
    cmp eax, 'n'
    je exit_game
    
    ; Invalid input, ask again
    jmp ask_play_again

exit_game:
    ; Display goodbye message
    mov eax, 4
    mov ebx, 1
    mov ecx, thanks_msg
    mov edx, thanks_len
    int 0x80
    
    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80

; Show remaining lives
show_lives_remaining:
    ; Display lives remaining message
    mov eax, 4
    mov ebx, 1
    mov ecx, lives_left_msg
    mov edx, lives_left_len
    int 0x80
    
    ; Convert lives count to string and display
    mov eax, [lives_count]
    call int_to_string
    call print_string
    call print_newline
    call print_newline  ; Extra line for spacing
    ret

; Generate a pseudo-random number between 1-100
generate_random:
    ; Get current time as seed
    mov eax, 13        ; sys_time
    mov ebx, 0
    int 0x80
    
    ; Simple linear congruential generator
    ; random = (seed * 1103515245 + 12345) % 100 + 1
    mov edx, 0
    mov ebx, 1103515245
    mul ebx
    add eax, 12345
    
    ; Modulo 100
    mov edx, 0
    mov ebx, 100
    div ebx
    
    ; Add 1 to make range 1-100
    inc edx
    mov [random_number], edx
    ret

; Convert string to integer
string_to_int:
    mov esi, user_input
    mov eax, 0
    mov ebx, 0

convert_loop:
    movzx ecx, byte [esi + ebx]
    cmp ecx, 0xA        ; Check for newline
    je convert_done
    cmp ecx, 0          ; Check for null terminator
    je convert_done
    
    sub ecx, '0'        ; Convert ASCII to digit
    imul eax, 10        ; Multiply current result by 10
    add eax, ecx        ; Add new digit
    inc ebx             ; Move to next character
    jmp convert_loop

convert_done:
    ret

; Convert integer to string
int_to_string:
    mov esi, temp_buffer
    add esi, 9          ; Point to end of buffer
    mov byte [esi], 0   ; Null terminator
    dec esi
    
    mov ebx, 10         ; Divisor

convert_digit:
    mov edx, 0
    div ebx             ; Divide by 10
    add dl, '0'         ; Convert remainder to ASCII
    mov [esi], dl
    dec esi
    cmp eax, 0
    jne convert_digit
    
    inc esi             ; Point to start of number
    mov [temp_buffer], esi
    ret

; Print string from temp_buffer
print_string:
    mov esi, [temp_buffer]
    mov ecx, esi
    mov edx, 0

count_chars:
    cmp byte [esi + edx], 0
    je print_now
    inc edx
    jmp count_chars

print_now:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

; Print newline
print_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80
    ret