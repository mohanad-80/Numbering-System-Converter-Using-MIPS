.data
reversed_str: .space 32         # For saving the initial result
final_str: .space 32            # For saving the final result

.text
.globl DecimalToOther

DecimalToOther:
    move $t1, $a0             # Decimal number
    move $t2, $a1             # Base system
    la $t3, reversed_str      # Pointer to the initial
    la $t4, final_str         # Pointer to the final result

loop_DecimalToOther:
    beqz $t1, end_DecimalToOther # Exit loop if the number is zero
    div $t5, $t1, $t2             # Divide number by base
    mfhi $t6                      # Save the mod as a digit
    move $t1, $t5                 # Save the integer part as the new number
    blt $t6, 10, convert_digit    # If digit < 10, handle as digit

    # Convert to letter (if digit >= 10)
    addi $t6, $t6, 55             # Add 55 to get the ASCII of the letter
    j store_char

convert_digit:
    addi $t6, $t6, 48             # Add 48 to get the ASCII of the number

store_char:
    sb $t6, 0($t3)                # Store the digit in initial result
    addi $t3, $t3, 1              # Move to the next position
    j loop_DecimalToOther

end_DecimalToOther:
    subi $t3, $t3, 1              # Move back to the last valid character

reverse_loop:
    lb $t5, 0($t3)                # Load the current character 
    sb $t5, 0($t4)                # Store it in final result
    subi $t3, $t3, 1              # Move backward to the character in order
    addi $t4, $t4, 1              # Move to the next index
    bne $t3, $zero, reverse_loop  # Continue if not at index 0

end_reverse:
    sb $zero, 0($t4)              # add null to the end of the final result 
    la $v0, final_str             # Pointer to final result 
    jr $ra                        # return to the main
