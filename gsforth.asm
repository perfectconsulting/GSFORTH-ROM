              .CR   6502
              .LF   gsforth.lst
              .TF   gsforth.rom,BIN

HDLR_STK_UNDERFLOW .MA HANDLER
]1_STK_UNDERFLOW
              LDA #ERR_STKUDR
              JMP (USER_ERROR)
              .EM
           
HDLR_STK_OVERFLOW  .MA HANDLER
]1_STK_OVERFLOW
              LDA #ERR_STKOVR 
              JMP (USER_ERROR)
              .EM 
                            
CHK_STK_EMPTY .MA   HANDLER
              CPX #STK_BOT
              BEQ ]1_STK_UNDERFLOW        
              .EM
              
CHK_STK_FULL  .MA   HANDLER
              CPX #STK_TOP
              BEQ ]1_STK_OVERFLOW
              .EM
              
CHK_STK_MIN_1 .MA   HANDLER
              CPX #STK_BOT
              BCS ]1_STK_UNDERFLOW
              .EM         
              
CHK_STK_MIN_2 .MA   HANDLER
              CPX #STK_BOT-2
              BCS ]1_STK_UNDERFLOW
              .EM         

CHK_STK_MIN_3 .MA   HANDLER
              CPX #STK_BOT-4
              BCS ]1_STK_UNDERFLOW
              .EM         
              
CHK_STK_MIN_4 .MA   HANDLER
              CPX #STK_BOT-6
              BCS ]1_STK_UNDERFLOW
              .EM
              
HDLR_ASTK_UNDERFLOW .MA HANDLER
]1_ASTK_UNDERFLOW
              LDA #ERR_ASTKUDR
              JMP (USER_ERROR)
              .EM
           
HDLR_ASTK_OVERFLOW  .MA HANDLER
]1_ASTK_OVERFLOW
              LDA #ERR_ASTKOVR 
              JMP (USER_ERROR)
              .EM 
                            
CHK_ASTK_EMPTY .MA   HANDLER
              CPX #ASTK_BOT
              BEQ ]1_ASTK_UNDERFLOW        
              .EM
              
CHK_ASTK_FULL  .MA   HANDLER
              CPX #ASTK_TOP
              BEQ ]1_ASTK_OVERFLOW
              .EM
              
CHK_ASTK_MIN_1 .MA   HANDLER
              CPX #ASTK_BOT
              BCS ]1_ASTK_UNDERFLOW
              .EM         
              
CHK_ASTK_MIN_2 .MA   HANDLER
              CPX #ASTK_BOT-2
              BCS ]1_ASTK_UNDERFLOW
              .EM         

CHK_ASTK_MIN_3 .MA   HANDLER
              CPX #ASTK_BOT-4
              BCS ]1_ASTK_UNDERFLOW
              .EM         
              
CHK_ASTK_MIN_4 .MA   HANDLER
              CPX #ASTK_BOT-6
              BCS ]1_ASTK_UNDERFLOW
              .EM    
              
CHK_ASTK_FRE_2 .MA   HANDLER                        
              CPX #ASTK_TOP+2
              BCC ]1_ASTK_OVERFLOW
              .EM
              
LITERAL       .MA   VALUE
              JSR LIT_CFA
              .DW ]1
              .EM              
                         
OSRDCH        .EQ   $FFE0         
OSNEWL        .EQ   $FFE7
OSWRCH        .EQ   $FFEE   
OSBYTE        .EQ   $FFF4  

STK_TOP       .EQ   $00
STK_BOT       .EQ   $4E
ASTK_TOP      .EQ   $4E
ASTK_BOT      .EQ   $6E

; ZERO PAGE MEMROY
STK           .EQ   STK_TOP 
ASTK          .EQ   ASTK_TOP
; ZERO PAGE REGISTERS
  
ASP           .EQ   $70
SCRATCH1      .EQ   ASP+1
SCRATCH2      .EQ   SCRATCH1+1
SCRATCH3      .EQ   SCRATCH2+1

; ERROR CODES
ERR_STKOVR    .EQ   $01
ERR_STKUDR    .EQ   $02
ERR_ASTKOVR   .EQ   $03
ERR_ASTKUDR   .EQ   $04
ERR_MISLEX    .EQ   $05
ERR_DIVZERO   .EQ   $06
ERR_UNIQUE    .EQ   $07
ERR_NOMEM     .EQ   $08
ERR_FINISH    .EQ   $09
ERR_EXEC      .EQ   $0A
ERR_COMP      .EQ   $0B
ERR_LOAD      .EQ   $0C
ERR_PAIR      .EQ   $0D
ERR_NUL       .EQ   $0E
ERR_FENCE     .EQ   $0F
ERR_FOUND     .EQ   $10


; MEMORY MAP
ORIGIN        .EQ   $1900     
USER_COLD     .EQ   ORIGIN
USER_WARM     .EQ   USER_COLD + 3   
USER_ERROR    .EQ   USER_WARM + 3
FIRST         .EQ   $1A00

          .OR   $8000  
                 
          JMP ROM_LANGUAGE_ENTRY
          JMP ROM_SERVICE_ENTRY
          .DB	$E2           
          .DB ROM_HEADER_COPYRIGHT
ROM_HEADER_VERSION                   
          .DB	$02
ROM_HEADER_TITLE_STRING        
          .DB 'GSFORTH'
          .DB $00
ROM_HEADER_VERSION_STRING        
          .DB '2.00'
ROM_HEADER_COPYRIGHT
          .DB $00
ROM_HEADER_COPYRIFHT_STRING        
          .DB '(C) Steven James 2015', $0
          .DW $8000
          .DW $0000
