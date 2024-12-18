# Numbering System Converter

## Project Overview
The **Numbering System Converter** project is an assembly program designed to convert numbers between different numbering systems, including binary, octal, decimal, and hexadecimal. This project allows users to input a number along with its current numbering system and specify the desired numbering system for conversion. The program then outputs the converted number in the specified system.

## Features
- Convert numbers between any two numbering systems (binary, octal, decimal, hexadecimal).
- Efficient implementation using assembly functions.
- Error handling for invalid inputs (bonus feature).
- User-friendly input and output flow.

## Requirements
1. The program takes three inputs from the user:
   - The number to be converted.
   - The numbering system of the input number.
   - The numbering system to convert the number to.
2. Two main assembly functions:
   - `OtherToDecimal`: Converts a number from any system to decimal. It accepts two parameters: the number and its current numbering system.
   - `DecimalToOther`: Converts a decimal number to any other numbering system. It accepts two parameters: the decimal number and the desired numbering system.
3. The program outputs the number in the desired system.
4. Must use MARS as the assembly simulator.
5. Bonus: Validate the input number to ensure it belongs to the specified numbering system. For example, if the system is 8 and the number is 78, the program should display an error message.

## Sample Inputs and Outputs
### Example 1:
**Input:**
```
Enter the current system: 10
Enter the number: 67
Enter the new system: 8
```
**Output:**
```
The number in the new system: 103
```

### Example 2:
**Input:**
```
Enter the current system: 2
Enter the number: 100101
Enter the new system: 10
```
**Output:**
```
The number in the new system: 37
```

### Example 3:
**Input:**
```
Enter the current system: 7
Enter the number: 43
Enter the new system: 16
```
**Output:**
```
The number in the new system: 1F
```

### Example 4:
**Input:**
```
Enter the current system: 4
Enter the number: 203
Enter the new system: 12
```
**Output:**
```
The number in the new system: 2B
```


## Authors
- [Aya Essam](https://github.com/AyaEssam2004)
- [Ashraf Alaa](https://github.com/ashrafalaa16)
- [Ahmad Ehab](https://github.com/AhmedEhab2022)
- [Mohanad Ahmed](https://github.com/mohanad-80)
- [Mohamad Abd Elwahab](https://github.com/MidMoh21)
