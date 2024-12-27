.data
currentSystemInputMessage:  .asciiz "Enter the current system: "            # message displayed before reading the current system from user
numberInputMessage:         .asciiz "Enter the number: "                    # message displayed before reading the number from user
newSystemInputMessage:      .asciiz "Enter the new system: "                # message displayed before reading the new system from user
outputNumberMessage:        .asciiz "\nThe number in the new system: "      # message displayed before writing the new number to the screen
invalidNumberMessage:       .asciiz "Invalid number for the given system\n" # message displayed if the input number is not valid
invalidSystemMessage:       .asciiz "Invalid system, valid are [2, 16]\n"   # message displayed if the input system is not valid
bufferSize:                 .word   50                                      # constant used to store the buffer's size
inputNumberBuffer:          .space  50                                      # 50 byte used for storing the number to convert as a string
outputNumberBuffer:         .space  50                                      # 50 byte used for storing the converted number as a string
currentSystem:              .word   10                                      # integer used for storing the current system (max 16)
newSystem:                  .word   10                                      # integer used for storing the new system (max 16) 

.text
main:
    # read current system
    la   $a0, currentSystemInputMessage     # load the message address
    jal  PrintAndReadInt                    # print and read integer
    sw   $v0, currentSystem                 # store the input

    # Check if current system is valid
    lw   $t0, currentSystem                 # t0 = current system
    blt  $t0, 2, InvalidSystem              # min is 2
    bgt  $t0, 16, InvalidSystem             # max is 16

    # read number string
    li   $v0, 4                             # syscall code for printing string
    la   $a0, numberInputMessage            # load the message address
    syscall                                 # print the message
    li   $v0, 8                             # syscall code for reading string
    la   $a0, inputNumberBuffer             # load the address of the buffer
    lw   $a1, bufferSize                    # load the size of the buffer
    syscall                                 # read the string

    # check if the input is valid for the given system
    la   $a0, inputNumberBuffer             # first argument is the number's address
    move $a1, $t0                           # second argumnet is the system
    jal  ValidateInput                      # call the validation function

    # read new system
    la   $a0, newSystemInputMessage         # load the message address
    jal  PrintAndReadInt                    # print and read integer
    sw   $v0, newSystem                     # store the input

    # Check if new system is valid
    lw   $t1, newSystem                     # t1 = new system
    blt  $t1, 2, InvalidSystem              # min is 2
    bgt  $t1, 16, InvalidSystem             # max is 16

    lw   $t0, currentSystem                 # t0 = current system
    # if both systems are equal
    beq  $t0, $t1, HandleEqualSystems
    # else if the current system is decimal
    beq  $t0, 10, CallDecimalToOther
    # else if the new system is decimal
    beq  $t1, 10, CallOtherToDecimal
    # else (both systems are not decimal)
    b    ConvertNonDecimalToNonDecimal

PrintAndReadInt:
    # Prints a message and reads an integer from the user
    li   $v0, 4                             # syscall code for printing string
    syscall                                 # print the message
    li   $v0, 5                             # syscall code for reading int
    syscall                                 # read the integer
    jr   $ra                                # return to the caller

ValidateInput:
    # validate the number based on current system
    # inputs:
    #	$a0 - address of input buffer
    #	$a1 - current system
    # returns:
    #	None
    move $t0, $a1                           # t0 = current system
    la   $t1, ($a0)                         # load address of number
    lb   $t2, 0($t1)			            # load first byte of number

    ValidateLoop:
    beqz $t2, EndValidation		            # if end of string, exit loop
    # Check if character is valid for the given system
    sub  $t3, $t2, '0'
    blt  $t3, $t0, ValidDigit
    bge  $t3, 10, CheckAlpha
    j    InvalidNumber

    CheckAlpha:
    sub  $t3, $t2, 'A'
    addi $t3, $t3, 10
    blt  $t3, $t0, ValidDigit
    j    InvalidNumber

    ValidDigit:
    addi $t1, $t1, 1		                # move to next char
    lb   $t2, 0($t1)			            # load next byte of number
    j    ValidateLoop

    InvalidNumber:
    li   $v0, 4			                    # print string syscall
    la   $a0, invalidNumberMessage
    syscall
    li   $v0, 10                            # syscall code for exiting the program
    syscall                                 # exit

    EndValidation:
    jr   $ra				                # return from the validation function

