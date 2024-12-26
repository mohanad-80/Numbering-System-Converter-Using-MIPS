.text
.globl DecimalToOther

DecimalToOther:
    la $t0, ($a0)               # Load the address of the input string (decimal number as string)
    la $t3, ($a2)               # Load the address of the output buffer for the result
    la $t4, ($a2)               # Load the address of the output buffer for the reverse logic
    li $t1, 0                   # Initialize decimal number with 0

# Convert String to Decimal Number
string_to_decimal:
    lb $t2, 0($t0)              # Load the current character
    beqz $t2, loop_DecimalToOther # If null terminator, end conversion
    subi $t2, $t2, 48           # Convert ASCII to integer (ASCII '0' = 48)
    mul $t1, $t1, 10            # Multiply current number by 10
    add $t1, $t1, $t2           # Add the new digit
    addi $t0, $t0, 1            # Move to the next character
    j string_to_decimal         # Repeat until the null terminator

# Base Conversion 
loop_DecimalToOther:
    move $t2, $a1               # Base of the number system
    beqz $t1, end_DecimalToOther # Exit loop if the number is zero
    div $t5, $t1, $t2            # Divide number by base
    mfhi $t6                     # Save the mod as a digit
    move $t1, $t5                # Save the integer part as the new number
    blt $t6, 10, convert_digit   # If digit < 10, handle as digit

    # Convert to letter (if digit >= 10)
    addi $t6, $t6, 55            # Add 55 to get the ASCII of the letter
    j store_char

convert_digit:
    addi $t6, $t6, 48            # Add 48 to get the ASCII of the number

store_char:
    sb $t6, 0($t3)               # Store the digit in the result
    addi $t3, $t3, 1             # Move to the next position
    j loop_DecimalToOther

end_DecimalToOther:
    sb $zero, 0($t3)             # Null-terminate the string
    subi $t3, $t3, 1             # Move back to the last valid character

reverse_loop:
    lb $t5, 0($t3)               # Load the character from the end of the string to $t5
    lb $t6, 0($t4)               # Load the character from the beginning to $t6
    sb $t5, 0($t4)               # Swap: Store $t5 at the beginning
    sb $t6, 0($t3)               # Swap: Store $t6 at the end
    addi $t4, $t4, 1             # Move $t4 forward
    subi $t3, $t3, 1             # Move $t3 backward
    blt $t4, $t3, reverse_loop   # Continue until $t4 >= $t3

end_reverse:
    la $v0, reversed_str         # Pointer to the result
    jr $ra                       # Return to the main
