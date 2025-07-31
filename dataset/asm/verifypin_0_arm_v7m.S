	.cpu cortex-m3
	.arch armv7-m
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"code.c"
	.text
	.align	1
	.global	byteArrayCompare
	.syntax unified
	.thumb
	.thumb_func
	.type	byteArrayCompare, %function
byteArrayCompare:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #28
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	mov	r3, r2
	strb	r3, [r7, #7]
	movs	r3, #0
	str	r3, [r7, #20]
	b	.L2
.L5:
	ldr	r3, [r7, #20]
	ldr	r2, [r7, #12]
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #20]
	ldr	r1, [r7, #8]
	add	r3, r3, r1
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L3
	movs	r3, #0
	b	.L4
.L3:
	ldr	r3, [r7, #20]
	adds	r3, r3, #1
	str	r3, [r7, #20]
.L2:
	ldrb	r3, [r7, #7]	@ zero_extendqisi2
	ldr	r2, [r7, #20]
	cmp	r2, r3
	blt	.L5
	movs	r3, #1
.L4:
	mov	r0, r3
	adds	r7, r7, #28
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	byteArrayCompare, .-byteArrayCompare
	.align	1
	.global	verifyPIN
	.syntax unified
	.thumb
	.thumb_func
	.type	verifyPIN, %function
verifyPIN:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	ldr	r3, .L10
	movs	r2, #0
	strb	r2, [r3]
	ldr	r3, .L10+4
	ldrsb	r3, [r3]
	cmp	r3, #0
	ble	.L7
	movs	r2, #4
	ldr	r1, .L10+8
	ldr	r0, .L10+12
	bl	byteArrayCompare
	mov	r3, r0
	cmp	r3, #1
	bne	.L8
	ldr	r3, .L10+4
	movs	r2, #3
	strb	r2, [r3]
	ldr	r3, .L10
	movs	r2, #1
	strb	r2, [r3]
	movs	r3, #1
	b	.L9
.L8:
	ldr	r3, .L10+4
	ldrsb	r3, [r3]
	uxtb	r3, r3
	subs	r3, r3, #1
	uxtb	r3, r3
	sxtb	r2, r3
	ldr	r3, .L10+4
	strb	r2, [r3]
	movs	r3, #0
	b	.L9
.L7:
	movs	r3, #0
.L9:
	mov	r0, r3
	pop	{r7, pc}
.L11:
	.align	2
.L10:
	.word	g_authenticated
	.word	g_ptc
	.word	g_cardPin
	.word	g_userPin
	.size	verifyPIN, .-verifyPIN
	.align	1
	.global	countermeasure
	.syntax unified
	.thumb
	.thumb_func
	.type	countermeasure, %function
countermeasure:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L13
	movs	r2, #1
	strb	r2, [r3]
	nop
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L14:
	.align	2
.L13:
	.word	g_countermeasure
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
	.align	1
	.global	initialize
	.syntax unified
	.thumb
	.thumb_func
	.type	initialize, %function
initialize:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	ldr	r3, .L20
	movs	r2, #0
	strb	r2, [r3]
	ldr	r3, .L20+4
	movs	r2, #3
	strb	r2, [r3]
	ldr	r3, .L20+8
	movs	r2, #0
	strb	r2, [r3]
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L16
.L17:
	ldr	r3, [r7, #4]
	uxtb	r3, r3
	adds	r3, r3, #1
	uxtb	r1, r3
	ldr	r2, .L20+12
	ldr	r3, [r7, #4]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L16:
	ldr	r3, [r7, #4]
	cmp	r3, #3
	ble	.L17
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L18
.L19:
	ldr	r2, .L20+16
	ldr	r3, [r7, #4]
	add	r3, r3, r2
	movs	r2, #0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L18:
	ldr	r3, [r7, #4]
	cmp	r3, #3
	ble	.L19
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L21:
	.align	2
.L20:
	.word	g_authenticated
	.word	g_ptc
	.word	g_countermeasure
	.word	g_cardPin
	.word	g_userPin
	.size	initialize, .-initialize
	.align	1
	.global	super_secret_function
	.syntax unified
	.thumb
	.thumb_func
	.type	super_secret_function, %function
super_secret_function:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	nop
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	super_secret_function, .-super_secret_function
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	initialize
	bl	verifyPIN
	ldr	r3, .L27
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L25
	bl	super_secret_function
.L25:
	movs	r3, #0
	mov	r0, r3
	pop	{r7, pc}
.L28:
	.align	2
.L27:
	.word	g_authenticated
	.size	main, .-main
	.align	1
	.global	reset_handler
	.syntax unified
	.thumb
	.thumb_func
	.type	reset_handler, %function
reset_handler:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	main
.L30:
	.syntax unified
@ 97 "src/main.c" 1
	nop
@ 0 "" 2
	.thumb
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
	.align	1
	.global	oracle_auth
	.syntax unified
	.thumb
	.thumb_func
	.type	oracle_auth, %function
oracle_auth:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L35
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	beq	.L32
	ldr	r3, .L35+4
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L32
	movs	r3, #1
	b	.L33
.L32:
	movs	r3, #0
.L33:
	uxtb	r3, r3
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L36:
	.align	2
.L35:
	.word	g_countermeasure
	.word	g_authenticated
	.size	oracle_auth, .-oracle_auth
	.align	1
	.global	oracle_ptc
	.syntax unified
	.thumb
	.thumb_func
	.type	oracle_ptc, %function
oracle_ptc:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	add	r7, sp, #0
	ldr	r3, .L41
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #1
	beq	.L38
	ldr	r3, .L41+4
	ldrsb	r3, [r3]
	cmp	r3, #2
	ble	.L38
	movs	r3, #1
	b	.L39
.L38:
	movs	r3, #0
.L39:
	uxtb	r3, r3
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L42:
	.align	2
.L41:
	.word	g_countermeasure
	.word	g_ptc
	.size	oracle_ptc, .-oracle_ptc
	.ident	"GCC: (15:13.2.rel1-2) 13.2.1 20231009"
