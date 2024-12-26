.text
.globl OtherToDecimal

OtherToDecimal:
    move $t0, $a0               # Pointer to the input number string
    move $t1, $a1               # Base of the input number
    move $t5, $a2               # pointer to the output buffer
    li $t3, 0                   # Initialize the decimal result to 0


loop_OtherToDecimal:
    lb $t4, 0($t0)              # Load the next character
    beqz $t4, count_digits      # If null terminator, proceed to string conversion
    sub $t4, $t4, 48            # Convert ASCII to digit value
    blt $t4, 10, digit_conversion # If digit < 10, process as is
    sub $t4, $t4, 7             # Adjust for letters (A-F)

digit_conversion:
    mul $t3, $t3, $t1           # Multiply current result by the base
    add $t3, $t3, $t4           # Add the digit to the result
    addi $t0, $t0, 1            # Move to the next character
    j loop_OtherToDecimal       # Repeat until null terminator

# Convert Decimal Result to String
count_digits:
    li $t2, 10                  # powers of 10
    addi $t5, $t5, 1            # Move to the next index
    blt $t3, $t2, write_digits  # if number of digits has been accounted for 
    mul $t2, $t2, 10            # Increase the count for digits 

set_up_writing:
    li $t2, 10                  # Initialize divisor
    sb $zero, 0($t5)            # Null-terminate the string
    subi $t5, $t5, 1            # Move back to the last index


write_digits:
    div $t3, $t3, $t2           # Divide result by 10
    mfhi $t1                    # Get the remainder
    sb $t5, $t1                 # Store the remainder at $t5 
    beqz $t3, end_OhterToDecimal# If result is 0, proceed to writing
    j write_digits


end_OhterToDecimal:
    jr $ra                      # Return to the caller

