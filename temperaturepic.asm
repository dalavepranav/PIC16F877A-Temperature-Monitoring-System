;===============================================================
;        TEMPERATURE MONITORING SYSTEM
;        PIC16F877A + DHT11 + 20x4 LCD
;        20 MHz Crystal
;
;        LCD DATA : RC0-RC7
;        LCD RS   : RD0
;        LCD EN   : RD1
;        LCD RW   : GND
;
;        DHT11 DATA : RB0
;
;        BUZZER : RD2
;        LED1   : RD3
;        LED2   : RD4
;        RELAY  : RD5
;
;        FAN LOGIC:
;        TEMP <= 35 C : FAN OFF
;        TEMP >  35 C : FAN ON
;
;        RELAY MODULE: 5V
;===============================================================

        LIST    P=16F877A
        #include <P16F877A.INC>

        __CONFIG _HS_OSC & _WDT_OFF & _PWRTE_ON & _LVP_OFF & _CP_OFF

;===============================================================
; PIN DEFINITIONS
;===============================================================

LCD_RS      EQU     0
LCD_EN      EQU     1

BUZZER      EQU     2
LED1        EQU     3
LED2        EQU     4
RELAY       EQU     5

DHT_DATA    EQU     0

;===============================================================
; VARIABLES
;===============================================================

        CBLOCK  0x20

TEMP
HUM

DHT_HUM_DEC
DHT_TEMP_DEC
DHT_CHECKSUM

DHT_BYTE
DHT_BIT
TIMEOUT

CHECKSUM_VALUE

DIGIT_TENS
DIGIT_ONES

LED_STATE

DLY1
DLY2
DLY3

        ENDC

;===============================================================
; RESET
;===============================================================

        ORG     0x0000
        GOTO    START

;===============================================================
; START
;===============================================================

START:

        BSF     STATUS,RP0

        ; PORTC = LCD DATA
        CLRF    TRISC

        ; PORTD = LCD + OUTPUTS
        CLRF    TRISD

        ; PORTB
        MOVLW   b'11111111'
        MOVWF   TRISB

        ; Digital I/O
        MOVLW   0x06
        MOVWF   ADCON1

        BCF     STATUS,RP0

        CLRF    PORTB
        CLRF    PORTC
        CLRF    PORTD

        CLRF    LED_STATE

        CALL    LCD_INIT

;===============================================================
; STARTUP BEEP
;===============================================================

        CALL    STARTUP_BEEP

;===============================================================
; SCREEN 1
; EMBEDDED SYSTEM
; MINI PROJECT
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_EMBEDDED

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_MINI_PROJECT

        CALL    DELAY_2000MS

;===============================================================
; SCREEN 2
; NAME OF PROJECT
; TEMPERATURE MONITORING SYSTEM
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_NAME_PROJECT

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_TEMP_MONITOR

        CALL    DELAY_2000MS

;===============================================================
; SCREEN 3
; MICROCONTROLLER
; PIC16F877A
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_MICRO

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_PIC

        CALL    DELAY_2000MS

;===============================================================
; SCREEN 4
; PROJECT GUIDE
; Prof. Vikas Salunkhe
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_PROJECT_GUIDE

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_GUIDE_NAME

        CALL    DELAY_2000MS

;===============================================================
; SCREEN 5
; DEVELOPED BY
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_DEVELOPED

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_AKSHATA

        MOVLW   0x94
        CALL    LCD_CMD

        CALL    MSG_PRANAV

        CALL    DELAY_2500MS

;===============================================================
; SCREEN 6
; SYSTEM READY
;===============================================================

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_SYSTEM

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_READY

        CALL    DELAY_1500MS

;===============================================================
; MAIN LOOP
;===============================================================

MAIN:

        CALL    DHT11_READ

        ; Carry = 1 = ERROR
        BTFSC   STATUS,C
        GOTO    DHT_ERROR

;===============================================================
; CLEAR LCD
;===============================================================

        CALL    LCD_CLEAR

;===============================================================
; LINE 1
; TEMP: XX C
;===============================================================

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_TEMP_LABEL

        MOVF    TEMP,W
        CALL    DISPLAY_2DIGIT

        MOVLW   ' '
        CALL    LCD_DATA

        MOVLW   'C'
        CALL    LCD_DATA

;===============================================================
; LINE 2
; HUM: XX% FAN:ON/OFF
;===============================================================

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_HUM_LABEL

        MOVF    HUM,W
        CALL    DISPLAY_2DIGIT

        MOVLW   '%'
        CALL    LCD_DATA

        MOVLW   ' '
        CALL    LCD_DATA

        CALL    MSG_FAN_LABEL