ROM_LANGUAGE_ENTRY
          CMP #$01
          BEQ ROM_LANGUAGE_START
          RTS
ROM_LANGUAGE_START
          CLI
          JMP BOOT    

ROM_SERVICE_ENTRY 
          CMP #$04
          BEQ ROM_SERVICE_COMMAND
          CMP #$09
          BEQ ROM_SERVICE_HELP
          RTS
ROM_SERVICE_COMMAND
          PHA
          TYA
          PHA        
          LDA ($F2), Y 
          CMP #'G'
          BNE ROM_SERVICE_COMMAND_EXIT 
          INY
          LDA ($F2), Y
          CMP #'S'
          BNE ROM_SERVICE_COMMAND_EXIT 
          INY
          LDA ($F2), Y               
          CMP #'F'
          BNE ROM_SERVICE_COMMAND_EXIT
          INY
          LDA ($F2), Y                                     
          CMP #'O'
          BNE ROM_SERVICE_COMMAND_EXIT 
          INY
          LDA ($F2), Y               
          CMP #'R'
          BNE ROM_SERVICE_COMMAND_EXIT
          INY
          LDA ($F2), Y               
          CMP #'T'
          BNE ROM_SERVICE_COMMAND_EXIT 
          INY
          LDA ($F2), Y               
          CMP #'H'
          BNE ROM_SERVICE_COMMAND_EXIT        
          INY
          LDA ($F2), Y               
          CMP #$0D
          BNE ROM_SERVICE_COMMAND_EXIT
          LDA #$8E
          JSR OSBYTE                
ROM_SERVICE_COMMAND_EXIT               
          PLA          
          TAY
          PLA
          RTS         
                
ROM_SERVICE_HELP
          PHA
          TYA
          PHA
          JSR OSNEWL
          LDA #ROM_HEADER_TITLE_STRING
          STA $12
          JSR CORE_WRITESTRING
          LDA #$20
          JSR OSWRCH
          LDA #ROM_HEADER_VERSION_STRING
          STA $12
          JSR CORE_WRITESTRING
          JSR OSNEWL
ROM_SERVICE_HELP_EXIT        
          PLA          
          TAY
          PLA
          RTS        
CORE_WRITESTRING
          LDA #$80
          STA $13
          LDY #$00
CORE_WRITESTRING_LOOP        
          LDA ($12),Y
          BEQ CORE_WRITESTRING_EXIT
          JSR OSWRCH
          INY
          BNE CORE_WRITESTRING_LOOP
CORE_WRITESTRING_EXIT
          RTS        
				  
				  ; back stop 
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
				  .DB $FF,$FF 
          

USER_DP       .EQ   $09
USER_STATE    .EQ   USER_DP+2  
USER_TIB      .EQ   USER_STATE+2
USER_IN       .EQ   USER_TIB+2
USER_BASE     .EQ   USER_IN+2
USER_CURRENT  .EQ   USER_BASE+2
USER_CONTEXT  .EQ   USER_CURRENT+2
USER_LATEST   .EQ   USER_CONTEXT+2
USER_WIDTH    .EQ   USER_LATEST+2
USER_OUT      .EQ   USER_WIDTH+2
USER_DPL      .EQ   USER_OUT+2
USER_BLK      .EQ   USER_DPL+2
USER_SCR      .EQ   USER_BLK+2
USER_WARNING  .EQ   USER_SCR+2
USER_LIMIT    .EQ   USER_WARNING+2
USER_CSP      .EQ   USER_LIMIT+2
USER_HLD      .EQ   USER_CSP+2
USER_VOCLINK  .EQ   USER_HLD+2
USER_CL       .EQ   USER_VOCLINK+2
USER_FENCE    .EQ   USER_CL+2
USER_BBUF     .EQ   USER_FENCE+2
USER_HBUF     .EQ   USER_BBUF+"
USER_CHANNEL  .EQ   USER_HBUF+"
USER_USE      .EQ   USER_CHANNEL+2
USER_PREV     .EQ   USER_USE+2
USER_FL       .EQ   USER_PREV+2

ROM_ORIGIN_SIZE .EQ 69         		   
ROM_ORIGIN
ROM_COLD_VCT
          JMP BOOT                ; COLD START VECTOR
ROM_WARM_VCT                    
          JMP $0000               ; WARM START VECTOR
ROM_ERROR_VCT          
          JMP $0000               ; ERROR VECTOR
          
          .DW FIRST     ; DP
          .DW $0000     ; STATE
          .DW $0000     ; TIB
          .DW $0000     ; IN 
          .DW $000A     ; BASE
          .DW $0000     ; CURRENT
          .DW $0000     ; CONTEXT
          .DW $0000     ; LATEST
          .DW $0000     ; WIDTH
          .DW $0000     ; OUT
          .DW $0000     ; DPL
          .DW $5000     ; BLK
          .DW $0000     ; SCR
          .DW $0000     ; WARNING
          .DW $0000     ; LIMIT
          .DW $0000     ; CSP
          .DW $0000     ; HLD
          .DW $0000     ; VOC-LINK
          .DW $0000     ; C/L
          .DW $0000     ; FENCE
          .DW $0000     ; B/BUF
          .DW $0000     ; #BUF
          .DW $0000     ; CHANNEL
          .DW $0000     ; USE
          .DW $0000     ; PREV
          .DW $0000     ; F/L
          .DW $FFFF
          .DW $FFFF
          .DW $FFFF
          .DW $FFFF
          
                    
          
DROP_NFA ; drop
          .DB $04^$80,'dro',$70^$80
          .DW $0000
DROP_CFA 
          >CHK_STK_EMPTY  DROP              
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW DROP

