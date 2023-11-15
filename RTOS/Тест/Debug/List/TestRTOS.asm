
;CodeVisionAVR C Compiler V3.40 Advanced
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 1,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_comp_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void LedBlyeON (void);
;void LedBlyeOFF (void);
;void LedRedON (void);
;void LedRedOFF (void);
;interrupt [TIM2_COMP] void timer2_comp_isr(void);
;void main(void);
;void LedBlyeON (void)
; 0000 0030 {

	.CSEG
_LedBlyeON:
; .FSTART _LedBlyeON
; 0000 0031 BIT_1(PORTB,2); // Включить LED Blue
	SBI  0x18,2
; 0000 0032 // Вызвать задачу через указанное время (в миллисекундах)
; 0000 0033 SetTimerTask(LedBlyeOFF, 1000);
	LDI  R30,LOW(_LedBlyeOFF)
	LDI  R31,HIGH(_LedBlyeOFF)
	RCALL SUBOPT_0x0
	RJMP _0x2020006
; 0000 0034 }
; .FEND
;void LedBlyeOFF (void)
; 0000 0039 {
_LedBlyeOFF:
; .FSTART _LedBlyeOFF
; 0000 003A BIT_0(PORTB,2); // Выключить LED Blue
	CBI  0x18,2
; 0000 003B // Вызвать задачу через указанное время (в миллисекундах)
; 0000 003C SetTimerTask(LedBlyeON, 1000);
	LDI  R30,LOW(_LedBlyeON)
	LDI  R31,HIGH(_LedBlyeON)
	RCALL SUBOPT_0x0
	RJMP _0x2020006
; 0000 003D }
; .FEND
;void LedRedON (void)
; 0000 0042 {
_LedRedON:
; .FSTART _LedRedON
; 0000 0043 BIT_1(PORTB,1); // Включить LED Red
	SBI  0x18,1
; 0000 0044 // Вызвать задачу через указанное время (в миллисекундах)
; 0000 0045 SetTimerTask(LedRedOFF, 500);
	LDI  R30,LOW(_LedRedOFF)
	LDI  R31,HIGH(_LedRedOFF)
	RJMP _0x2020005
; 0000 0046 }
; .FEND
;void LedRedOFF (void)
; 0000 004B {
_LedRedOFF:
; .FSTART _LedRedOFF
; 0000 004C BIT_0(PORTB,1); // Выключить LED Red
	CBI  0x18,1
; 0000 004D // Вызвать задачу через указанное время (в миллисекундах)
; 0000 004E SetTimerTask(LedRedON, 500);
	LDI  R30,LOW(_LedRedON)
	LDI  R31,HIGH(_LedRedON)
_0x2020005:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
_0x2020006:
	RCALL _SetTimerTask
; 0000 004F }
	RET
