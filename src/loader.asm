; Move stack out of the data range
LD SP, $6000

; Load the image
LD DE, ($5CF4)   ; restore the FDD head position
LD BC, $0F05     ; load 15 sectors of compressed image
LD HL, $9C40     ; destination address (40000)
CALL $3D13
CALL $9C40       ; decompress the image

; Load the data
LD DE, ($5CF4)   ; restore the FDD head position again
LD BC, $A005     ; load 160 sectors of data
LD HL, $6000     ; destination address (24576)
CALL $3D13

; Switch to another memory page
LD BC,$7FFD
LD A,$11
OUT (C),A
PUSH BC

; Load the music
LD DE, ($5CF4)   ; restore the FDD head position
LD BC, $1805     ; load 24 sectors of data
LD HL, $C000     ; destination address (49152)
CALL $3D13

; Switch memory page back
POP BC
LD A,$10
OUT (C),A
JP $7530