DUP_NFA ; dup
          .DB $03^$80,'du',$70^$80
          .DW DROP_NFA
DUP_CFA
          >CHK_STK_EMPTY DUP
          >CHK_STK_FULL DUP
          DEX
          DEX
          LDA STK+4,X
          STA STK+2,X
          LDA STK+3,X
          STA STK+1,X
          RTS
          >HDLR_STK_UNDERFLOW DUP
          >HDLR_STK_OVERFLOW DUP

QDUP_NFA ; ?dup
          .DB $04^$80,'?du',$70^$80
          .DW DUP_NFA       
QDUP_CFA
          >CHK_STK_EMPTY DUP
          >CHK_STK_FULL DUP
          LDA STK+1,X
          BNE QDUP_DUP
          LDA STK+2,X
          BNE QDUP_DUP
          RTS
QDUP_DUP          
          DEX
          DEX
          LDA STK+4,X
          STA STK+2,X
          LDA STK+3,X
          STA STK+1,X
          RTS
          >HDLR_STK_UNDERFLOW QDUP
          >HDLR_STK_OVERFLOW QDUP
          
SWAP_NFA ; swap
          .DB $04^$80,'swa',$70^$80          
          .DW QDUP_NFA
SWAP_CFA
          >CHK_STK_MIN_1 SWAP
          LDA STK+4,X
          TAY
          LDA STK+2,X
          STA STK+4,X
          TYA
          STA STK+2,X
          LDA STK+3,X
          TAY
          LDA STK+1,X
          STA STK+3,X
          TYA
          STA STK+1,X
          RTS
          >HDLR_STK_UNDERFLOW SWAP
          
ROT_NFA ; rot
          .DB $03^$80,'ro',$74^$80          
          .DW SWAP_NFA
ROT_CFA
          >CHK_STK_MIN_3 ROT
          LDA STK+5,X
          STA SCRATCH1
          LDA STK+6,X
          STA SCRATCH2
          LDA STK+3,X
          STA STK+5,X
          LDA STK+4,X
          STA STK+6,X
          LDA STK+1,X
          STA STK+3,X
          LDA STK+2,X
          STA STK+4,X
          LDA SCRATCH1
          STA STK+1,X
          LDA SCRATCH2
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW ROT
          
OVER_NFA
          .db $04^$80,'ove',$72^$80
          .DW ROT_NFA
OVER_CFA
          >CHK_STK_MIN_2 OVER
          >CHK_STK_FULL OVER
          DEX
          DEX
          LDA STK+5,X
          TAY
          LDA STK+6,X
          STA STK+2,X
          TYA
          STA STK+1,X    
          RTS
          >HDLR_STK_UNDERFLOW OVER
          >HDLR_STK_OVERFLOW OVER
                                                           
SPSTORE_NFA ; sp!
          .DB $03^$80,'sp', $21^$80 
          .DW ROT_NFA
SPSTORE_CFA        
          LDX #STK_BOT      
          RTS
          
ASPSTORE_NFA ; asp!
          .DB $04^$80, 'asp', $21^$80 
          .DW ASPSTORE_NFA
ASPSTORE_CFA
          LDA #ASTK_BOT
          STA ASP    
          RTS            
          
LIT_NFA ; lit
          .DB $03^$80,'li',$74^$80
          .DW ASPSTORE_NFA
LIT_CFA
          >CHK_STK_FULL LIT
          CLC
          PLA
          ADC #$01
          STA SCRATCH1
          PLA
          ADC #$00
          STA SCRATCH2
          LDY #$00
          DEX
          LDA (SCRATCH1),Y
          STA STK,X
          INY
          DEX
          LDA (SCRATCH1),Y
          STA STK+2,X
          CLC
          LDA SCRATCH1
          ADC #$01
          TAY
          LDA SCRATCH2
          ADC #$00
          PHA
          TYA
          PHA
          RTS
          >HDLR_STK_OVERFLOW LIT
          
SLIT_NFA ; $lit
          .DB $04^$80,'$li',$74^$80
          .DW LIT_NFA
SLIT_CFA
          >CHK_STK_FULL SLIT          
          CLC
          PLA
          ADC #$01
          STA SCRATCH1
          PLA
          ADC #$00 
          STA SCRATCH2
          STA STK,X
          DEX
          LDA SCRATCH1
          STA STK,X
          DEX
          CLC
          LDY #$00
          LDA (SCRATCH1),Y
          ADC SCRATCH1
          TAY
          LDA SCRATCH2
          ADC #$00
          PHA
          TYA
          PHA
          RTS
          >HDLR_STK_OVERFLOW SLIT          
          
FETCH_NFA ; @
          .DB $01^$80,$40^$80
          .DW SLIT_NFA
FETCH_CFA
          >CHK_STK_EMPTY FETCH
          LDA (STK+1,X)
          TAY
          INC STK+1,X
          BNE FETCH_NO_INC
          INC STK+2,X
FETCH_NO_INC
          LDA (STK+1,X)
          STA STK+2,X
          TYA
          STA STK+1,X
          RTS
          >HDLR_STK_UNDERFLOW FETCH
          
STORE_NFA ; !
          .DB $01^$80,$21^$80
          .DW FETCH_NFA          
STORE_CFA
          >CHK_STK_MIN_2 STORE
          LDA STK+3,X
          STA (STK+1,X)
          INC STK+1,X
          BNE STORE_NO_INC
          INC STK+2,X
STORE_NO_INC
          LDA STK+4,X
          STA (STK+1,X)
          INX
          INX
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW STORE          
                
CFETCH_NFA ; c@
          .DB $02^$80,'c',$40^$80
          .DW STORE_NFA                