InvalidSystem:
    li   $v0, 4			                    # syscall for printing string
    la   $a0, invalidSystemMessage	        # load the message address
    syscall				                    # print the message
    li   $v0, 10                            # syscall code for exiting the program
    syscall                                 # exit

HandleEqualSystems:
    # both systems are equal so just copy
    # the input number into the output
    la   $a0, inputNumberBuffer             # a0 = address of source buffer
    la   $a1, outputNumberBuffer            # a1 = address of target buffer
    jal  CopyBuffer                         # copy source into target
    j    DisplayOutputAndExit               # print output and exit

CallDecimalToOther:
    la   $a0, inputNumberBuffer             # a0 = address of the decimal number as string
    lw   $a1, newSystem                     # a1 = new system
    la   $a2, outputNumberBuffer            # a2 = address of buffer to store the converted number as string
    jal  DecimalToOther                     # convert from decimal to other
    j    DisplayOutputAndExit               # print output and exit

CallOtherToDecimal:
    la   $a0, inputNumberBuffer             # a0 = address of the number to convert, stored as string
    lw   $a1, currentSystem                 # a1 = current system
    la   $a2, outputNumberBuffer            # a2 = address of the decimal number as string
    jal  OtherToDecimal                     # convert from other to decimal
    j    DisplayOutputAndExit               # print output and exit

ConvertNonDecimalToNonDecimal:
    la   $a0, inputNumberBuffer             # a0 = address of the number to convert, stored as string
    lw   $a1, currentSystem                 # a1 = current system
    la   $a2, outputNumberBuffer            # a2 = address of the decimal number as string
    jal  OtherToDecimal                     # convert from other to decimal

    # copy output from previous step
    # into input for the next one
    la   $a0, outputNumberBuffer            # a0 = address of source buffer
    la   $a1, inputNumberBuffer             # a1 = address of target buffer
    jal  CopyBuffer                         # copy source into target

    la   $a0, inputNumberBuffer             # a0 = address of the decimal number as string
    lw   $a1, newSystem                     # a1 = new system
    la   $a2, outputNumberBuffer            # a2 = address of buffer to store the converted number as string
    jal  DecimalToOther                     # convert from decimal to other
    j    DisplayOutputAndExit               # print output and exit

CopyBuffer:
    move $t3, $a0                           # t3 = a0 = address of the source buffer
    move $t4, $a1                           # t4 = a1 = address of the target buffer

    CopyLoop:
    lb   $t5, 0($t3)                        # Load byte from source buffer
    sb   $t5, 0($t4)                        # Store byte in target buffer
    beqz $t5, EndLoop                       # If null terminator, exit loop
    addi $t3, $t3, 1                        # Move to next byte in source
    addi $t4, $t4, 1                        # Move to next byte in target
    j    CopyLoop

    EndLoop:
    jr   $ra