;===============================================================
; FAN CONTROL
;
; FAN ON ONLY WHEN TEMP > 35
; TEMP <= 35 = OFF
;===============================================================

        MOVLW   .35
        SUBWF   TEMP,W

        ; Carry = 1 when TEMP >= 35
        BTFSS   STATUS,C
        GOTO    FAN_OFF_COLD

        ; If TEMP = 35, FAN OFF
        MOVF    TEMP,W
        XORLW   .35

        BTFSC   STATUS,Z
        GOTO    FAN_OFF_COLD

        ; TEMP > 35
        GOTO    FAN_ON_HOT

;===============================================================
; FAN OFF
;===============================================================

FAN_OFF_COLD:

        BCF     PORTD,RELAY
        BCF     PORTD,BUZZER

        CALL    MSG_FAN_OFF

        GOTO    SHOW_STATUS

;===============================================================
; FAN ON
;===============================================================

FAN_ON_HOT:

        BSF     PORTD,RELAY

        CALL    MSG_FAN_ON

        CALL    HOT_BEEP_PATTERN

        GOTO    SHOW_STATUS

;===============================================================
; LINE 3
; STATUS
;===============================================================

SHOW_STATUS:

        MOVLW   0x94
        CALL    LCD_CMD

        CALL    MSG_STATUS

;===============================================================
; STATUS: HOT ONLY ABOVE 35
;===============================================================

        MOVLW   .35
        SUBWF   TEMP,W

        ; TEMP < 35
        BTFSS   STATUS,C
        GOTO    STATUS_COLD

        ; TEMP = 35
        MOVF    TEMP,W
        XORLW   .35

        BTFSC   STATUS,Z
        GOTO    STATUS_COLD

        ; TEMP > 35
        GOTO    STATUS_HOT

;---------------------------------------------------------------
; COLD
;---------------------------------------------------------------

STATUS_COLD:

        CALL    MSG_COLD

        GOTO    SHOW_LINE4

;---------------------------------------------------------------
; HOT
;---------------------------------------------------------------

STATUS_HOT:

        CALL    MSG_HOT

;===============================================================
; LINE 4
; SYSTEM ACTIVE
;===============================================================

SHOW_LINE4:

        MOVLW   0xD4
        CALL    LCD_CMD

        CALL    MSG_ACTIVE

;===============================================================
; LED ANIMATION
;===============================================================

        MOVF    LED_STATE,W

        BTFSC   STATUS,Z
        GOTO    LED_ONE

        BCF     PORTD,LED1
        BSF     PORTD,LED2

        CLRF    LED_STATE

        GOTO    NEXT_READING

LED_ONE:

        BSF     PORTD,LED1
        BCF     PORTD,LED2

        MOVLW   0x01
        MOVWF   LED_STATE

;===============================================================
; NEXT READING
;===============================================================

NEXT_READING:

        CALL    DELAY_1500MS

        GOTO    MAIN

;===============================================================
; DHT ERROR
;===============================================================

DHT_ERROR:

        BCF     PORTD,BUZZER
        BCF     PORTD,RELAY
        BCF     PORTD,LED1
        BCF     PORTD,LED2

        CALL    LCD_CLEAR

        MOVLW   0x80
        CALL    LCD_CMD

        CALL    MSG_DHT

        MOVLW   0xC0
        CALL    LCD_CMD

        CALL    MSG_ERROR

        CALL    DELAY_1500MS

        GOTO    MAIN

;===============================================================
; DHT11 READ
;===============================================================

DHT11_READ:

;---------------------------------------------------------------
; MAKE RB0 OUTPUT
;---------------------------------------------------------------

        BSF     STATUS,RP0
        BCF     TRISB,DHT_DATA
        BCF     STATUS,RP0

;---------------------------------------------------------------
; START SIGNAL
;---------------------------------------------------------------

        BCF     PORTB,DHT_DATA

        CALL    DELAY_20MS

        BSF     PORTB,DHT_DATA

        CALL    DELAY_40US

;---------------------------------------------------------------
; RB0 INPUT
;---------------------------------------------------------------

        BSF     STATUS,RP0
        BSF     TRISB,DHT_DATA
        BCF     STATUS,RP0

;---------------------------------------------------------------
; DHT RESPONSE
;---------------------------------------------------------------

        CALL    DHT_WAIT_LOW

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        CALL    DHT_WAIT_HIGH

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        CALL    DHT_WAIT_LOW

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

;===============================================================
; BYTE 1 HUMIDITY
;===============================================================

        CALL    DHT_READ_BYTE

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        MOVWF   HUM

