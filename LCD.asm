    #include p18f87k22.inc
    
    global LCD_Initialisation, input_cmd, input_data, LCD_ScrollX, Box, New_Box
    extern Delay_ms, SPI_writeREG, Scroll_d1, Scroll_d2
   
#define	LCD_width		800
#define	LCD_height		480
  
; Colors (RGB565)
#define	RA8875_BLACK            0x0000 ;< Black Color
#define	RA8875_BLUE             0x001F ;< Blue Color
#define	RA8875_RED              0xF800 ;< Red Color
#define	RA8875_GREEN            0x07E0 ;< Green Color
#define RA8875_CYAN             0x07FF ;< Cyan Color
#define RA8875_MAGENTA          0xF81F ;< Magenta Color
#define RA8875_YELLOW           0xFFE0 ;< Yellow Color
#define RA8875_WHITE            0xFFFF ;< White Color

; Command/Data pins for SPI
#define RA8875_DATAWRITE        0x00 ;< See datasheet
#define RA8875_DATAREAD         0x40 ;< See datasheet
#define RA8875_CMDWRITE         0x80 ;< See datasheet
#define RA8875_CMDREAD          0xC0 ;< See datasheet

; Registers & bits
#define RA8875_PWRR             0x01 ;< See datasheet
#define RA8875_PWRR_DISPON      0x80 ;< See datasheet
#define RA8875_PWRR_DISPOFF     0x00 ;< See datasheet
#define RA8875_PWRR_SLEEP       0x02 ;< See datasheet
#define RA8875_PWRR_NORMAL      0x00 ;< See datasheet
#define RA8875_PWRR_SOFTRESET   0x01 ;< See datasheet

#define RA8875_MRWC             0x02 ;< See datasheet

#define RA8875_GPIOX            0xC7 ;< See datasheet

#define RA8875_PLLC1            0x88 ;< See datasheet
#define RA8875_PLLC1_PLLDIV2    0x80 ;< See datasheet
#define RA8875_PLLC1_PLLDIV1    0x00 ;< See datasheet

#define RA8875_PLLC2            0x89 ;< See datasheet
#define RA8875_PLLC2_DIV1       0x00 ;< See datasheet
#define RA8875_PLLC2_DIV2       0x01 ;< See datasheet
#define RA8875_PLLC2_DIV4       0x02 ;< See datasheet
#define RA8875_PLLC2_DIV8       0x03 ;< See datasheet
#define RA8875_PLLC2_DIV16      0x04 ;< See datasheet
#define RA8875_PLLC2_DIV32      0x05 ;< See datasheet
#define RA8875_PLLC2_DIV64      0x06 ;< See datasheet
#define RA8875_PLLC2_DIV128     0x07 ;< See datasheet

#define RA8875_SYSR             0x10 ;< See datasheet
#define RA8875_SYSR_8BPP        0x00 ;< See datasheet
#define RA8875_SYSR_16BPP       0x0C ;< See datasheet
#define RA8875_SYSR_MCU8        0x00 ;< See datasheet
#define RA8875_SYSR_MCU16       0x03 ;< See datasheet

#define RA8875_PCSR             0x04 ;< See datasheet
#define RA8875_PCSR_PDATR       0x00 ;< See datasheet
#define RA8875_PCSR_PDATL       0x80 ;< See datasheet
#define RA8875_PCSR_CLK         0x00 ;< See datasheet
#define RA8875_PCSR_2CLK        0x01 ;< See datasheet
#define RA8875_PCSR_4CLK        0x02 ;< See datasheet
#define RA8875_PCSR_8CLK        0x03 ;< See datasheet

#define RA8875_HDWR             0x14 ;< See datasheet

#define RA8875_HNDFTR           0x15 ;< See datasheet
#define RA8875_HNDFTR_DE_HIGH   0x00 ;< See datasheet
#define RA8875_HNDFTR_DE_LOW    0x80 ;< See datasheet

