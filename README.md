# Print Fixed Point #.16 Fraction

# Theory

Printing the fractional value of a 16-bit fixed point number in decimal is rather trivial.

For example, the number `0.7106` in 16-bit fixed point is 0.71506 * 65536 = 46,569 = `$B5E9`

How do we convert the number `$B5E9` back into `.7106` ? By _digit peeling._

Given a fractional number `N` represented as 16-bit integer then:

1. Multiply N by 10
2. Print the Integer Part digit
3. Set the Integer Part to zero
5. Have we printed the number of decimal digits we want? If no then goto step 1

Example:

```
     +-----------------------------+
     |                             |
    0.7106 * 65536 = $B5E9         |
                       |           |
                       |           v
                       v          '.'
                     $B5E9 * $A = $7.1B1A
                     $1B1A * $A = $1.0F04
                     $0F04 * $A = $0.9628
                     $9628 * $A = $5.DD90
                     $5DD9 * $A = $8.A7A0
```

An optimization for `N*10` is that this is equivalent to: `N*8 + N*2`


# Application

## Assembly (Source)

See file [print_fract.s](print_fract.s)

## Binary (Executable)

```
    CALL-151
    0800:a2 b5 a0 e9 20 1a 08 a9  ae 20 ed fd a2 00 bd 76
    0810:08 20 ed fd e8 e0 05 d0  f5 60 8e 71 08 8c 72 08
    0820:20 6a 08 aa 20 60 08 20  54 08 20 60 08 20 60 08
    0830:20 44 08 ad 70 08 09 b0  9d 76 08 20 6a 08 e8 e0
    0840:05 d0 e1 60 18 a0 02 b9  70 08 79 73 08 99 70 08
    0850:88 10 f4 60 a0 02 b9 70  08 99 73 08 88 10 f7 60
    0860:0e 72 08 2e 71 08 2e 70  08 60 a9 00 8d 70 08 60
    0870:00 00 00 00 00 00 00 00  00 00 00               
    800G
    E000G
```

## Output

```
.71058
```