CFETCH_CFA
          >CHK_STK_EMPTY CFETCH
          LDA (STK+1,X)
          STA STK+1,X
          LDA #$00
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW CFETCH
          
CSTORE_NFA ; c!
          .DB $02^$80,'c',$21^$80
          .DW CFETCH_NFA
CSTORE_CFA
          >CHK_STK_MIN_2 CSTORE   
          LDA STK+3,X
          STA (STK+1,X)
          INX
          INX
          INX
          INX 
          RTS                    
          >HDLR_STK_UNDERFLOW CSTORE
          
PSTORE_NFA ; +!
          .DB $02^$80,'+',$21^$80
          .DW CSTORE_NFA
PSTORE_CFA
          >CHK_STK_MIN_2 PSTORE
          CLC
          LDA (STK+1,X)
          ADC STK+3,X
          STA (STK+1,X)
          INC STK+1,X
          BNE PSTORE_NOINC
          INC STK+2,X
PSTORE_NOINC
          LDA (STK+1,X)
          ADC STK+4,X
          STA (STK+1,X)
          INX
          INX
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW PSTORE
          
PLUS_NFA ; +
          .DB $1^$80,$2B^$80
          .DW PSTORE_NFA
PLUS_CFA
          >CHK_STK_MIN_2 PLUS
          CLC
          LDA STK+1,X
          ADC STK+3,X
          STA STK+3,X
          LDA STK+2,X
          ADC STK+4,X
          STA STK+2,X
          INX
          INX
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW PLUS
          
DPLUS_NFA ; d+
          .DB $02^$80, 'd', $2B^$80
          .DW PLUS_CFA
DPLUS_CFA
          >CHK_STK_MIN_4 DPLUS
          CLC
          LDA STK+3,X
          ADC STK+7,X
          STA STK+7,X
          LDA STK+4,X
          ADC STK+8,X
          STA STK+8,X
          LDA STK+1,X
          ADC STK+5,X
          STA STK+5,X
          LDA STK+2,X
          ADC STK+6,X
          STA STK+6,X
          INX
          INX
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW DPLUS
          
UTIMES_NFA ; u*
          .DB $02^$80,'u',$2A^$80
          .DW DPLUS_NFA
UTIMES_CFA
          >CHK_STK_MIN_2 UTIMES
          LDA STK+3,X
          STA SCRATCH1
          LDA STK+4,X
          STA SCRATCH2
          LDA #$00
          STA STK+3,X
          STA STK+4,X
          LDY #$10
UTIMES_ROTATE
          ASL STK+3,X
          ROL STK+4,X
          ROL STK+1,X
          ROL STK+2,X
          BCC UTIMES_MODIFY
          CLC
          LDA SCRATCH1
          ADC STK+3,X
          STA STK+3,X
          LDA SCRATCH2
          ADC STK+4,X
          STA STK+4,X
          BCC UTIMES_MODIFY
          INC STK+1,X
          BNE UTIMES_MODIFY
          INC STK+2,X
UTIMES_MODIFY
          DEY
          BNE UTIMES_ROTATE
          RTS
          >HDLR_STK_UNDERFLOW UTIMES
                                    
UDIVIDE_NFA ; u/
          .DB $02^$80, 'u', $2F^$80
          .DW UTIMES_NFA
UDIVIDE_CFA
          >CHK_STK_MIN_3 UDIVIDE
          LDA STK+1,X
          BNE UDIVIDE_NONZERO
          LDA STK+2,X
          BEQ UDIVIDE_ZERO
UDIVIDE_NONZERO
          LDA STK+5,X
          LDY STK+3,X
          STY STK+5,X
          ASL A
          STA STK+3,X
          LDA STK+6,X
          LDY STK+4,X
          STY STK+6,X
          ROL A
          STA STK+4,X
          LDA #$10
          STA SCRATCH1
UDIVIDE_ROTATE
          ROL STK+5,X 
          ROL STK+6,X
          SEC
          LDA STK+5,X
          SBC STK+1,X
          TAY
          LDA STK+6,X
          SBC STK+2,X
          BCC UDIVIDE_MODIFY
          STY STK+5,X
          STA STK+6,X
UDIVIDE_MODIFY
          ROL STK+3,X
          ROL STK+4,X
          DEC SCRATCH1
          BNE UDIVIDE_ROTATE
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW UDIVIDE         
UDIVIDE_ZERO
          LDA #ERR_DIVZERO
          JMP (USER_ERROR)     
          
MINUS_NFA ; minus
          .DB $05^$80, 'minu',$73^$80
          .DB UDIVIDE_NFA
MINUS_CFA
          >CHK_STK_EMPTY MINUS
          CLC
          LDA STK+1,X
          EOR #$FF
          ADC #$01
          STA STK+1,X
          LDA STK+2,X
          EOR #$FF
          ADC #$00
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW MINUS
          
DMINUS_NFA ; dminus
          .DB $06^$80,'dminu', $73^$80
          .DW MINUS_NFA
DMINUS_CFA
          >CHK_STK_MIN_2 DMINUS
          CLC
          LDA STK+3,X
          EOR #$FF
          ADC #$01
          STA STK+3,X
          LDA STK+4,X
          EOR #$FF
          ADC #$00
          STA STK+4,X
          LDA STK+1,X
          EOR #$FF
          ADC #$00
          STA STK+1,X
          LDA STK+2,X
          EOR #$FF
          ADC #$00
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW DMINUS              
          
ONEPLUS_NFA ; 1+
          .DB $02^$80,'1',$2B^$80
          .DW DMINUS_NFA