#define RA8875_HNDR             0x16 ;< See datasheet
#define RA8875_HSTR             0x17 ;< See datasheet
#define RA8875_HPWR             0x18 ;< See datasheet
#define RA8875_HPWR_LOW         0x00 ;< See datasheet
#define RA8875_HPWR_HIGH        0x80 ;< See datasheet

#define RA8875_VDHR0            0x19 ;< See datasheet
#define RA8875_VDHR1            0x1A ;< See datasheet
#define RA8875_VNDR0            0x1B ;< See datasheet
#define RA8875_VNDR1            0x1C ;< See datasheet
#define RA8875_VSTR0            0x1D ;< See datasheet
#define RA8875_VSTR1            0x1E ;< See datasheet
#define RA8875_VPWR             0x1F ;< See datasheet
#define RA8875_VPWR_LOW         0x00 ;< See datasheet
#define RA8875_VPWR_HIGH        0x80 ;< See datasheet

#define RA8875_HSAW0            0x30 ;< See datasheet
#define RA8875_HSAW1            0x31 ;< See datasheet
#define RA8875_VSAW0            0x32 ;< See datasheet
#define RA8875_VSAW1            0x33 ;< See datasheet

#define RA8875_HEAW0            0x34 ;< See datasheet
#define RA8875_HEAW1            0x35 ;< See datasheet
#define RA8875_VEAW0            0x36 ;< See datasheet
#define RA8875_VEAW1            0x37 ;< See datasheet

#define RA8875_MCLR             0x8E ;< See datasheet
#define RA8875_MCLR_START       0x80 ;< See datasheet
#define RA8875_MCLR_STOP        0x00 ;< See datasheet
#define RA8875_MCLR_READSTATUS  0x80 ;< See datasheet
#define RA8875_MCLR_FULL        0x00 ;< See datasheet
#define RA8875_MCLR_ACTIVE      0x40 ;< See datasheet

#define RA8875_DCR                    0x90 ;< See datashe et
#define RA8875_DCR_LINESQUTRI_START   0x80 ;< See datasheet
#define RA8875_DCR_LINESQUTRI_STOP    0x00 ;< See datasheet
#define RA8875_DCR_LINESQUTRI_STATUS  0x80 ;< See datasheet
#define RA8875_DCR_CIRCLE_START       0x40 ;< See datasheet
#define RA8875_DCR_CIRCLE_STATUS      0x40 ;< See datasheet
#define RA8875_DCR_CIRCLE_STOP        0x00 ;< See datasheet
#define RA8875_DCR_FILL               0x20 ;< See datasheet
#define RA8875_DCR_NOFILL             0x00 ;< See datasheet
#define RA8875_DCR_DRAWLINE           0x00 ;< See datasheet
#define RA8875_DCR_DRAWTRIANGLE       0x01 ;< See datasheet
#define RA8875_DCR_DRAWSQUARE         0x10 ;< See datasheet

#define RA8875_ELLIPSE                0xA0 ;< See datasheet
#define RA8875_ELLIPSE_STATUS         0x80 ;< See datasheet

#define RA8875_MWCR0            0x40 ;< See datasheet
#define RA8875_MWCR0_GFXMODE    0x00 ;< See datasheet
#define RA8875_MWCR0_TXTMODE    0x80 ;< See datasheet
#define RA8875_MWCR0_CURSOR     0x40 ;< See datasheet
#define RA8875_MWCR0_BLINK      0x20 ;< See datasheet

#define RA8875_MWCR0_DIRMASK    0x0C ;< Bitmask for Write Direction
#define RA8875_MWCR0_LRTD       0x00 ;< Left->Right then Top->Down
#define RA8875_MWCR0_RLTD       0x04 ;< Right->Left then Top->Down
#define RA8875_MWCR0_TDLR       0x08 ;< Top->Down then Left->Right
#define RA8875_MWCR0_DTLR       0x0C ;< Down->Top then Left->Right

#define RA8875_BTCR             0x44 ;< See datasheet
#define RA8875_CURH0            0x46 ;< See datasheet
#define RA8875_CURH1            0x47 ;< See datasheet
#define RA8875_CURV0            0x48 ;< See datasheet
#define RA8875_CURV1            0x49 ;< See datasheet