DecimalToOther:
    # Inputs:
    #   $a0 - Address of input buffer (decimal number as a string)
    #   $a1 - Int representing target system (base 2 to 16)
    #   $a2 - Address of output buffer (store converted string)
    # Outputs:
    #   None (result is stored in $a2)
    la   $t0, ($a0)                         # Load the address of the input string (decimal number as string)
    la   $t3, ($a2)                         # Load the address of the output buffer for the result
    la   $t4, ($a2)                         # Load the address of the output buffer for the reverse logic
    li   $t1, 0                             # Initialize decimal number with 0	

    # Convert String to Decimal Number
    StringToDecimal:
    lb   $t2, 0($t0)                        # Load the current character
    beq  $t2, 10, DecimalDone               # If newline character, exit loop
    beqz $t2, DecimalDone                   # If null terminator, end conversion
    subi $t2, $t2, '0'                      # Convert ASCII to integer (ASCII '0' = 48)
    mul  $t1, $t1, 10                       # Multiply current number by 10
    add  $t1, $t1, $t2                      # Add the new digit
    addi $t0, $t0, 1                        # Move to the next character
    j    StringToDecimal                    # Repeat until the null terminator
    DecimalDone:

    # Base Conversion 
    move $t2, $a1                           # Base of the number system

    LoopDecimalToOther:
    beqz $t1, EndDecimalToOther             # Exit loop if the number is zero
    div  $t5, $t1, $t2                      # Divide number by base
    mfhi $t6                                # Save the mod as a digit
    move $t1, $t5                           # Save the integer part as the new number
    blt  $t6, 10, ConvertDigit              # If digit < 10, handle as digit
    addi $t6, $t6, 55                       # Add 55 to get the ASCII of the letter
    j    StoreChar

    ConvertDigit:
    addi $t6, $t6, 48                       # Add 48 to get the ASCII of the number

    StoreChar:
    sb   $t6, 0($t3)                        # Store the digit in the result
    addi $t3, $t3, 1                        # Move to the next position
    j    LoopDecimalToOther

    EndDecimalToOther:
    sb   $zero, 0($t3)                      # Null-terminate the string
    subi $t3, $t3, 1                        # Move back to the last valid character

    ReverseLoop:
    lb   $t5, 0($t3)                        # Load the character from the end of the string to $t5
    lb   $t6, 0($t4)                        # Load the character from the beginning to $t6
    sb   $t5, 0($t4)                        # Swap: Store $t5 at the beginning
    sb   $t6, 0($t3)                        # Swap: Store $t6 at the end
    addi $t4, $t4, 1                        # Move $t4 forward
    subi $t3, $t3, 1                        # Move $t3 backward
    blt  $t4, $t3, ReverseLoop              # Continue until $t4 >= $t3

    EndReverse:
    jr   $ra                                # Return to the caller

OtherToDecimal:
    # Inputs:
    #   $a0 - Address of input buffer (number as a string)
    #   $a1 - Int representing source system (base 2 to 16)
    #   $a2 - Address of output buffer (store decimal number as string)
    # Outputs:
    #   None (result is stored in $a2)
    la   $t0, ($a0)                         # Pointer to the input number string
    move $t1, $a1                           # Base of the input number
    la   $t5, ($a2)                         # pointer to the output buffer
    li   $t3, 0                             # Initialize the decimal result to 0

    LoopOtherToDecimal:
    lb   $t4, 0($t0)                        # Load the next character
    beq  $t4, 10, EndConversion             # If newline character, exit loop
    beqz $t4, EndConversion                 # If null terminator, proceed to string conversion
    subi $t4, $t4, '0'                      # Convert ASCII to digit value
    blt  $t4, 10, DigitConversion           # If digit < 10, process as is
    subi $t4, $t4, 7                        # Adjust for letters (A-F)
    
    DigitConversion:
    mul  $t3, $t3, $t1                      # Multiply current result by the base
    add  $t3, $t3, $t4                      # Add the digit to the result
    addi $t0, $t0, 1                        # Move to the next character
    j    LoopOtherToDecimal                 # Repeat until null terminator
    EndConversion:

    # Convert Decimal Result to String
    li   $t2, 10                            # powers of 10

    CountDigits:
    addi $t5, $t5, 1                        # Move to the next index
    blt  $t3, $t2, SetupWriting             # if number of digits has been accounted for 
    mul  $t2, $t2, 10                       # Increase the count for digits 
    j    CountDigits

    SetupWriting:
    li   $t2, 10                            # Initialize divisor
    sb   $zero, 0($t5)                      # Null-terminate the string
    subi $t5, $t5, 1                        # Move back to the last index

    WriteDigits:
    beqz $t3, EndOtherToDecimal             # If result is 0, proceed to writing
    div  $t3, $t3, $t2                      # Divide result by 10
    mfhi $t1                                # Get the remainder
    addi $t1, $t1, '0'                      # Get ASCII value
    sb   $t1, 0($t5)                        # Store the remainder at $t5
    subi $t5, $t5, 1                        # Move backward
    j    WriteDigits
    
    EndOtherToDecimal:
    jr   $ra                                # Return to the caller

DisplayOutputAndExit:
    # display output message
    li   $v0, 4                             # syscall code for printing string
    la   $a0, outputNumberMessage           # load the message address
    syscall                                 # print the message
    # print string storing converted number
    li   $v0, 4                             # syscall code for printing string
    la   $a0, outputNumberBuffer            # load the message address
    syscall                                 # print the message
    # exit program
    li   $v0, 10                            # syscall code for exiting the program
    syscall                                 # exit