ONEPLUS_CFA
          >CHK_STK_EMPTY ONEPLUS
          INC STK+1,X
          BNE ONEPLUS_NOOVERFLOW
          INC STK+2,X
ONEPLUS_NOOVERFLOW
          RTS     
          >HDLR_STK_UNDERFLOW ONEPLUS
          
ONEMINUS_NFA ; 1-
          .DB $02^$80,'1',$2D^$80
          .DW ONEPLUS_NFA
ONEMINUS_CFA
          >CHK_STK_EMPTY ONEMINUS
          LDA STK+1,X
          BNE ONEMINUS_NOOVERFLOW
          DEC STK+2,X
ONEMINUS_NOOVERFLOW       
          DEC STK+1,X
          RTS
          >HDLR_STK_UNDERFLOW ONEMINUS
          
TWOPLUS_NFA ; 2+
          .DB $02^$80,'2',$2B^$80
          .DW ONEMINUS_NFA
TWOPLUS_CFA
          >CHK_STK_EMPTY TWOPLUS
          CLC
          LDA STK,X
          ADC #$02
          STA STK+1,X
          BCC TWOPLUS_END
          INC STK+2,X
TWOPLUS_END
          RTS
          >HDLR_STK_UNDERFLOW TWOPLUS
          
TWOMINUS_NFA ; 2-
          .DB $02^$80,'2',$2D^$80
          .DW TWOPLUS_NFA
TWOMINUS_CFA
          >CHK_STK_EMPTY TWOMINUS
          SEC
          LDA STK+1,X
          SBC #$02
          STA STK+1,X
          BCS TWOMINUS_END
          DEC STK+2,X
TWOMINUS_END
          RTS
          >HDLR_STK_UNDERFLOW TWOMINUS
                                      
MIN_NFA ; min
          .DB $03^$80,'mi',$6E^$80
          .DW TWOMINUS_NFA
MIN_CFA
          >CHK_STK_MIN_2 MIN
          SEC
          LDA STK+1,X
          SBC STK+3,X
          LDA STK+2,X
          SBC STK+4,X
          BPL MIN_END
          LDA STK+1,X
          STA STK+3,X
          LDA STK+2,X
          STA STK+4,X
MIN_END
          INX
          INX
          RTS  
          >HDLR_STK_UNDERFLOW MIN
          
MAX_NFA ; max
          .DB $03^$80,'ma',$78^$80
          .DW MIN_NFA
MAX_CFA      
          >CHK_STK_MIN_2 MAX
          SEC
          LDA STK+3,X
          SBC STK+1,X
          LDA STK+4,X
          SBC STK+2,X
          BPL MAX_END
          LDA STK+1,X
          STA STK+3,X
          LDA STK+2,X
          STA STK+4,X
MAX_END
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW MAX
         
PLUSMINUS_NFA ; +-
          .DB $02^$80,'+', $2D^$80
          .DW MAX_CFA
PLUSMINUS_CFA
          >CHK_STK_MIN_2 PLUSMINUS
          LDA STK+2,X
          ASL A
          BCC PLUSMINUS_END
          CLC
          LDA STK+3,X
          EOR #$FF
          ADC #$01
          STA STK+3,X
          LDA STK+4,X
          EOR #$FF
          ADC #$00
          STA STK+4,X
PLUSMINUS_END
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW PLUSMINUS
          
DPLUSMINUS_NFA ; d+-
          .DB $03^$80,'d+', $2D^$80
          .DW PLUSMINUS_NFA 
DPLUSMINUS_CFA
          >CHK_STK_MIN_3 DPLUSMINUS
          LDA STK+2,X
          ASL A
          BCC DPLUSMINUS_END
          CLC
          LDA STK+5,X
          EOR #$FF
          ADC #$01
          STA STK+5,X
          LDA STK+6,X
          EOR #$FF
          ADC #$00
          STA STK+6,X
          LDA STK+3,X
          EOR #$FF
          ADC #$00
          STA STK+3,X
          LDA STK+4,X
          EOR #$FF
          ADC #$00
          STA STK+4,X
DPLUSMINUS_END
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW DPLUSMINUS
          
PLUSORIGIN_NFA ; +origin
          .DB $07^$80,'+origi',$6E^$80
          .DW DPLUSMINUS_NFA
PLUSORIGIN_CFA
          >CHK_STK_EMPTY PLUSORIGIN
          CPX #STK_BOT
          BEQ PLUSORIGIN_STK_UNDERFLOW 
          CLC
          LDA STK+1,X
          ADC #ORIGIN\256 
          STA STK+1,X
          LDA STK+2,X
          ADC #ORIGIN/256
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW PLUSORIGIN
   
AND_NFA ; and
          .DB $03^$80,'an',$64^$80
          .DW PLUSORIGIN_NFA
AND_CFA
          >CHK_STK_MIN_2 AND
          LDA STK+1,X
          AND STK+3,X
          STA STK+3,X
          LDA STK+2,X
          AND STK+4,X
          STA STK+4,X
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW AND
          
OR_NFA ; or
          .DB $02^$80,'o',$72^$80
          .DW AND_NFA
OR_CFA
          >CHK_STK_MIN_2 OR
          LDA STK+1,X
          ORA STK+3,X
          STA STK+3,X
          LDA STK+2,X
          ORA STK+4,X
          STA STK+4,X
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW OR
  
XOR_NFA ; xor
          .DB $03^$80,'xo',$72^$80
          .DW OR_NFA
XOR_CFA
          >CHK_STK_MIN_2 XOR
          LDA STK+1,X
          EOR STK+3,X
          STA STK+3,X
          LDA STK+2,X
          EOR STK+4,X
          STA STK+4,X
          INX
          INX
          RTS      
          >HDLR_STK_UNDERFLOW XOR
        