#define RA8875_P1CR             0x8A ;< See datasheet
#define RA8875_P1CR_ENABLE      0x80 ;< See datasheet
#define RA8875_P1CR_DISABLE     0x00 ;< See datasheet
#define RA8875_P1CR_CLKOUT      0x10 ;< See datasheet
#define RA8875_P1CR_PWMOUT      0x00 ;< See datasheet

#define RA8875_P1DCR            0x8B ;< See datasheet

#define RA8875_P2CR             0x8C ;< See datasheet
#define RA8875_P2CR_ENABLE      0x80 ;< See datasheet
#define RA8875_P2CR_DISABLE     0x00 ;< See datasheet
#define RA8875_P2CR_CLKOUT      0x10 ;< See datasheet
#define RA8875_P2CR_PWMOUT      0x00 ;< See datasheet

#define RA8875_P2DCR            0x8D ;< See datasheet

#define RA8875_PWM_CLK_DIV1     0x00 ;< See datasheet
#define RA8875_PWM_CLK_DIV2     0x01 ;< See datasheet
#define RA8875_PWM_CLK_DIV4     0x02 ;< See datasheet
#define RA8875_PWM_CLK_DIV8     0x03 ;< See datasheet
#define RA8875_PWM_CLK_DIV16    0x04 ;< See datasheet
#define RA8875_PWM_CLK_DIV32    0x05 ;< See datasheet
#define RA8875_PWM_CLK_DIV64    0x06 ;< See datasheet
#define RA8875_PWM_CLK_DIV128   0x07 ;< See datasheet
#define RA8875_PWM_CLK_DIV256   0x08 ;< See datasheet
#define RA8875_PWM_CLK_DIV512   0x09 ;< See datasheet
#define RA8875_PWM_CLK_DIV1024  0x0A ;< See datasheet
#define RA8875_PWM_CLK_DIV2048  0x0B ;< See datasheet
#define RA8875_PWM_CLK_DIV4096  0x0C ;< See datasheet
#define RA8875_PWM_CLK_DIV8192  0x0D ;< See datasheet
#define RA8875_PWM_CLK_DIV16384 0x0E ;< See datasheet
#define RA8875_PWM_CLK_DIV32768 0x0F ;< See datasheet

#define RA8875_TPCR0                  0x70 ;< See datasheet
#define RA8875_TPCR0_ENABLE           0x80 ;< See datasheet
#define RA8875_TPCR0_DISABLE          0x00 ;< See datasheet
#define RA8875_TPCR0_WAIT_512CLK      0x00 ;< See datasheet
#define RA8875_TPCR0_WAIT_1024CLK     0x10 ;< See datasheet
#define RA8875_TPCR0_WAIT_2048CLK     0x20 ;< See datasheet
#define RA8875_TPCR0_WAIT_4096CLK     0x30 ;< See datasheet
#define RA8875_TPCR0_WAIT_8192CLK     0x40 ;< See datasheet
#define RA8875_TPCR0_WAIT_16384CLK    0x50 ;< See datasheet
#define RA8875_TPCR0_WAIT_32768CLK    0x60 ;< See datasheet
#define RA8875_TPCR0_WAIT_65536CLK    0x70 ;< See datasheet
#define RA8875_TPCR0_WAKEENABLE       0x08 ;< See datasheet
#define RA8875_TPCR0_WAKEDISABLE      0x00 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV1      0x00 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV2      0x01 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV4      0x02 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV8      0x03 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV16     0x04 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV32     0x05 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV64     0x06 ;< See datasheet
#define RA8875_TPCR0_ADCCLK_DIV128    0x07 ;< See datasheet

#define RA8875_TPCR1            0x71 ;< See datasheet
#define RA8875_TPCR1_AUTO       0x00 ;< See datasheet
#define RA8875_TPCR1_MANUAL     0x40 ;< See datasheet
#define RA8875_TPCR1_VREFINT    0x00 ;< See datasheet
#define RA8875_TPCR1_VREFEXT    0x20 ;< See datasheet
#define RA8875_TPCR1_DEBOUNCE   0x04 ;< See datasheet
#define RA8875_TPCR1_NODEBOUNCE 0x00 ;< See datasheet
#define RA8875_TPCR1_IDLE       0x00 ;< See datasheet
#define RA8875_TPCR1_WAIT       0x01 ;< See datasheet
#define RA8875_TPCR1_LATCHX     0x02 ;< See datasheet
#define RA8875_TPCR1_LATCHY     0x03 ;< See datasheet