; .FEND
;interrupt [TIM2_COMP] void timer2_comp_isr(void)
; 0000 0055 {
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0056 TimerService();
	RCALL _TimerService
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void main(void)
; 0000 005B {
_main:
; .FSTART _main
; 0000 005C // Input/Output Ports initialization
; 0000 005D // Port B initialization
; 0000 005E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=In
; 0000 005F DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1< ...
	LDI  R30,LOW(6)
	OUT  0x17,R30
; 0000 0060 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=T
; 0000 0061 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<< ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0062 
; 0000 0063 // Port C initialization
; 0000 0064 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0065 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0< ...
	OUT  0x14,R30
; 0000 0066 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 0067 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<< ...
	OUT  0x15,R30
; 0000 0068 
; 0000 0069 // Port D initialization
; 0000 006A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006B DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0< ...
	OUT  0x11,R30
; 0000 006C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 006D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<< ...
	OUT  0x12,R30
; 0000 006E 
; 0000 006F // Timer/Counter 0 initialization
; 0000 0070 // Clock source: System Clock
; 0000 0071 // Clock value: Timer 0 Stopped
; 0000 0072 TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0073 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0074 
; 0000 0075 // Timer/Counter 1 initialization
; 0000 0076 // Clock source: System Clock
; 0000 0077 // Clock value: Timer1 Stopped
; 0000 0078 // Mode: Normal top=0xFFFF
; 0000 0079 // OC1A output: Disconnected
; 0000 007A // OC1B output: Disconnected
; 0000 007B // Noise Canceler: Off
; 0000 007C // Input Capture on Falling Edge
; 0000 007D // Timer1 Overflow Interrupt: Off
; 0000 007E // Input Capture Interrupt: Off
; 0000 007F // Compare A Match Interrupt: Off
; 0000 0080 // Compare B Match Interrupt: Off
; 0000 0081 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<< ...
	OUT  0x2F,R30
; 0000 0082 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) ...
	OUT  0x2E,R30
; 0000 0083 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0084 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0085 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0086 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0087 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0088 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0089 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 008A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 008B 
; 0000 008C // Timer/Counter 2 initialization
; 0000 008D // Clock source: System Clock
; 0000 008E // Clock value: 125,000 kHz
; 0000 008F // Mode: CTC top=OCR2A
; 0000 0090 // OC2 output: Disconnected
; 0000 0091 // Timer Period: 1 ms
; 0000 0092 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0093 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) |  ...
	LDI  R30,LOW(10)
	OUT  0x25,R30
; 0000 0094 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0095 OCR2=0x7C;
	LDI  R30,LOW(124)
	OUT  0x23,R30
; 0000 0096 
; 0000 0097 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0098 TIMSK=(1<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TO ...
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 0099 
; 0000 009A // External Interrupt(s) initialization
; 0000 009B // INT0: Off
; 0000 009C // INT1: Off
; 0000 009D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 009E 
; 0000 009F // USART initialization
; 0000 00A0 // USART disabled
; 0000 00A1 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2)  ...
	OUT  0xA,R30
; 0000 00A2 
; 0000 00A3 // Analog Comparator initialization
; 0000 00A4 // Analog Comparator: Off
; 0000 00A5 // The Analog Comparator's positive input is
; 0000 00A6 // connected to the AIN0 pin
; 0000 00A7 // The Analog Comparator's negative input is
; 0000 00A8 // connected to the AIN1 pin
; 0000 00A9 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<AC ...
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AA SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AB 
; 0000 00AC // ADC initialization
; 0000 00AD // ADC disabled
; 0000 00AE ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) |  ...
	OUT  0x6,R30
; 0000 00AF 
; 0000 00B0 // SPI initialization
; 0000 00B1 // SPI disabled
; 0000 00B2 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<< ...
	OUT  0xD,R30
; 0000 00B3 
; 0000 00B4 // TWI initialization
; 0000 00B5 // TWI disabled
; 0000 00B6 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00B7 
; 0000 00B8 InitRTOS(); //Инициализируем RTOS
	RCALL _InitRTOS
; 0000 00B9 
; 0000 00BA // Globally enable interrupts
; 0000 00BB #asm("sei")
	SEI
; 0000 00BC 
; 0000 00BD /* Запуск фоновых задач */
; 0000 00BE SetTask(LedBlyeON);
	LDI  R26,LOW(_LedBlyeON)
	LDI  R27,HIGH(_LedBlyeON)
	RCALL _SetTask
; 0000 00BF SetTask(LedRedON);
	LDI  R26,LOW(_LedRedON)
	LDI  R27,HIGH(_LedRedON)
	RCALL _SetTask
; 0000 00C0 
; 0000 00C1 while (1) // Главный цикл диспетчера
_0x3:
; 0000 00C2 {
; 0000 00C3 #asm("wdr")    // Сброс Wachdog таймера
	WDR
; 0000 00C4 TaskManager(); // Вызов диспетчера
	RCALL _TaskManager
; 0000 00C5 }
	RJMP _0x3
