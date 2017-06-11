# Print Fixed Point #.16 Fraction

# Theory

Printing the fractional value of a 16-bit fixed point number in decimal is rather trivial.

For example, the number `0.7106` in 16-bit fixed point is 0.71506 * 65536 = 46,569 = `$B5E9`

How do we convert the number `$B5E9` back into `7106` ? By _digit peeling._

1. Multipy N by 10
2. Print the Integer Part digit
3. Set the Integer Part to zero
5. Have we printed the number of decimal digits we want? If no then goto step 1

Example:

```
    0.7106 * 65536 = $B5E9
                                  '.'
                     $B5E9 * $A = $7.1B1A
                     $1B1A * $A = $1.0F04
                     $0F04 * $A = $0.9628
                     $9628 * $A = $5.DD90
                     $5DD9 * $A = $8.A7A0

    0.71058 _______________________^
```

An optimization for N*10 is that this is equivalent to: `N*8 + N*2`


# Application

## Assembly (Source)

See file [print_fract.s](print_fract.s)

## Binary (Executable)

```
    CALL-151
    0800:a2 b5 a0 e9 20 15 08 a2 00 bd 70 08 20 ed fd e8
    0810:e0 05 d0 f5 60 a9 00 8d 6a 08 8e 6b 08 8c 6c 08
    0820:a2 00 20 60 08 20 54 08 20 60 08 20 60 08 20 44
    0830:08 ad 6a 08 09 b0 9d 70 08 a9 00 8d 6a 08 e8 e0
    0840:05 d0 df 60 18 a0 02 b9 6a 08 79 6d 08 99 6a 08
    0850:88 10 f4 60 a0 02 b9 6a 08 99 6d 08 88 10 f7 60
    0860:0e 6c 08 2e 6b 08 2e 6a 08 60 00 00 00 00 00 00
    0870:00 00 00 00 00
    800G
```

## Output

```
71058
```