#define RA8875_TPXH             0x72 ;< See datasheet
#define RA8875_TPYH             0x73 ;< See datasheet
#define RA8875_TPXYL            0x74 ;< See datasheet

#define RA8875_INTC1            0xF0 ;< See datasheet
#define RA8875_INTC1_KEY        0x10 ;< See datasheet
#define RA8875_INTC1_DMA        0x08 ;< See datasheet
#define RA8875_INTC1_TP         0x04 ;< See datasheet
#define RA8875_INTC1_BTE        0x02 ;< See datasheet

#define RA8875_INTC2            0xF1 ;< See datasheet
#define RA8875_INTC2_KEY        0x10 ;< See datasheet
#define RA8875_INTC2_DMA        0x08 ;< See datasheet
#define RA8875_INTC2_TP         0x04 ;< See datasheet
#define RA8875_INTC2_BTE        0x02 ;< See datasheet

#define RA8875_SCROLL_BOTH      0x00 ;< See datasheet
#define RA8875_SCROLL_LAYER1    0x40 ;< See datasheet
#define RA8875_SCROLL_LAYER2    0x80 ;< See datasheet
#define RA8875_SCROLL_BUFFER    0xC0 ;< See datasheet
    
#define  pixclk		(RA8875_PCSR_PDATL | RA8875_PCSR_2CLK);
#define  hsync_start		.32;
#define  hsync_pw		.96;
#define  hsync_finetune		.0;
#define  hsync_nondisp		.26;
#define  vsync_pw		.2;
#define  vsync_nondisp		.32;
#define  vsync_start		.23;
#define  _voffset		.0;    

#define	box_xstart		.40
#define	box_ystart		.60
#define	box_xend		.200
#define	box_yend		.220
    
#define	box_xoffset		.240
#define	box_yoffset		.200

#define	tri_left_1x		.50
#define	tri_left_1y		.80
#define	tri_left_2x		.190
#define	tri_left_2y		.80
#define	tri_left_3x		.120
#define	tri_left_3y		.210
    
#define	tri_down_1x		.60
#define	tri_down_1y		.210
#define	tri_down_2x		.60
#define	tri_down_2y		.70
#define	tri_down_3x		.185
#define	tri_down_3y		.140
    
#define	tri_right_1x		.190
#define	tri_right_1y		.200
#define	tri_right_2x		.50
#define	tri_right_2y		.200
#define	tri_right_3x		.120
#define	tri_right_3y		.75
    
#define	tri_up_1x		.180
#define	tri_up_1y		.70
#define	tri_up_2x		.180
#define	tri_up_2y		.210
#define	tri_up_3x		.55
#define	tri_up_3y		.140

#define	Box_pos1	0
#define	Box_pos2	1
#define	Box_pos3	2
#define	Box_halfbeat	3
#define	Box_dir1	4
#define	Box_dir2	5
#define	Box_enable	6

acs0    udata_acs   ; reserve data space in access ram
input_cmd	    res 1
input_data	    res 1
Delay_cnt_l	    res 1   ; reserve 1 byte for variable Delay_cnt_l
Delay_cnt_h	    res 1   ; reserve 1 byte for variable Delay_cnt_h
Delay_cnt_ms	    res 1   ; reserve 1 byte for ms counter
Box		    res 1
		    
input1		    res 1
input2		    res 1
input3		    res 1
input4		    res 1		    
input5		    res 1	
input6		    res 1
dir		    res 1
Setup	code

New_Box    ;takes Box as input
    btfss   Box, Box_enable
    return
    call    LCD_RectHelper
    btfss   Box, Box_dir1
    bra	    zero_or_two
    bra	    one_or_three