; 0000 00C6 }
_0x6:
	RJMP _0x6
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;const unsigned char MAX_IND_TASK_QUEUE = TASK_QUEUE_SIZE - 1;
;eeprom unsigned char eep_ErrTaskQueue       @0x00;  //Ячейка для сохранения ошиб ...
;eeprom unsigned char eep_ErrSoftTimerQueue  @0x01;  //Ячейка для сохранения ошиб ...
;const unsigned char ERR_TASK_QUEUE       = 0xAA;  //Ошибка в указании размера оч ...
;const unsigned char ERR_SOFT_TIMER_QUEUE = 0xBB;  //Ошибка в указании размера оч ...
;volatile TPTR TaskQueue[TASK_QUEUE_SIZE]; // Очередь указателей задач
;volatile struct
;TPTR         GoToTask;  //Указатель перехода к задаче-функции
;unsigned int Time;      //Выдержка в миллисекундах
;SoftTimer[SOFT_TIMER_QUEUE_SIZE];  //Очередь програмных таймеров
; 0001 001D {

	.CSEG
_CPU_Stop:
; .FSTART _CPU_Stop
; 0001 001E /* Эта функция переводит чип AVR в режим холостого хода. В этом режиме CPU
; 0001 001F останавливается, но таймеры/счётчики, сторожевой таймер (Wathdog) и
; 0001 0020 система прерываний продолжают работать. CPU можно разбудить внешними и
; 0001 0021 внутренними прерываниями.
; 0001 0022 */
; 0001 0023 idle();
	RCALL _idle
; 0001 0024 }
	RET
; .FEND
;void SetTimerTask(TPTR Task, unsigned int NewTime)
; 0001 0037 {
_SetTimerTask:
; .FSTART _SetTimerTask
; 0001 0038 unsigned char i;    // Индексная переменная
; 0001 0039 unsigned char sreg; // Сохраняет регистр SREG чтобы потом восстановить его
; 0001 003A 
; 0001 003B sreg = SREG; // Сохраняем регистр SREG
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
;	*Task -> R20,R21
;	NewTime -> R18,R19
;	i -> R17
;	sreg -> R16
	IN   R16,63
; 0001 003C #asm("cli")  // Запрещаем прерывания. Помним об атомарном доступе!
	CLI
; 0001 003D for (i = 0; i != SOFT_TIMER_QUEUE_SIZE; i++) // Прочесываем очередь таймеров
	LDI  R17,LOW(0)
_0x20004:
	CPI  R17,2
	BREQ _0x20005
; 0001 003E {
; 0001 003F if (SoftTimer[i].GoToTask == Task) // Если уже есть запись с таким адресом
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL __GETW1P
	CP   R20,R30
	CPC  R21,R31
	BRNE _0x20006
; 0001 0040 {
; 0001 0041 SoftTimer[i].Time = NewTime; // Перезаписываем ей выдержку
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	__PUTWZR 18,19,2
; 0001 0042 SREG = sreg;                   // Восстанавливаем регистр SREG
	RJMP _0x2020004
; 0001 0043 return;                        // Выходим
; 0001 0044 }
; 0001 0045 }
_0x20006:
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 0046 for (i = 0; i != SOFT_TIMER_QUEUE_SIZE; i++) // Если не находим похожий таймер,  ...
	LDI  R17,LOW(0)
_0x20008:
	CPI  R17,2
	BREQ _0x20009
; 0001 0047 {
; 0001 0048 if (SoftTimer[i].GoToTask == CPU_Stop)
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	BRNE _0x2000A
; 0001 0049 {
; 0001 004A SoftTimer[i].GoToTask = Task; // Заполняем поле перехода задачи
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	ST   Z,R20
	STD  Z+1,R21
; 0001 004B SoftTimer[i].Time = NewTime;  // И поле выдержки времени
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	__PUTWZR 18,19,2
; 0001 004C SREG = sreg;                    // Восстанавливаем регистр SREG
	RJMP _0x2020004
; 0001 004D return;                         // Выходим
; 0001 004E }
; 0001 004F }
_0x2000A:
	SUBI R17,-1
	RJMP _0x20008
_0x20009:
; 0001 0050 if (eep_ErrSoftTimerQueue != ERR_SOFT_TIMER_QUEUE) // Зафиксировать ошибку тольк ...
	LDI  R26,LOW(_eep_ErrSoftTimerQueue)
	LDI  R27,HIGH(_eep_ErrSoftTimerQueue)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xBB)
	BREQ _0x2000B
