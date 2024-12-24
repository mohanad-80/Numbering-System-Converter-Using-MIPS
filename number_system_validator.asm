.data
    input_num:   .asciiz "Enter the number: "
    input_sys:   .asciiz "Enter the current system: "
    invalid_msg: .asciiz "Invalid number for the given system\n"
    valid_msg:   .asciiz "The number is valid for the given system\n"
    num_buf:     .space 10 # buffer for input number

.text
main:
    # read the current system
    li $v0, 4          # print string syscall
    la $a0, input_sys
    syscall

    li $v0, 5          # read integer syscall
    syscall
    move $t0, $v0      # store the current system in $t0

    # Check if currsys is valid
    blt $t0, 2, invalid_number
    bgt $t0, 16, invalid_number

    # read the number
    li $v0, 4          # print string syscall
    la $a0, input_num
    syscall

    li $v0, 8          # read string syscall
    la $a0, num_buf
    li $a1, 10
    syscall

    # validate the number based on current system
    la $t1, num_buf    # load address of number
    lb $t2, 0($t1)     # load first byte of number

validate_loop:
    beqz $t2, end_validation # if end of string, exit loop

    # Check if character is valid for the given system
    sub $t3, $t2, '0'
    blt $t3, $t0, valid_digit
    bge $t3, 10, check_alpha

    j invalid_number

check_alpha:
    sub $t3, $t2, 'A'
    addi $t3, $t3, 10
    blt $t3, $t0, valid_digit

    j invalid_number

valid_digit:
    addi $t1, $t1, 1   # move to next char
    lb $t2, 0($t1)     # load next byte of number
    j validate_loop

invalid_number:
    li $v0, 4          # print string syscall
    la $a0, invalid_msg
    syscall
    j exit

end_validation:
    li $v0, 4          # print string syscall
    la $a0, valid_msg
    syscall

exit:
    li $v0, 10         # exit syscall
    syscall
