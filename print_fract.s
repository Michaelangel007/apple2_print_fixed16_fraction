        ORG $800

COUT EQU $FDED

; ==================== Demo ====================

Demo
        ;0.7106 * 65536 = $B5E9
        ;                              '.'
        ;                 $B5E9 * $A = $7.1B1A
        ;                 $1B1A * $A = $1.0F04
        ;                 $0F04 * $A = $0.9628
        ;                 $9628 * $A = $5.DD90
        ;                 $5DD9 * $A = $8.A7A0
        ;
        ;0.71058 _______________________^

        LDX #$B5
        LDY #$E9
        JSR PrintFract

        LDA #'.'+$80
        JSR COUT
        LDX #0
PrintDigit
        LDA D0,X
        JSR COUT
        INX
        CPX #5          ; 5 decimal digits
        BNE PrintDigit
        RTS

; ==================== Conversion ====================

; --------------------
; Convert 16-bit fractional value to Decimal
; IN
;   X = high 16-bit val
;   Y = low  16-bit val
; OUT
;   [D0..D4] Decimal Fraction
; --------------------
PrintFract
        STX A2
        STY A3

        JSR ZeroInt
        TAX

        ; Psuedo Code
        ;     int8_t a[3]
        ;     int8_t t[3]
        ;     char   d[5]
        ;
        ;     for( iDigit = 0; iDigit < 5; iDigit++ )
        ;         a *= 2
        ;         t  = a
        ;         a *= 4
        ;         a += t
        ;         d[i] = a[0] | '0'
        ;         a[0] = 0
NextDigit
        JSR Mul2    ; *2
        JSR CopyT2  ;
        JSR Mul2    ; *4
        JSR Mul2    ; *8
        JSR AddT2   ; x*10 = x*8 + x*2 

        LDA A1      ; Convert binary num to ASCII
        ORA #$30+$80
        STA D0,X

        JSR ZeroInt

        INX
        CPX #5
        BNE NextDigit
        RTS


; ==================== Utility ====================

; --------------------
; Add Arrays
; A += T
; --------------------
AddT2
        CLC
        LDY #2
_AddT2
        LDA A2-1,Y
        ADC T2-1,Y
        STA A2-1,Y
        DEY
        BPL _AddT2
        RTS

; --------------------
; Copy Array
;    T = A
; --------------------
CopyT2
        LDY #2
_CopyT2
        LDA A2-1,Y
        STA T2-1,Y
        DEY
        BPL _CopyT2
        RTS


; --------------------
; 24-bit SHL
;    A *= 2
; --------------------
Mul2
        ASL A3
        ROL A2
        ROl A1
        RTS

; --------------------
; Clear Integer in 8.16 format
;     A[0] = 0
; --------------------
ZeroInt
        LDA #0
        STA A1
        RTS

; ==================== Data ====================

; 24-bit Number
A1      DB 0
A2      DB 0
A3      DB 0

; Temp
T1      DB 0 ; Always zero
T2      DB 0
T3      DB 0

; String Output in ASCII
D0      DB 0
D1      DB 0
D2      DB 0
D3      DB 0
D4      DB 0