; 0001 0051 eep_ErrSoftTimerQueue = ERR_SOFT_TIMER_QUEUE;    // Код ошибки
	LDI  R26,LOW(_eep_ErrSoftTimerQueue)
	LDI  R27,HIGH(_eep_ErrSoftTimerQueue)
	LDI  R30,LOW(187)
	RCALL __EEPROMWRB
; 0001 0052 SREG = sreg; // Восстанавливаем регистр SREG
_0x2000B:
_0x2020004:
	OUT  0x3F,R16
; 0001 0053 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
;void InitRTOS(void)
; 0001 005D {
_InitRTOS:
; .FSTART _InitRTOS
; 0001 005E unsigned char i; // Индексная переменная
; 0001 005F 
; 0001 0060 sleep_enable(); // Разрешить перевод в режим пониженного энергопотребления
	ST   -Y,R17
;	i -> R17
	RCALL _sleep_enable
; 0001 0061 for (i = 0; i != TASK_QUEUE_SIZE; i++) // Во все позиции записываем CPU_Stop
	LDI  R17,LOW(0)
_0x2000D:
	CPI  R17,2
	BREQ _0x2000E
; 0001 0062 TaskQueue[i] = CPU_Stop;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x2000D
_0x2000E:
; 0001 0063 for (i = 0; i != 2; i++)
	LDI  R17,LOW(0)
_0x20010:
	CPI  R17,2
	BREQ _0x20011
; 0001 0064 SoftTimer[i].GoToTask = CPU_Stop;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x20010
_0x20011:
; 0001 0065 }
	RJMP _0x2020001
; .FEND
;void TaskManager(void)
; 0001 0072 {
_TaskManager:
; .FSTART _TaskManager
; 0001 0073 unsigned char i; // Индексная переменная
; 0001 0074 TPTR GoToTask;   // Указатель на адреса переходов (задач)
; 0001 0075 
; 0001 0076 /* Запрещаем прерывания! Прерывания надо запрещать потому что идёт обращение
; 0001 0077 к глобальной очереди задач диспетчера. Её могут менять и прерывания.
; 0001 0078 Поэтому заботимся об атомарности операции.
; 0001 0079 */
; 0001 007A #asm("cli")
	RCALL __SAVELOCR4
;	i -> R17
;	*GoToTask -> R18,R19
	CLI
; 0001 007B GoToTask = TaskQueue[0]; // Берём первое значение из очереди
	__GETWRMN 18,19,0,_TaskQueue
; 0001 007C if (GoToTask == CPU_Stop)  // Если там пусто
	LDI  R30,LOW(_CPU_Stop)
	LDI  R31,HIGH(_CPU_Stop)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x20012
; 0001 007D {
; 0001 007E #asm("sei") // Разрешаем прерывания
	SEI
; 0001 007F CPU_Stop(); // Переходим на функцию простоя ядра
	RCALL _CPU_Stop
; 0001 0080 }
; 0001 0081 else
	RJMP _0x20013
_0x20012:
; 0001 0082 {
; 0001 0083 for (i = 0; i != MAX_IND_TASK_QUEUE; i++) // В противном случае сдвигаем всю оче ...
	LDI  R17,LOW(0)
_0x20015:
	CPI  R17,1
	BREQ _0x20016
; 0001 0084 TaskQueue[i] = TaskQueue[i + 1];
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	LSL  R26
	ROL  R27
	__ADDW2MN _TaskQueue,2
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	SUBI R17,-1
	RJMP _0x20015
_0x20016:
; 0001 0085 TaskQueue[MAX_IND_TASK_QUEUE] = CPU_Stop;
	__POINTW2MN _TaskQueue,2
	LDI  R30,LOW(_CPU_Stop)
	LDI  R31,HIGH(_CPU_Stop)
	ST   X+,R30
	ST   X,R31
; 0001 0086 #asm("sei") // Разрешаем прерывания
	SEI
; 0001 0087 GoToTask(); // Переходим к задаче
	MOVW R30,R18
	ICALL
; 0001 0088 }
_0x20013:
; 0001 0089 }
	RJMP _0x2020003