zero_or_two
    btfss   Box, Box_dir2	    
    bra	    Tri_left	    	    ;zero
    bra	    Tri_right		    ;two
one_or_three
    btfss   Box, Box_dir2
    bra	    Tri_down	    	    ;one
    bra	    Tri_up		    ;three
    
Tri_left
    movlw   tri_left_1x 
    movwf   input1
    movlw   tri_left_1y 
    movwf   input2
    movlw   tri_left_2x 
    movwf   input3
    movlw   tri_left_2y 
    movwf   input4
    movlw   tri_left_3x 
    movwf   input5
    movlw   tri_left_3y 
    movwf   input6
    call    LCD_TriHelper
    return

Tri_down
    movlw   tri_down_1x 
    movwf   input1
    movlw   tri_down_1y 
    movwf   input2
    movlw   tri_down_2x 
    movwf   input3
    movlw   tri_down_2y 
    movwf   input4
    movlw   tri_down_3x 
    movwf   input5
    movlw   tri_down_3y 
    movwf   input6
    call    LCD_TriHelper
    return
 
Tri_right
    movlw   tri_right_1x 
    movwf   input1
    movlw   tri_right_1y 
    movwf   input2
    movlw   tri_right_2x 
    movwf   input3
    movlw   tri_right_2y 
    movwf   input4
    movlw   tri_right_3x 
    movwf   input5
    movlw   tri_right_3y 
    movwf   input6
    call    LCD_TriHelper
    return
    
Tri_up
    movlw   tri_up_1x 
    movwf   input1
    movlw   tri_up_1y 
    movwf   input2
    movlw   tri_up_2x 
    movwf   input3
    movlw   tri_up_2y 
    movwf   input4
    movlw   tri_up_3x 
    movwf   input5
    movlw   tri_up_3y 
    movwf   input6
    call    LCD_TriHelper
    return

LYEN1
    movlw   0x41
    movwf   input_cmd
    movlw   b'00000000'
    movwf   input_data
    call    SPI_writeREG
    return
LYEN2
    movlw   0x41
    movwf   input_cmd
    movlw   b'00000001'
    movwf   input_data
    call    SPI_writeREG
    return
    
LCD_RectHelper
    ;x = 0
    ;y = 0
    ;w = _width-1
    ;h = _height-1

    ;/* Set X1 */
    movlw   0x91
    movwf   input_cmd
    movlw   b'11'	    
    andwf   Box, W	    
    mullw   box_xoffset
    movlw   box_xstart
    addwf   PRODL, W
    movwf   input_data
    call    SPI_writeREG
    movlw   0x92
    movwf   input_cmd
    movlw   .0
    addwfc  PRODH, W
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Y1 */
    movlw   0x93
    movwf   input_cmd
    movlw   box_ystart
    btfsc   Box, Box_pos3
    addlw   box_yoffset
    movwf   input_data
    call    SPI_writeREG
    movlw   0x94
    movwf   input_cmd
    movlw   .0
    btfsc   Box, Box_pos3
    addlw   .1
    movwf   input_data
    call    SPI_writeREG

    ;/* Set X2 */
    movlw   0x95
    movwf   input_cmd
    movlw   b'11'	    ;w=3
    andwf   Box, W	    ;
    mullw   box_xoffset
    movlw   box_xend
    addwf   PRODL, W
    movwf   input_data
    call    SPI_writeREG
    movlw   0x96
    movwf   input_cmd
    movlw   .0
    addwfc  PRODH, W
    movwf   input_data
    call    SPI_writeREG

    ;/* Set Y2 */
    movlw   0x97
    movwf   input_cmd
    movlw   box_yend
    btfsc   Box, Box_pos3
    addlw   box_yoffset
    movwf   input_data
    call    SPI_writeREG
    movlw   0x98
    movwf   input_cmd
    movlw   .0
    btfsc   Box, Box_pos3
    addlw   .1
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set r1 */
    movlw   0xA1
    movwf   input_cmd
    movlw   .20
    movwf   input_data
    call    SPI_writeREG
    movlw   0xA2
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set r2 */
    movlw   0xA3
    movwf   input_cmd
    movlw   .20
    movwf   input_data
    call    SPI_writeREG
    movlw   0xA4
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG

    ;/* Set Color */
    movlw   0x63
    movwf   input_cmd
    movlw   .7		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x64		
    movwf   input_cmd
    movlw   .7		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x65
    movwf   input_cmd
    movlw   .3		;0~3
    movwf   input_data
    call    SPI_writeREG

    ;/* Draw! */
    movlw   RA8875_ELLIPSE
    movwf   input_cmd
    movlw   0xA0		    ;0xE0 for fill
    movwf   input_data
    call    SPI_writeREG

    ;/* Wait for the command to finish */
    movlw   .1
    call    Delay_ms
    ;waitPoll(RA8875_DCR, RA8875_DCR_LINESQUTRI_STATUS);
    return
    
