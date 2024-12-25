# Function: DecimalToOther
# Converts a decimal number to a given base
# Parameters:
#   $a0: the decimal number 
#   $a1: base to convert to
# Returns:
#   $v0: pointre to the result 

.data
output_str: .space 32         #for saving the result 

.text
.globl DecimalToOther

DecimalToOther:
    move $t1, $a0             # decimal number
    move $t2, $a1             # base system
    la $t3, output_str        # Pointer to the result
    li $t4, 0                 # current index

loop_DecimalToOther:
    beqz $t1, end_DecimalToOther # Exit loop if the number is zero
    div $t5, $t1, $t2             # Divide number by base
    mfhi $t6                      # save the mod as digit
    move $t1, $t5                 # save the integer part as the new number
    blt $t6, 10, convert_digit    # If digit < 10, handle as digit

    # Convert to letter (if digit >= 10)
    addi $t6, $t6, 55             # add 55 to get the ASCII of the Letter
    j store_char

convert_digit:
    addi $t6, $t6, 48             # add 48 to get the ASCII of the number

store_char:
    sb $t6, 0($t3)                # Store the digit to the
    addi $t3, $t3, 1              # move to the next position
    addi $t4, $t4, 1              # increment the current index
    j loop_DecimalToOther

end_DecimalToOther:
    sb $zero, 0($t3)              # add null to the end of result 
    la $v0, output_str            # pointer to the result 
    jr $ra                        # return to main