;===============================================================
; BYTE 2 HUMIDITY DECIMAL
;===============================================================

        CALL    DHT_READ_BYTE

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        MOVWF   DHT_HUM_DEC

;===============================================================
; BYTE 3 TEMPERATURE
;===============================================================

        CALL    DHT_READ_BYTE

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        MOVWF   TEMP

;===============================================================
; BYTE 4 TEMPERATURE DECIMAL
;===============================================================

        CALL    DHT_READ_BYTE

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        MOVWF   DHT_TEMP_DEC

;===============================================================
; BYTE 5 CHECKSUM
;===============================================================

        CALL    DHT_READ_BYTE

        BTFSC   STATUS,C
        GOTO    DHT_FAIL

        MOVWF   DHT_CHECKSUM

;===============================================================
; CHECKSUM
;===============================================================

        MOVF    HUM,W
        ADDWF   DHT_HUM_DEC,W
        MOVWF   CHECKSUM_VALUE

        MOVF    TEMP,W
        ADDWF   CHECKSUM_VALUE,F

        MOVF    DHT_TEMP_DEC,W
        ADDWF   CHECKSUM_VALUE,W

        XORWF   DHT_CHECKSUM,W

        BTFSS   STATUS,Z
        GOTO    DHT_FAIL

        BCF     STATUS,C

        RETURN

;===============================================================
; DHT FAIL
;===============================================================

DHT_FAIL:

        BSF     STATUS,C
        RETURN

;===============================================================
; WAIT FOR LOW
;===============================================================

DHT_WAIT_LOW:

        MOVLW   .255
        MOVWF   TIMEOUT

DWL:

        BTFSS   PORTB,DHT_DATA
        GOTO    DWL_FOUND

        DECFSZ  TIMEOUT,F
        GOTO    DWL

        BSF     STATUS,C
        RETURN

DWL_FOUND:

        BCF     STATUS,C
        RETURN

;===============================================================
; WAIT FOR HIGH
;===============================================================

DHT_WAIT_HIGH:

        MOVLW   .255
        MOVWF   TIMEOUT

DWH:

        BTFSC   PORTB,DHT_DATA
        GOTO    DWH_FOUND

        DECFSZ  TIMEOUT,F
        GOTO    DWH

        BSF     STATUS,C
        RETURN

DWH_FOUND:

        BCF     STATUS,C
        RETURN

;===============================================================
; DHT READ BYTE
;===============================================================

DHT_READ_BYTE:

        CLRF    DHT_BYTE

        MOVLW   .8
        MOVWF   DHT_BIT

READ_DHT_BIT:

        MOVLW   .100
        MOVWF   TIMEOUT

WAIT_DHT_HIGH:

        BTFSC   PORTB,DHT_DATA
        GOTO    DHT_HIGH_FOUND

        DECFSZ  TIMEOUT,F
        GOTO    WAIT_DHT_HIGH

        BSF     STATUS,C
        RETURN

DHT_HIGH_FOUND:

        CALL    DELAY_35US

        BCF     STATUS,C

        RLF     DHT_BYTE,F

        BTFSS   PORTB,DHT_DATA
        GOTO    DHT_ZERO

        BSF     DHT_BYTE,0

DHT_ZERO:

        MOVLW   .150
        MOVWF   TIMEOUT

WAIT_DHT_LOW:

        BTFSS   PORTB,DHT_DATA
        GOTO    DHT_LOW_FOUND

        DECFSZ  TIMEOUT,F
        GOTO    WAIT_DHT_LOW

        BSF     STATUS,C
        RETURN

DHT_LOW_FOUND:

        DECFSZ  DHT_BIT,F
        GOTO    READ_DHT_BIT

        MOVF    DHT_BYTE,W

        BCF     STATUS,C

        RETURN

;===============================================================
; LCD INITIALIZATION
;===============================================================

LCD_INIT:

        CALL    DELAY_20MS

        MOVLW   0x38
        CALL    LCD_CMD

        CALL    DELAY_5MS

        MOVLW   0x0C
        CALL    LCD_CMD

        MOVLW   0x06
        CALL    LCD_CMD

        MOVLW   0x01
        CALL    LCD_CMD

        CALL    DELAY_5MS

        RETURN

;===============================================================
; LCD COMMAND
;===============================================================

LCD_CMD:

        MOVWF   PORTC

        BCF     PORTD,LCD_RS

        BSF     PORTD,LCD_EN

        CALL    DELAY_1MS

        BCF     PORTD,LCD_EN

        CALL    DELAY_1MS

        RETURN

;===============================================================
; LCD DATA
;===============================================================

