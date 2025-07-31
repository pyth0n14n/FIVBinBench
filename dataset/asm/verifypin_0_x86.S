	.file	"countermeasure.c"
	.text
	.globl	countermeasure
	.type	countermeasure, @function
countermeasure:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movb	$1, g_countermeasure(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	countermeasure, .-countermeasure
	.globl	g_authenticated
	.bss
	.type	g_authenticated, @object
	.size	g_authenticated, 1
g_authenticated:
	.zero	1
	.globl	g_ptc
	.type	g_ptc, @object
	.size	g_ptc, 1
g_ptc:
	.zero	1
	.globl	g_countermeasure
	.type	g_countermeasure, @object
	.size	g_countermeasure, 1
g_countermeasure:
	.zero	1
	.globl	g_userPin
	.type	g_userPin, @object
	.size	g_userPin, 4
g_userPin:
	.zero	4
	.globl	g_cardPin
	.type	g_cardPin, @object
	.size	g_cardPin, 4
g_cardPin:
	.zero	4
	.text
	.globl	initialize
	.type	initialize, @function
initialize:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movb	$0, g_authenticated(%rip)
	movb	$3, g_ptc(%rip)
	movb	$0, g_countermeasure(%rip)
	movl	$0, -4(%rbp)
	jmp	.L3
.L4:
	movl	-4(%rbp), %eax
	leal	1(%rax), %ecx
	movl	-4(%rbp), %eax
	cltq
	leaq	g_cardPin(%rip), %rdx
	movb	%cl, (%rax,%rdx)
	addl	$1, -4(%rbp)
.L3:
	cmpl	$3, -4(%rbp)
	jle	.L4
	movl	$0, -4(%rbp)
	jmp	.L5
.L6:
	movl	-4(%rbp), %eax
	cltq
	leaq	g_userPin(%rip), %rdx
	movb	$0, (%rax,%rdx)
	addl	$1, -4(%rbp)
.L5:
	cmpl	$3, -4(%rbp)
	jle	.L6
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	initialize, .-initialize
	.globl	oracle_auth
	.type	oracle_auth, @function
oracle_auth:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movzbl	g_countermeasure(%rip), %eax
	cmpb	$1, %al
	je	.L8
	movzbl	g_authenticated(%rip), %eax
	cmpb	$1, %al
	jne	.L8
	movl	$1, %eax
	jmp	.L9
.L8:
	movl	$0, %eax
.L9:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	oracle_auth, .-oracle_auth
	.globl	oracle_ptc
	.type	oracle_ptc, @function
oracle_ptc:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movzbl	g_countermeasure(%rip), %eax
	cmpb	$1, %al
	je	.L12
	movzbl	g_ptc(%rip), %eax
	cmpb	$2, %al
	jle	.L12
	movl	$1, %eax
	jmp	.L13
.L12:
	movl	$0, %eax
.L13:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	oracle_ptc, .-oracle_ptc
	.globl	byteArrayCompare
	.type	byteArrayCompare, @function
byteArrayCompare:
.LFB4:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, %eax
	movb	%al, -36(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L16
.L19:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	-32(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, %dl
	je	.L17
	movl	$0, %eax
	jmp	.L18
.L17:
	addl	$1, -4(%rbp)
.L16:
	movzbl	-36(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L19
	movl	$1, %eax
.L18:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	byteArrayCompare, .-byteArrayCompare
	.globl	verifyPIN
	.type	verifyPIN, @function
verifyPIN:
.LFB5:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movb	$0, g_authenticated(%rip)
	movzbl	g_ptc(%rip), %eax
	testb	%al, %al
	jle	.L21
	movl	$4, %edx
	leaq	g_cardPin(%rip), %rax
	movq	%rax, %rsi
	leaq	g_userPin(%rip), %rax
	movq	%rax, %rdi
	call	byteArrayCompare
	cmpb	$1, %al
	jne	.L22
	movb	$3, g_ptc(%rip)
	movb	$1, g_authenticated(%rip)
	movl	$1, %eax
	jmp	.L23
.L22:
	movzbl	g_ptc(%rip), %eax
	subl	$1, %eax
	movb	%al, g_ptc(%rip)
	movl	$0, %eax
	jmp	.L23
.L21:
	movl	$0, %eax
.L23:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	verifyPIN, .-verifyPIN
	.globl	super_secret_function
	.type	super_secret_function, @function
super_secret_function:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	super_secret_function, .-super_secret_function
	.section	.rodata
	.align 8
.LC0:
	.string	"[@] g_countermeasure = %i, g_authenticated = %x, g_ptc = %i\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	initialize
	call	verifyPIN
	movzbl	g_ptc(%rip), %eax
	movsbl	%al, %ecx
	movzbl	g_authenticated(%rip), %eax
	movzbl	%al, %edx
	movzbl	g_countermeasure(%rip), %eax
	movzbl	%al, %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movzbl	g_authenticated(%rip), %eax
	testb	%al, %al
	je	.L27
	movl	$0, %eax
	call	super_secret_function
.L27:
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