LCD_TriHelper
    ;/* Set X1 */
    movlw   0x91
    movwf   input_cmd
    movlw   b'11'	    
    andwf   Box, W	    
    mullw   box_xoffset
    movf    input1, W
    addwf   PRODL, W
    movwf   input_data
    call    SPI_writeREG
    movlw   0x92
    movwf   input_cmd
    movlw   .0
    addwfc  PRODH, W
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Y1 */
    movlw   0x93
    movwf   input_cmd
    movf    input2,W
    btfsc   Box, Box_pos3
    addlw   box_yoffset
    movwf   input_data
    call    SPI_writeREG
    movlw   0x94
    movwf   input_cmd
    movlw   .0
    btfsc   Box, Box_pos3
    addlw   .1
    movwf   input_data
    call    SPI_writeREG

    ;/* Set X2 */
    movlw   0x95
    movwf   input_cmd
    movlw   b'11'
    andwf   Box, W
    mullw   box_xoffset
    movf    input3, W
    addwf   PRODL, W
    movwf   input_data
    call    SPI_writeREG
    movlw   0x96
    movwf   input_cmd
    movlw   .0
    addwfc  PRODH, W
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Y2 */
    movlw   0x97
    movwf   input_cmd
    movf    input4, W
    btfsc   Box, Box_pos3
    addlw   box_yoffset
    movwf   input_data
    call    SPI_writeREG
    movlw   0x98
    movwf   input_cmd
    movlw   .0
    btfsc   Box, Box_pos3
    addlw   .1
    movwf   input_data
    call    SPI_writeREG

    ;/* Set X3 */
    movlw   0xA9
    movwf   input_cmd
    movlw   b'11'
    andwf   Box, W
    mullw   box_xoffset
    movf    input5, W
    addwf   PRODL, W
    movwf   input_data
    call    SPI_writeREG
    movlw   0xAA
    movwf   input_cmd
    movlw   .0
    addwfc  PRODH, W
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Y3 */
    movlw   0xAB
    movwf   input_cmd
    movf    input6, W
    btfsc   Box, Box_pos3
    addlw   box_yoffset
    movwf   input_data
    call    SPI_writeREG
    movlw   0xAC
    movwf   input_cmd
    movlw   .0
    btfsc   Box, Box_pos3
    addlw   .1
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Color */
    movlw   0x63
    movwf   input_cmd
    movlw   .7		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x64		
    movwf   input_cmd
    movlw   .0		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x65
    movwf   input_cmd
    movlw   .0		;0~3
    movwf   input_data
    call    SPI_writeREG

    ;/* Draw! */
    movlw   RA8875_DCR
    movwf   input_cmd
    movlw   0xA1
    movwf   input_data
    call    SPI_writeREG

    ;/* Wait for the command to finish */
    movlw   .1
    call    Delay_ms
    ;waitPoll(RA8875_DCR, RA8875_DCR_LINESQUTRI_STATUS);
    return
    
