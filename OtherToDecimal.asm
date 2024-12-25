# Function: OtherToDecimal
# Converts a number from a given base to decimal
# Parameters:
#   $a0: pointer to the number
#   $a1: base of the current number
# Returns:
#   $v0: resulted decimal number

.text
.globl OtherToDecimal

OtherToDecimal:
    move $t0, $a0             # move the pointer to a register
    move $t1, $a1             # move the base to a register
    li $t3, 0                 # intialize the result by 0

loop_OtherToDecimal:
    lb $t4, 0($t0)               # load next digit
    beqz $t4, end_OtherToDecimal # break loop if null 
    sub $t4, $t4, 48             # get the digit value form it’s ASCII
    blt $t4, 10, convert_digit   # If digit < 10, proceed with digit conversion
    sub $t4, $t4, 7              # subtract addional 7 for total of 55 in case of letter

digit_conversion:
    mul $t3, $t3, $t1         # multiply result by the base
    add $t3, $t3, $t4         # add current digit to result
    addi $t0, $t0, 1          # move to the next digit
    j loop_OtherToDecimal


end_OtherToDecimal:
    move $v0, $t3             # store the result 
    jr $ra                    # return to main
