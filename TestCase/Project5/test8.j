; test8.j 
.class public test8 
.super java/lang/Object 
.field public static _sc Ljava/util/Scanner; 
.field public static a I 
.field public static b I 
.field public static d Z 
 
.method public static foo(I)I 
.limit stack 100 
.limit locals 100 
	bipush 0 
	istore 2 
	bipush 1 
	istore 1 
Ltest_0: 
	iload 1 
	iload 0 
	isub 
	ifle Ltrue_0 
	iconst_0 
	goto Lfalse_0 
Ltrue_0: 
	iconst_1 
Lfalse_0: 
	ifeq Lelse_0 
	iload 2 
	iload 1 
	iadd 
	istore 2 
	iload 1 
	bipush 1 
	iadd 
	istore 1 
	goto Ltest_0 
Lelse_0: 
	iload 2 
	ireturn 
	return 
.end method 
 
.method public static main([Ljava/lang/String;)V 
	.limit stack 100 
	.limit locals 100 
	new java/util/Scanner 
	dup 
	getstatic java/lang/System/in Ljava/io/InputStream; 
	invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V 
	putstatic test8/_sc Ljava/util/Scanner; 
	getstatic test8/_sc Ljava/util/Scanner; 
	invokevirtual java/util/Scanner/nextInt()I 
	putstatic test8/a I 
	getstatic test8/a I 
	invokestatic test8/foo(I)I 
	istore 1 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 1 
	invokevirtual java/io/PrintStream/print(I)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
Ltest_1: 
	iload 1 
	bipush 100 
	isub 
	ifge Ltrue_1 
	iconst_0 
	goto Lfalse_1 
Ltrue_1: 
	iconst_1 
Lfalse_1: 
	ifeq Lelse_1 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "c >= 100 \n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	goto Lexit_1 
Lelse_1: 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "c < 100 \n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
Lexit_1: 
	return 
.end method 