LCD_DATA:

        MOVWF   PORTC

        BSF     PORTD,LCD_RS

        BSF     PORTD,LCD_EN

        CALL    DELAY_1MS

        BCF     PORTD,LCD_EN

        CALL    DELAY_1MS

        RETURN

;===============================================================
; LCD CLEAR
;===============================================================

LCD_CLEAR:

        MOVLW   0x01
        CALL    LCD_CMD

        CALL    DELAY_5MS

        RETURN

;===============================================================
; DISPLAY 2 DIGITS
;===============================================================

DISPLAY_2DIGIT:

        MOVWF   DIGIT_ONES

        CLRF    DIGIT_TENS

DIGIT_LOOP:

        MOVLW   .10

        SUBWF   DIGIT_ONES,W

        BTFSS   STATUS,C
        GOTO    DISPLAY_DIGITS

        MOVWF   DIGIT_ONES

        INCF    DIGIT_TENS,F

        GOTO    DIGIT_LOOP

DISPLAY_DIGITS:

        MOVF    DIGIT_TENS,W

        ADDLW   '0'

        CALL    LCD_DATA

        MOVF    DIGIT_ONES,W

        ADDLW   '0'

        CALL    LCD_DATA

        RETURN

;===============================================================
; STARTUP BEEP
;===============================================================

STARTUP_BEEP:

        BSF     PORTD,BUZZER
        CALL    DELAY_100MS

        BCF     PORTD,BUZZER
        CALL    DELAY_100MS

        BSF     PORTD,BUZZER
        CALL    DELAY_100MS

        BCF     PORTD,BUZZER
        CALL    DELAY_200MS

        RETURN

;===============================================================
; HOT BEEP
;===============================================================

HOT_BEEP_PATTERN:

        BSF     PORTD,BUZZER
        CALL    DELAY_100MS

        BCF     PORTD,BUZZER

        CALL    DELAY_100MS

        BSF     PORTD,BUZZER
        CALL    DELAY_100MS

        BCF     PORTD,BUZZER

        RETURN

;===============================================================
; MESSAGES
;===============================================================

MSG_EMBEDDED:

        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'B'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_MINI_PROJECT:

        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'J'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_NAME_PROJECT:

        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'F'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'J'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_TEMP_MONITOR:

        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'U'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'G'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_MICRO:

        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'L'
        CALL    LCD_DATA
        MOVLW   'L'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_PIC:

        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   '1'
        CALL    LCD_DATA
        MOVLW   '6'
        CALL    LCD_DATA
        MOVLW   'F'
        CALL    LCD_DATA
        MOVLW   '8'
        CALL    LCD_DATA
        MOVLW   '7'
        CALL    LCD_DATA
        MOVLW   '7'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        RETURN

;===============================================================
; PROJECT GUIDE
;===============================================================

MSG_PROJECT_GUIDE:

        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'J'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'G'
        CALL    LCD_DATA
        MOVLW   'U'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        RETURN

;===============================================================
; GUIDE NAME
; Prof. Vikas Salunkhe
;===============================================================

MSG_GUIDE_NAME:

        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'r'
        CALL    LCD_DATA
        MOVLW   'o'
        CALL    LCD_DATA
        MOVLW   'f'
        CALL    LCD_DATA
        MOVLW   '.'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'V'
        CALL    LCD_DATA
        MOVLW   'i'
        CALL    LCD_DATA
        MOVLW   'k'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   's'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   'l'
        CALL    LCD_DATA
        MOVLW   'u'
        CALL    LCD_DATA
        MOVLW   'n'
        CALL    LCD_DATA
        MOVLW   'k'
        CALL    LCD_DATA
        MOVLW   'h'
        CALL    LCD_DATA
        MOVLW   'e'
        CALL    LCD_DATA
        RETURN

;===============================================================
; DEVELOPED BY
;===============================================================

MSG_DEVELOPED:

        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'V'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'L'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'B'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_AKSHATA:

        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'k'
        CALL    LCD_DATA
        MOVLW   's'
        CALL    LCD_DATA
        MOVLW   'h'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   't'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   '.'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'h'
        CALL    LCD_DATA
        MOVLW   'e'
        CALL    LCD_DATA
        MOVLW   't'
        CALL    LCD_DATA
        MOVLW   'g'
        CALL    LCD_DATA
        MOVLW   'i'
        CALL    LCD_DATA
        MOVLW   'r'
        CALL    LCD_DATA
        MOVLW   'i'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_PRANAV:

        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   'r'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   'n'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   'v'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   '.'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   'l'
        CALL    LCD_DATA
        MOVLW   'a'
        CALL    LCD_DATA
        MOVLW   'v'
        CALL    LCD_DATA
        MOVLW   'e'
        CALL    LCD_DATA
        RETURN