NOT_NFA ; not
          .DB $03^$80,'n',$74^$80  
          .DW XOR_NFA
NOT_CFA
          >CHK_STK_EMPTY NOT
          LDA STK+1,X
          EOR #$FF
          STA STK+1,X
          LDA STK+2,X
          EOR #$FF
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW NOT
        
TOGGLE_NFA ; toggle
          .DB $06^$80,'toggl',$65^$80
          .DW NOT_NFA
TOGGLE_CFA
          >CHK_STK_MIN_2 TOGGLE
          LDA (STK+3,X)
          EOR STK+1,X
          STA (STK+3,X)
          INX
          INX
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW TOGGLE
        
EQUAL_NFA ; =
          .DB $01^$80,$3D^$80
          .DW TOGGLE_NFA
EQUAL_CFA
          >CHK_STK_MIN_2 EQUAL
          LDA STK+1,X
          CMP STK+3,X
          BNE EQUAL_FALSE
          LDA STK+2,X
          CMP STK+4,X
          BNE EQUAL_FALSE
          LDA #$FF
          STA STK+3,X
          STA STK+4,X
          INX
          INX
          RTS
EQUAL_FALSE
          LDA #$00
          STA STK+3,X
          STA STK+4,X
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW EQUAL
   
GREATER_NFA ; >
          .DB $01^$80,$3E^$80
          .DW EQUAL_NFA
GREATER_CFA
          >CHK_STK_MIN_2 GREATER
          SEC
          LDA STK+1,X
          SBC STK+3,X
          LDA STK+2,X
          SBC STK+4,X
          BPL GREATER_FALSE
          LDA #$FF
          STA STK+4,X
          STA STK+3,X
          INX
          INX
          RTS
GREATER_FALSE
          LDA #$00
          STA STK+4,X
          STA STK+3,X
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW GREATER
        
LESS_NFA ; <
          .DB $01^$80,$3C^$80
          .DW GREATER_NFA
LESS_CFA
          >CHK_STK_MIN_2 LESS
          SEC
          LDA STK+3,X
          SBC STK+1,X
          LDA STK+4,X
          SBC STK+2,X
          BPL LESS_FALSE
          LDA #$FF
          STA STK+4,X
          STA STK+3,X
          INX
          INX
          RTS
LESS_FALSE     
          LDA #$00
          STA STK+4,X
          STA STK+3,X
          INX
          INX
          RTS            
          >HDLR_STK_UNDERFLOW LESS
        
ZEROGREATER_NFA ; 0>
          .DB $02^$80,'0', $3E^$80
          .DW LESS_NFA
ZEROGREATER_CFA
          >CHK_STK_EMPTY ZEROGREATER
          LDA STK+2,X
          BMI ZEROGREATERFALSE
          LDA STK+1,X
          BNE ZEROGREATERTRUE
ZEROGREATERFALSE
          LDA #$00
          STA STK+1,X
          STA STK+2,X
          RTS
ZEROGREATERTRUE
          LDA #$FF
          STA STK+1,X
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW ZEROGREATER                  
                 
ZEROLESS_NFA ; 0<
          .DB $02^$80,'0',$3C^$80
          .DW ZEROGREATER_NFA
ZEROLESS_CFA
          >CHK_STK_EMPTY ZEROLESS
          LDA STK+2,X
          ASL A
          BCS ZEROLESS_TRUE
          LDA #$00
          STA STK+1,X
          STA STK+2,X
          RTS
ZEROLESS_TRUE
          LDA #$FF
          STA STK+1,X
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW ZEROLESS     
        
ZEROEQUALS_NFA ; 0=
          .DB $02^$80,'0', $3D^$80
          .DW ZEROLESS_NFA
ZEROEQUALS_CFA
          >CHK_STK_EMPTY ZEROEQUALS
          LDA STK+1,X
          ORA STK+2,X
          BEQ ZEROEQUALS_TRUE
          LDA #$00
          STA STK+1,X
          STA STK+2,X
          RTS
ZEROEQUALS_TRUE
          LDA #$FF
          STA STK+1,X
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW ZEROEQUALS    
        
UGREATER_NFA ; u>
          .DB $02^$80, 'u', $3E^$80
          .DW ZEROEQUALS_NFA
UGRATER_CFA
          >CHK_STK_MIN_2 UGREATER
          LDA STK+4,X
          CMP STK+2,X
          BCC UGREATER_FALSE
          BNE UGREATER_TRUE
          LDA STK+3,X
          CMP STK+1,X
          BCC UGREATER_FALSE
          BEQ UGREATER_FALSE
UGREATER_TRUE
          INX
          INX
          LDA #$FF
          STA STK+1,X
          STA STK+2,X
          RTS
UGREATER_FALSE
          INX
          INX
          LDA #$00
          STA STK+1,X
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW UGREATER
  
ULESS_NFA ; u<
          .DB $02^$80,'u',$3C^$80
          .DW UGREATER_NFA
ULESS_CFA
          >CHK_STK_MIN_2 ULESS
          LDA STK+2,X
          CMP STK+4,X
          BCC ULESS_FALSE
          BNE ULESS_TRUE
          LDA STK+1,X
          CMP STK+3,X
          BCC ULESS_FALSE
          BEQ ULESS_FALSE
ULESS_TRUE
          INX
          INX
          LDA #$FF
          STA STK+1,X
          STA STK+2,X
          RTS
ULESS_FALSE
          INX
          INX
          LDA #$00
          STA STK+1,X
          STA STK+2,X
          RTS
          >HDLR_STK_UNDERFLOW ULESS 
                                                