; .FEND
;void DeleteTask(TPTR Task)
; 0001 0097 {
; 0001 0098 unsigned char i;    // Индексная переменная
; 0001 0099 unsigned char ind;  // Индексная переменная
; 0001 009A unsigned char sreg; // Сохраняет регистр SREG чтобы потом восстановить его
; 0001 009B 
; 0001 009C sreg = SREG; // Сохраняем регистр SREG
;	*Task -> R20,R21
;	i -> R17
;	ind -> R16
;	sreg -> R19
; 0001 009D #asm("cli")  // Запрещаем прерывания. Помним об атомарном доступе!
; 0001 009E // Прочёсываем очередь задач
; 0001 009F i = 0;
; 0001 00A0 while (i != TASK_QUEUE_SIZE)
; 0001 00A1 {
; 0001 00A2 if (TaskQueue[i] == Task) // Если задача найдена
; 0001 00A3 {
; 0001 00A4 // Сдвигаем очередь начиная с найденного индекса до конца очереди. Последнюю зап ...
; 0001 00A5 for (ind = i; ind != MAX_IND_TASK_QUEUE; ind++)
; 0001 00A6 TaskQueue[ind] = TaskQueue[ind + 1];
; 0001 00A7 TaskQueue[MAX_IND_TASK_QUEUE] = CPU_Stop;
; 0001 00A8 }
; 0001 00A9 else i++;
; 0001 00AA }
; 0001 00AB // Прочёсываем очередь таймеров
; 0001 00AC i = 0;
; 0001 00AD while (i != SOFT_TIMER_QUEUE_SIZE)
; 0001 00AE {
; 0001 00AF if (SoftTimer[i].GoToTask == Task) // Если есть запись с таким-же адресом задачи ...
; 0001 00B0 {
; 0001 00B1 SoftTimer[i].GoToTask = CPU_Stop; // В эту запись пихаем затычку - простоя ядра
; 0001 00B2 i = SOFT_TIMER_QUEUE_SIZE; // Завершить прочёсывание очереди таймеров
; 0001 00B3 }
; 0001 00B4 else i++;
; 0001 00B5 }
; 0001 00B6 SREG = sreg; // Восстанавливаем регистр SREG
; 0001 00B7 }
;void SetTask(TPTR Task)
; 0001 00C6 {
_SetTask:
; .FSTART _SetTask
; 0001 00C7 unsigned char i = 0; // Индексная переменная
; 0001 00C8 unsigned char sreg;  // Сохраняет регистр SREG чтобы потом восстановить его
; 0001 00C9 
; 0001 00CA sreg = SREG; // Сохраняем регистр SREG
	RCALL __SAVELOCR4
	MOVW R18,R26
;	*Task -> R18,R19
;	i -> R17
;	sreg -> R16
	LDI  R17,0
	IN   R16,63
; 0001 00CB #asm("cli")  // Запрещаем прерывания. Помним об атомарном доступе!
	CLI
; 0001 00CC //Прочесываем очередь задач на предмет свободной ячейки с значением CPU_Stop - к ...
; 0001 00CD while (TaskQueue[i] != CPU_Stop)
_0x20024:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	BREQ _0x20026
; 0001 00CE {
; 0001 00CF i++;
	SUBI R17,-1
; 0001 00D0 // Если очередь переполнена то выходим
; 0001 00D1 if (i == TASK_QUEUE_SIZE)
	CPI  R17,2
	BRNE _0x20027
; 0001 00D2 {
; 0001 00D3 if (eep_ErrTaskQueue != ERR_TASK_QUEUE) // Зафиксировать ошибку только один раз
	LDI  R26,LOW(_eep_ErrTaskQueue)
	LDI  R27,HIGH(_eep_ErrTaskQueue)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x20028
; 0001 00D4 eep_ErrTaskQueue = ERR_TASK_QUEUE; 		// Код ошибки
	LDI  R26,LOW(_eep_ErrTaskQueue)
	LDI  R27,HIGH(_eep_ErrTaskQueue)
	LDI  R30,LOW(170)
	RCALL __EEPROMWRB
; 0001 00D5 SREG = sreg; // Восстанавливаем регистр SREG
_0x20028:
	RJMP _0x2020002
; 0001 00D6 return;      // Выходим
; 0001 00D7 }
; 0001 00D8 }
_0x20027:
	RJMP _0x20024
_0x20026:
; 0001 00D9 // Если нашли свободное место, то
; 0001 00DA TaskQueue[i] = Task; // Записываем в очередь задачу
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	ST   Z,R18
	STD  Z+1,R19
; 0001 00DB SREG = sreg; // Восстанавливаем регистр SREG
_0x2020002:
	OUT  0x3F,R16
; 0001 00DC }
_0x2020003:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void TimerService(void)
; 0001 00ED {
_TimerService:
; .FSTART _TimerService
; 0001 00EE unsigned char i; // Индексная переменная
; 0001 00EF 
; 0001 00F0 for (i = 0; i != SOFT_TIMER_QUEUE_SIZE; i++) // Прочесываем очередь таймеров
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x2002A:
	CPI  R17,2
	BREQ _0x2002B
; 0001 00F1 {
; 0001 00F2 if (SoftTimer[i].GoToTask == CPU_Stop) continue; // Если нашли пустышку — следую ...
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	BREQ _0x20029
; 0001 00F3 if (SoftTimer[i].Time != 0) // Если таймер не выщелкал, то щёлкаем еще раз
	RCALL SUBOPT_0x1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2002D
; 0001 00F4 SoftTimer[i].Time--;      //Уменьшаем число в ячейке
	RCALL SUBOPT_0x1
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 00F5 else // Дощёлкали до нуля?
	RJMP _0x2002E
_0x2002D:
; 0001 00F6 {
; 0001 00F7 SetTask(SoftTimer[i].GoToTask);   // Забрасываем в очередь задачу
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	RCALL _SetTask
; 0001 00F8 SoftTimer[i].GoToTask = CPU_Stop; // А в ячейку пишем затычку
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
; 0001 00F9 }
_0x2002E:
; 0001 00FA }
_0x20029:
	SUBI R17,-1
	RJMP _0x2002A
_0x2002B:
; 0001 00FB }
_0x2020001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_sleep_enable:
; .FSTART _sleep_enable
   in   r30,power_ctrl_reg
   sbr  r30,__se_bit
   out  power_ctrl_reg,r30
	RET
; .FEND
_idle:
; .FSTART _idle
   in   r30,power_ctrl_reg
   cbr  r30,__sm_mask
   out  power_ctrl_reg,r30
   in   r30,sreg
   sei
   sleep
   out  sreg,r30
	RET
; .FEND

	.ESEG

	.ORG 0x0
_eep_ErrTaskQueue:
	.BYTE 0x1

	.ORG 0x0

	.ORG 0x1
_eep_ErrSoftTimerQueue:
	.BYTE 0x1

	.ORG 0x0

	.DSEG
_TaskQueue:
	.BYTE 0x4
_SoftTimer:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R26,LOW(_SoftTimer)
	LDI  R27,HIGH(_SoftTimer)
	LDI  R31,0
	RCALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x2
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	LDI  R30,LOW(_CPU_Stop)
	LDI  R31,HIGH(_CPU_Stop)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R26,LOW(_TaskQueue)
	LDI  R27,HIGH(_TaskQueue)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(_CPU_Stop)
	LDI  R31,HIGH(_CPU_Stop)
	ST   X+,R30
	ST   X,R31
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