;===============================================================
; SYSTEM READY
;===============================================================

MSG_SYSTEM:

        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_READY:

        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        RETURN

;===============================================================
; TEMP LABEL
;===============================================================

MSG_TEMP_LABEL:

        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   'P'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        RETURN

;===============================================================
; HUMIDITY LABEL
;===============================================================

MSG_HUM_LABEL:

        MOVLW   'H'
        CALL    LCD_DATA
        MOVLW   'U'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        RETURN

;===============================================================
; FAN LABEL
;===============================================================

MSG_FAN_LABEL:

        MOVLW   'F'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        RETURN

;===============================================================
; FAN ON
;===============================================================

MSG_FAN_ON:

        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        RETURN

;===============================================================
; FAN OFF
;===============================================================

MSG_FAN_OFF:

        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'F'
        CALL    LCD_DATA
        MOVLW   'F'
        CALL    LCD_DATA
        RETURN

;===============================================================
; STATUS
;===============================================================

MSG_STATUS:

        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'U'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   ':'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        RETURN

;===============================================================
; COLD
;===============================================================

MSG_COLD:

        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'L'
        CALL    LCD_DATA
        MOVLW   'D'
        CALL    LCD_DATA
        RETURN

;===============================================================
; HOT
;===============================================================

MSG_HOT:

        MOVLW   'H'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        RETURN

;===============================================================
; ACTIVE
;===============================================================

MSG_ACTIVE:

        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'Y'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'M'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'A'
        CALL    LCD_DATA
        MOVLW   'C'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   'I'
        CALL    LCD_DATA
        MOVLW   'V'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        RETURN

;===============================================================
; DHT ERROR MESSAGE
;===============================================================

MSG_DHT:

        MOVLW   'D'
        CALL    LCD_DATA
        MOVLW   'H'
        CALL    LCD_DATA
        MOVLW   'T'
        CALL    LCD_DATA
        MOVLW   '1'
        CALL    LCD_DATA
        MOVLW   '1'
        CALL    LCD_DATA
        MOVLW   ' '
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'N'
        CALL    LCD_DATA
        MOVLW   'S'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        RETURN

;---------------------------------------------------------------

MSG_ERROR:

        MOVLW   'E'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        MOVLW   'O'
        CALL    LCD_DATA
        MOVLW   'R'
        CALL    LCD_DATA
        RETURN

;===============================================================
; DELAY 1ms
;===============================================================

DELAY_1MS:

        MOVLW   .5
        MOVWF   DLY1

D1_LOOP:

        MOVLW   .200
        MOVWF   DLY2

D2_LOOP:

        NOP
        NOP

        DECFSZ  DLY2,F
        GOTO    D2_LOOP

        DECFSZ  DLY1,F
        GOTO    D1_LOOP

        RETURN

;===============================================================
; 5ms
;===============================================================

DELAY_5MS:

        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        RETURN

;===============================================================
; 20ms
;===============================================================

DELAY_20MS:

        CALL    DELAY_5MS
        CALL    DELAY_5MS
        CALL    DELAY_5MS
        CALL    DELAY_5MS
        RETURN

;===============================================================
; 35us
;===============================================================

DELAY_35US:

        MOVLW   .15
        MOVWF   DLY1

D35_LOOP:

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

        DECFSZ  DLY1,F
        GOTO    D35_LOOP

        RETURN

;===============================================================
; 40us
;===============================================================

DELAY_40US:

        MOVLW   .17
        MOVWF   DLY1

D40_LOOP:

        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

        DECFSZ  DLY1,F
        GOTO    D40_LOOP

        RETURN

;===============================================================
; 100ms
;===============================================================

DELAY_100MS:

        MOVLW   .10
        MOVWF   DLY3

D100_LOOP:

        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS
        CALL    DELAY_1MS

        DECFSZ  DLY3,F
        GOTO    D100_LOOP

        RETURN

;===============================================================
; 200ms
;===============================================================

DELAY_200MS:

        CALL    DELAY_100MS
        CALL    DELAY_100MS
        RETURN

;===============================================================
; 1500ms
;===============================================================

DELAY_1500MS:

        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS

        RETURN

;===============================================================
; 2000ms
;===============================================================

DELAY_2000MS:

        CALL    DELAY_1500MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        RETURN

;===============================================================
; 2500ms
;===============================================================

DELAY_2500MS:

        CALL    DELAY_2000MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        CALL    DELAY_100MS
        RETURN

        END