QBRANCH_NFA ; ?branch
          .DB $07^$80,'?branc',$68^$80
          .DW ULESS_NFA
QBRANCH_CFA
          >CHK_STK_EMPTY QBRANCH
          LDY STK+2,X
          BNE QBRANCH_END
          LDY STK+1,X
QBRANCH_END
          INX
          INX
          TYA
          RTS
          >HDLR_STK_UNDERFLOW QBRANCH    
   
BDO_NFA ; (do)
          .DB $04^$80,'(do',$29^$80
          .DW QBRANCH_NFA
BDO_CFA
          >CHK_STK_MIN_2 BDO
          TXA
          TAY
          LDA STK+1,X
          STA SCRATCH1
          LDA STK+2,X
          STA SCRATCH2
          LDA STK+3,X
          STA SCRATCH3
          LDA STK+4,X
          LDX ASP
          >CHK_ASTK_FRE_2 BDO
          DEX
          DEX
          DEX
          DEX
          STA ASTK+4,X
          LDA SCRATCH3
          STA ASTK+3,X
          LDA SCRATCH2
          STA ASTK+2,X
          LDA SCRATCH1
          STA ASTK+1,X
          STX ASP
          TYA
          TAX
          INX
          INX
          INX
          INX
          RTS
          >HDLR_STK_UNDERFLOW BDO
          >HDLR_ASTK_OVERFLOW BDO
                      
BLOOP_NFA ; (loop)
          .DB $06^$80,'(loop',$29^$80
          .DW BDO_NFA
BLOOP_CFA
          TXA
          TAY
          LDX ASP
          >CHK_ASTK_MIN_2 BLOOP
          INC ASTK+1,X
          BNE BLOOP_TEST
          INC ASTK+2,X
BLOOP_TEST
          CLC
          LDA ASTK+3,X
          SBC ASTK+1,X
          LDA ASTK+4,X
          SBC ASTK+2,X
          ASL A
          TYA
          TAX
          RTS
          >HDLR_ASTK_UNDERFLOW BLOOP
        
BPLUSLOOP_NFA ; (+loop)
          .DB $07^$80,'(loop+',$29^$80
          .DW BLOOP_NFA
BPLUSLOOP_CFA
          >CHK_STK_EMPTY BPLUSLOOP
          LDA STK+2,X
          TAY
          LDA STK+1,X
          INX
          INX
          STX SCRATCH1
          LDX ASP
          >CHK_ASTK_MIN_2 BPLUSLOOP
          CLC
          ADC ASTK+1,X
          STA ASTK+1,X
          TYA
          ADC ASTK+2,X
          STA ASTK+2,X
          TYA
          BMI BPLUSLOOP_NEGATIVE
          CLC
          LDA ASTK+3,X
          SBC ASTK+1,X
          LDA ASTK+4,X
          SBC ASTK+2,X
          ASL A
          LDX SCRATCH1
          RTS
BPLUSLOOP_NEGATIVE
        SEC
        LDA ASTK+1,X
        SBC ASTK+3,X
        LDA ASTK+2,X
        SBC ASTK+4,X
        ASL A
        LDX SCRATCH1
        RTS
        >HDLR_STK_UNDERFLOW BPLUSLOOP
        >HDLR_ASTK_UNDERFLOW BPLUSLOOP
        
SZERO_NFA ; s0
        .DB $02^$80,'s',$30^$80
        .DW BPLUSLOOP_NFA
SZERO_CFA
        >LITERAL STK_BOT
        RTS
                 
AZERO_NFA ; a0
        .DB $02^$80,'a',$30^$80
        .DW SZERO_NFA
AZERO_CFA
        >LITERAL ASTK_BOT
        RTS
        
DP_NFA ; dp
        .DB $02^$80,'d', $70^$80
        .DW AZERO_NFA
DP_CFA
        >LITERAL USER_DP
        JSR PLUSORIGIN_CFA
        RTS
        
STATE_NFA ; state
        .DB $05^$80,'stat', $65^$80
        .DW AZERO_NFA
STATE_CFA
        >LITERAL USER_STATE
        JSR PLUSORIGIN_CFA
        RTS        
        
TIB_NFA ; tib
        .DB $03^$80,'ti', $62^$80
        .DW STATE_NFA
TIB_CFA
        >LITERAL USER_TIB
        JSR PLUSORIGIN_CFA
        RTS                
                
IN_NFA ; in
        .DB $02^$80,'i', $6E^$80
        .DW TIB_NFA
IN_CFA
        >LITERAL USER_TIB
        JSR PLUSORIGIN_CFA
        RTS      
        
BASE_NFA ; base
        .DB $04^$80,'bas',$73^$80
        .DW TIB_NFA
BASE_CFA
        >LITERAL USER_BASE
        JSR PLUSORIGIN_CFA
        RTS
        
CURRENT_NFA ; current
        .DB $07^$80,'curren',$74^80
        .DW BASE_NFA
CURRENT_CFA
        >LITERAL USER_CURRENT
        JSR PLUSORIGIN_CFA
        RTS                                                

CONTEXT_NFA ; context
        .DB $07^$80,'contex',$74^80
        .DW CURRENT_NFA
CONTEXT_CFA
        >LITERAL USER_CONTEXT
        JSR PLUSORIGIN_CFA
        RTS     
        
LATEST_NFA ; latest
        .DB $06^$80,'lates',$74^80
        .DW CONTEXT_NFA
LATEST_CFA
        >LITERAL USER_LATEST
        JSR PLUSORIGIN_CFA
        RTS                                                      

WIDTH_NFA ; width
        .DB $05^80,'widt', $74^$80
        .DW LATEST_NFA