LCD_LineHelper
    ;/* Set X1 */
    movlw   0x91
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    movlw   0x92
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Y1 */
    movlw   0x93
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    movlw   0x94
    movwf   input_cmd
    movlw   .1
    movwf   input_data
    call    SPI_writeREG

    ;/* Set X2 */
    movlw   0x95
    movwf   input_cmd
    movlw   .31
    movwf   input_data
    call    SPI_writeREG
    movlw   0x96
    movwf   input_cmd
    movlw   .3
    movwf   input_data
    call    SPI_writeREG
    ;/* Set Y2 */
    movlw   0x97
    movwf   input_cmd
    movlw   .100
    movwf   input_data
    call    SPI_writeREG
    movlw   0x98
    movwf   input_cmd
    movlw   .1
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Set Color */
    movlw   0x63
    movwf   input_cmd
    movlw   .7		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x64		
    movwf   input_cmd
    movlw   .7		;0~7
    movwf   input_data
    call    SPI_writeREG
    movlw   0x65
    movwf   input_cmd
    movlw   .3		;0~3
    movwf   input_data
    call    SPI_writeREG

    ;/* Draw! */
    movlw   RA8875_DCR
    movwf   input_cmd
    movlw   0x80
    movwf   input_data
    call    SPI_writeREG
    
    ;/* Wait for the command to finish */
    movlw   .1
    call    Delay_ms
    return
    
LCD_Initialisation
    call    LCD_PLLinit
    
    movlw   RA8875_SYSR
    movwf   input_cmd
    movlw   (RA8875_SYSR_16BPP | RA8875_SYSR_MCU8)
    movwf   input_data
    call    SPI_writeREG

    movlw   RA8875_PCSR
    movwf   input_cmd
    movlw   pixclk
    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    Delay_ms
    
    ; Horizontal settings registers 
    movlw   RA8875_HDWR
    movwf   input_cmd
    movlw   .99						;(LCD_width / 8) - 1)
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HNDFTR
    movwf   input_cmd
    movlw   RA8875_HNDFTR_DE_HIGH
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HNDR
    movwf   input_cmd
    movlw   .3		    ;  (hsync_nondisp - hsync_finetune - 2)/8)
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HSTR
    movwf   input_cmd
    movlw   .3;  hsync_start/8 - 1)
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HPWR
    movwf   input_cmd
    movlw   .11;  RA8875_HPWR_LOW + (hsync_pw/8 - 1))
    movwf   input_data
    call    SPI_writeREG

    ; Vertical settings registers ;
    movlw   RA8875_VDHR0
    movwf   input_cmd
    movlw   .223;(LCD_height - 1 + _voffset) & 0xFF
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VDHR1
    movwf   input_cmd
    movlw   .1;  (uint16_t)(LCD_height - 1 + _voffset) >> 8);
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VNDR0
    movwf   input_cmd
    movlw   .31;  vsync_nondisp-1);                          
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VNDR1
    movwf   input_cmd
    movlw   .0; vsync_nondisp >> 8);
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VSTR0
    movwf   input_cmd
    movlw   .22;  vsync_start-1);                            ; Vsync start position = VSTR + 1
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VSTR1
    movwf   input_cmd
    movlw   .0;  vsync_start >> 8);
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VPWR
    movwf   input_cmd
    movlw   .1;  RA8875_VPWR_LOW + vsync_pw - 1);            ; Vsync pulse width = VPWR + 1
    movwf   input_data
    call    SPI_writeREG

    ; Set active window X ;
    movlw   RA8875_HSAW0
    movwf   input_cmd
    movlw   .0; ; horizontal start point
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HSAW1
    movwf   input_cmd
    movlw   .0;
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HEAW0
    movwf   input_cmd
    movlw   .31;(LCD_width - 1) & 0xFF);            ; horizontal end point
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_HEAW1
    movwf   input_cmd
    movlw   .3;  (uint16_t)(LCD_width - 1) >> 8);
    movwf   input_data
    call    SPI_writeREG

    ; Set active window Y ;
    movlw   RA8875_VSAW0
    movwf   input_cmd
    movlw   .0;  0 + _voffset);                              ; vertical start point
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VSAW1
    movwf   input_cmd
    movlw   .0;  0 + _voffset);
    movlw   RA8875_VEAW0
    movwf   input_cmd
    movlw   .223;  (uint16_t)(LCD_height - 1 + _voffset) & 0xFF); ; vertical end point
    movwf   input_data
    call    SPI_writeREG
    movlw   RA8875_VEAW1
    movwf   input_cmd
    movlw   .1;  (uint16_t)(LCD_height - 1 + _voffset) >> 8);
    movwf   input_data
    call    SPI_writeREG

    ; ToDo: Setup touch panel? ;

    ; Clear the entire window ;
    movlw   RA8875_MCLR
    movwf   input_cmd
    movlw   (RA8875_MCLR_START | RA8875_MCLR_FULL);
    movwf   input_data
    call    SPI_writeREG
    movlw   .250
    call    Delay_ms
    movlw   .250
    call    Delay_ms
    
    call    LCD_DisplayOn
    call    LCD_GPIOX ;// Enable TFT - display enable tied to GPIOX
    call    LCD_PWM1config; // PWM output for backlight
    call    LCD_PWM1out;
    call    LCD_SetScrollWindow
    call    LCD_TwoLayers
    return
    
