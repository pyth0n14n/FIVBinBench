	.arch armv7-a
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"code.c"
	.text
	.align	2
	.global	byteArrayCompare
	.syntax unified
	.arm
	.type	byteArrayCompare, %function
byteArrayCompare:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #28
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	mov	r3, r2
	strb	r3, [fp, #-21]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L2
.L5:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [fp, #-8]
	ldr	r1, [fp, #-20]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L3
	mov	r3, #0
	b	.L4
.L3:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L2:
	ldrb	r3, [fp, #-21]	@ zero_extendqisi2
	ldr	r2, [fp, #-8]
	cmp	r2, r3
	blt	.L5
	mov	r3, #1
.L4:
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	byteArrayCompare, .-byteArrayCompare
	.align	2
	.global	verifyPIN
	.syntax unified
	.arm
	.type	verifyPIN, %function
verifyPIN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	ldr	r3, .L10
.LPIC0:
	add	r3, pc, r3
	mov	r2, #0
	strb	r2, [r3]
	ldr	r3, .L10+4
.LPIC1:
	add	r3, pc, r3
	ldrsb	r3, [r3]
	cmp	r3, #0
	ble	.L7
	mov	r2, #4
	ldr	r3, .L10+8
.LPIC2:
	add	r3, pc, r3
	mov	r1, r3
	ldr	r3, .L10+12
.LPIC3:
	add	r3, pc, r3
	mov	r0, r3
	bl	byteArrayCompare(PLT)
	mov	r3, r0
	cmp	r3, #1
	bne	.L8
	ldr	r3, .L10+16
.LPIC4:
	add	r3, pc, r3
	mov	r2, #3
	strb	r2, [r3]
	ldr	r3, .L10+20
.LPIC5:
	add	r3, pc, r3
	mov	r2, #1
	strb	r2, [r3]
	mov	r3, #1
	b	.L9
.L8:
	ldr	r3, .L10+24
.LPIC6:
	add	r3, pc, r3
	ldrsb	r3, [r3]
	uxtb	r3, r3
	sub	r3, r3, #1
	uxtb	r3, r3
	sxtb	r2, r3
	ldr	r3, .L10+28
.LPIC7:
	add	r3, pc, r3
	strb	r2, [r3]
	mov	r3, #0
	b	.L9
.L7:
	mov	r3, #0
.L9:
	mov	r0, r3
	pop	{fp, pc}
.L11:
	.align	2
.L10:
	.word	g_authenticated-(.LPIC0+8)
	.word	g_ptc-(.LPIC1+8)
	.word	g_cardPin-(.LPIC2+8)
	.word	g_userPin-(.LPIC3+8)
	.word	g_ptc-(.LPIC4+8)
	.word	g_authenticated-(.LPIC5+8)
	.word	g_ptc-(.LPIC6+8)
	.word	g_ptc-(.LPIC7+8)
	.size	verifyPIN, .-verifyPIN
	.align	2
	.global	countermeasure
	.syntax unified
	.arm
	.type	countermeasure, %function
countermeasure:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .L13
.LPIC8:
	add	r3, pc, r3
	mov	r2, #1
	strb	r2, [r3]
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L14:
	.align	2
.L13:
	.word	g_countermeasure-(.LPIC8+8)
	.size	countermeasure, .-countermeasure
	.global	g_authenticated
	.bss
	.type	g_authenticated, %object
	.size	g_authenticated, 1
g_authenticated:
	.space	1
	.global	g_ptc
	.type	g_ptc, %object
	.size	g_ptc, 1
g_ptc:
	.space	1
	.global	g_countermeasure
	.type	g_countermeasure, %object
	.size	g_countermeasure, 1
g_countermeasure:
	.space	1
	.global	g_userPin
	.align	2
	.type	g_userPin, %object
	.size	g_userPin, 4
g_userPin:
	.space	4
	.global	g_cardPin
	.align	2
	.type	g_cardPin, %object
	.size	g_cardPin, 4
g_cardPin:
	.space	4
	.text
	.align	2
	.global	initialize
	.syntax unified
	.arm
	.type	initialize, %function
initialize:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	ldr	r3, .L20
.LPIC9:
	add	r3, pc, r3
	mov	r2, #0
	strb	r2, [r3]
	ldr	r3, .L20+4
.LPIC10:
	add	r3, pc, r3
	mov	r2, #3
	strb	r2, [r3]
	ldr	r3, .L20+8
.LPIC11:
	add	r3, pc, r3
	mov	r2, #0
	strb	r2, [r3]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L16
.L17:
	ldr	r3, [fp, #-8]
	uxtb	r3, r3
	add	r3, r3, #1
	uxtb	r1, r3
	ldr	r2, .L20+12
.LPIC12:
	add	r2, pc, r2
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L16:
	ldr	r3, [fp, #-8]
	cmp	r3, #3
	ble	.L17
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L18
.L19:
	ldr	r2, .L20+16
.LPIC13:
	add	r2, pc, r2
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	mov	r2, #0
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L18:
	ldr	r3, [fp, #-8]
	cmp	r3, #3
	ble	.L19
	nop
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L21:
	.align	2
.L20:
	.word	g_authenticated-(.LPIC9+8)
	.word	g_ptc-(.LPIC10+8)
	.word	g_countermeasure-(.LPIC11+8)
	.word	g_cardPin-(.LPIC12+8)
	.word	g_userPin-(.LPIC13+8)
	.size	initialize, .-initialize
	.align	2
	.global	super_secret_function
	.syntax unified
	.arm
	.type	super_secret_function, %function
super_secret_function:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	super_secret_function, .-super_secret_function
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	bl	initialize(PLT)
	bl	verifyPIN(PLT)
	ldr	r3, .L27
.LPIC14:
	add	r3, pc, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L25
	bl	super_secret_function(PLT)
.L25:
	mov	r3, #0
	mov	r0, r3
	pop	{fp, pc}
.L28:
	.align	2
.L27:
	.word	g_authenticated-(.LPIC14+8)
	.size	main, .-main
	.align	2
	.global	reset_handler
	.syntax unified
	.arm
	.type	reset_handler, %function
reset_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	bl	main(PLT)
.L30:
	.syntax divided
@ 97 "src/main.c" 1
	nop
@ 0 "" 2
	.arm
	.syntax unified
	b	.L30
	.size	reset_handler, .-reset_handler
	.global	vector_table
	.section	.vectors,"aw"
	.align	2
	.type	vector_table, %object
	.size	vector_table, 64
vector_table:
	.word	536879104
	.word	reset_handler
	.space	56
	.text
	.align	2
	.global	oracle_auth
	.syntax unified
	.arm
	.type	oracle_auth, %function
oracle_auth:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .L35
.LPIC15:
	add	r3, pc, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	beq	.L32
	ldr	r3, .L35+4
.LPIC16:
	add	r3, pc, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L32
	mov	r3, #1
	b	.L33
.L32:
	mov	r3, #0
.L33:
	uxtb	r3, r3
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L36:
	.align	2
.L35:
	.word	g_countermeasure-(.LPIC15+8)
	.word	g_authenticated-(.LPIC16+8)
	.size	oracle_auth, .-oracle_auth
	.align	2
	.global	oracle_ptc
	.syntax unified
	.arm
	.type	oracle_ptc, %function
oracle_ptc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	ldr	r3, .L41
.LPIC17:
	add	r3, pc, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	beq	.L38
	ldr	r3, .L41+4
.LPIC18:
	add	r3, pc, r3
	ldrsb	r3, [r3]
	cmp	r3, #2
	ble	.L38
	mov	r3, #1
	b	.L39
.L38:
	mov	r3, #0
.L39:
	uxtb	r3, r3
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L42:
	.align	2
.L41:
	.word	g_countermeasure-(.LPIC17+8)
	.word	g_ptc-(.LPIC18+8)
	.size	oracle_ptc, .-oracle_ptc
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",%progbits