WIDTH_CFA
        >LITERAL USER_WIDTH
        JSR PLUSORIGIN_CFA
        RTS                                                      

OUT_NFA ; out
        .DB $03^$80,'ou',$74^$80
OUT_CFA
        >LITERAL USER_OUT
        JSR PLUSORIGIN_CFA
        RTS
                                                                
DPL_NFA ; dpl
        .DB $03^$80,'dp', $6C^$80
        .DW OUT_NFA
DPL_CFA
        >LITERAL USER_DPL
        JSR PLUSORIGIN_CFA
        RTS       

BLK_NFA ; blk
        .DB $03^$80,'bl',$6B^$80
        .DW DPL_NFA
BLK_CFA
        >LITERAL USER_BLK
        JSR PLUSORIGIN_CFA
        RTS       
        
SCR_NFA ; scr
        .DB $02^$80,'sc',$72^$80
        .DW BLK_NFA
SCR_CFA
        >LITERAL USER_SCR
        JSR PLUSORIGIN_CFA
        RTS
    
WARNING_NFA ; warning
        .DB $07^$80,'warnin',$67^$80        
        .DW SCR_NFA
WARNING_CFA
        >LITERAL USER_WARNING
        JSR PLUSORIGIN_CFA
        RTS
        
LIMIT_NFA ; limit
        .DB $05^$80,'limi',$74^$80
        .DW WARNING_NFA
LIMIT_CFA
        >LITERAL USER_LIMIT
        JSR PLUSORIGIN_CFA
        RTS
                             
CSP_NFA ; csp
        .DB $03^$80, 'cs',$70^$80
        .DW LIMIT_NFA
CSP_CFA
        >LITERAL USER_CSP
        JSR PLUSORIGIN_CFA
        RTS

HLD_NFA ; hld
        .DB $03^$80, 'hl', $64^$80
        .DW CSP_NFA
HLD_CFA
        >LITERAL USER_HLD
        JSR PLUSORIGIN_CFA
        RTS
        
VOCLINK_NFA ; voc-link
        .DB $08^$80, 'voc-lin', $6B^$80
        .DW HLD_NFA
VOCLINK_CFA
        >LITERAL USER_VOCLINK
        JSR PLUSORIGIN_CFA
        RTS 

CL_NFA ; c/l
        .DB $03^$80, 'c/', $6C^$80
        .DW VOCLINK_NFA
CL_CFA
        >LITERAL USER_CL
        JSR PLUSORIGIN_CFA
        RTS 

FENCE_NFA ; fence
        .DB $05^$80, 'fenc',$65^$80
        .DW CL_NFA
FENCE_CFA
        >LITERAL USER_FENCE
        JSR PLUSORIGIN_CFA
        RTS 
        
BBUF_NFA ; b/buf
        .DB $05^$80, 'b/bu',$66^$80
        .DW FENCE_NFA
BBUF_CFA
        >LITERAL USER_BBUF
        JSR PLUSORIGIN_CFA
        RTS 

HBUF_NFA ; '#buf
        .DB $05^$80, '#bu',$66^$80
        .DW BBUF_NFA
HBUF_CFA
        >LITERAL USER_BBUF
        JSR PLUSORIGIN_CFA
        RTS 

CHANNEL_NFA ; channel
        .DB $07^$80, 'channe',$6C^$80
        .DW HBUF_NFA
CHANNEL_CFA
        >LITERAL USER_CHANNEL
        JSR PLUSORIGIN_CFA
        RTS 
      
USE_NFA ; use
        .DB $03^$80, 'us',$65^$80
        .DW CHANNEL_NFA
USE_CFA
        >LITERAL USER_USE
        JSR PLUSORIGIN_CFA
        RTS 

PREV_NFA ; prev
        .DB $04^$80, 'pre',$76^$80
        .DW USE_NFA
PREV_CFA
        >LITERAL USER_PREV
        JSR PLUSORIGIN_CFA
        RTS 

FL_NFA ; f/l
        .DB $03^$80, 'f/',$6C^$80
        .DW PREV_NFA
FL_CFA
        >LITERAL USER_FL
        JSR PLUSORIGIN_CFA
        RTS 

BL_NFA ; bl
        .DB $02^$80,'b',$6C^$80        
        .DW FL_NFA
BL_CFA
        >LITERAL $20
        RTS
                
HERE_NFA ; here
        .DB $04^$80,'her',$65^$80
        .DW BL_NFA
HERE_CFA
        JSR DP_CFA
        JSR FETCH_CFA
        RTS
                
                      


;--------------------------------------------------------------------------------------------------------------------------------------------          
            
        
                   
ABORT_NFA
          .DB $05^$80,'abor',$74^$80
          .DW $0000
ABORT_CFA
          JSR SPSTORE_CFA
          JSR ASPSTORE_CFA
          JMP TEST2                        
                   
COLD_NFA ; cold
          .DB $04^$80,'col',$64^$80 
          .DW $0000               
COLD_CFA
          JMP USER_COLD
BOOT          
          LDA #ORIGIN\256
          STA $70
          LDA #ORIGIN/256
          STA $71
          LDA #ROM_ORIGIN\256
          STA $72
          LDA #ROM_ORIGIN/256
          STA $73
          LDY #ROM_ORIGIN_SIZE-1
BOOT_LOOP
          BMI BOOT_EXIT
          LDA ($72),Y
          STA ($70),Y
          DEY
          BPL BOOT_LOOP         
BOOT_EXIT
          JSR ABORT_CFA  
TEST
          JMP BOOT
TEST2
          JSR LIT_CFA
          .DW 10        
          JSR HERE_CFA
          BRK                		   