LCD_PLLinit
    movlw   RA8875_PLLC1
    movwf   input_cmd
    movlw   RA8875_PLLC1_PLLDIV1
    addlw   .11
    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    Delay_ms
   
    movlw   RA8875_PLLC2
    movwf   input_cmd
    movlw   RA8875_PLLC2_DIV4
    movwf   input_data
    call    SPI_writeREG
    movlw   .1
    call    Delay_ms
    return

LCD_DisplayOn
    movlw   RA8875_PWRR
    movwf   input_cmd
    movlw   (RA8875_PWRR_NORMAL | RA8875_PWRR_DISPON);
    movwf   input_data
    call    SPI_writeREG
    return

LCD_GPIOX
    movlw   RA8875_GPIOX
    movwf   input_cmd
    movlw   .1
    movwf   input_data
    call    SPI_writeREG
    return
    
LCD_PWM1config
    movlw   RA8875_P1CR
    movwf   input_cmd
    movlw   (RA8875_P1CR_ENABLE | (RA8875_PWM_CLK_DIV1024 & 0xF))
    movwf   input_data
    call    SPI_writeREG
    return
    
LCD_PWM1out
    movlw   RA8875_P1DCR
    movwf   input_cmd
    movlw   .255
    movwf   input_data
    call    SPI_writeREG
    return

LCD_SetScrollWindow
    ;// Horizontal Start point of Scroll Window
    movlw   0x38
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    movlw   0x39
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
   
    ;// Vertical Start Point of Scroll Window
    movlw   0x3A
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    movlw   0x3B
    movwf   input_cmd
    movlw   .0
    movwf   input_data
    call    SPI_writeREG
    
    ;// Horizontal End Point of Scroll Window
    movlw   0x3C
    movwf   input_cmd
    movlw   .31
    movwf   input_data
    call    SPI_writeREG
    movlw   0x3D
    movwf   input_cmd
    movlw   .3
    movwf   input_data
    call    SPI_writeREG
    
    ;// Vertical End Point of Scroll Window
    movlw   0x3E
    movwf   input_cmd
    movlw   .223
    movwf   input_data
    call    SPI_writeREG
    movlw   0x3F
    movwf   input_cmd
    movlw   .1
    movwf   input_data
    call    SPI_writeREG

    ;// Scroll function setting
    movlw   0x52
    movwf   input_cmd
    movlw   b'11000000'
    movwf   input_data
    call    SPI_writeREG
    return 
    
LCD_ScrollX    
    movlw   0x24
    movwf   input_cmd
    movff   Scroll_d1, input_data
    call    SPI_writeREG
    movlw   0x25
    movwf   input_cmd
    movff   Scroll_d2, input_data
    call    SPI_writeREG
    return
    
LCD_TwoLayers
    movlw   0x20
    movwf   input_cmd
    movlw   b'10000000'
    movwf   input_data
    call    SPI_writeREG
    movlw   0x40
    movwf   input_cmd
    movlw   b'10000000'
    movwf   input_data
    call    SPI_writeREG
    return
    end

