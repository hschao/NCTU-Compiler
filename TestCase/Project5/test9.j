; test9.j 
.class public test9 
.super java/lang/Object 
.field public static _sc Ljava/util/Scanner; 
.field public static i I 
.field public static k F 
.field public static j F 
.field public static s Z 

.method public static notFunAtAll(FIZF)F 
.limit stack 100 
.limit locals 100 
	iload 2 
	ifeq L1 
	fload 0 
	iload 1 
	i2f 
	fadd 
	fload 3 
	fadd 
	freturn 
	goto L2 
L1: 
	ldc -50.000000 

	freturn 
L2: 
	freturn 
.end method 

.method public static ppp()V 
.limit stack 100 
.limit locals 100 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "not fun at all\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	return 
.end method 

.method public static cmp(FF)Z 
.limit stack 100 
.limit locals 100 
	fload 0 
	fload 1 
	fcmpl 
	ifge L3 
	iconst_0 
	goto L4 
L3: 
	iconst_1 
L4: 
	istore 2 
	iload 2 
	ireturn 
	ireturn 
.end method 

.method public static main([Ljava/lang/String;)V 
	.limit stack 100 
	.limit locals 100 
	new java/util/Scanner 
	dup 
	getstatic java/lang/System/in Ljava/io/InputStream; 
	invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V 
	putstatic test9/_sc Ljava/util/Scanner; 
	ldc -1 

	istore 1 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 1 
	invokevirtual java/io/PrintStream/print(I)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	ldc -3.000000 

	putstatic test9/k F 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	getstatic test9/k F 
	invokevirtual java/io/PrintStream/print(F)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	getstatic test9/k F 
	fneg 
	putstatic test9/j F 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	getstatic test9/j F 
	invokevirtual java/io/PrintStream/print(F)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iconst_0 
	iconst_1 
	ixor 
	istore 2 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 2 
	invokevirtual java/io/PrintStream/print(Z)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iconst_1 
	iconst_0 
	iand 
	istore 2 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 2 
	invokevirtual java/io/PrintStream/print(Z)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iconst_1 
	iconst_0 
	ior 
	istore 2 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 2 
	invokevirtual java/io/PrintStream/print(Z)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iconst_1 
	istore 2 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 2 
	invokevirtual java/io/PrintStream/print(Z)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	ldc 2 
	istore 1 
	ldc 5.000000 
	fstore 3 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "haha" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iload 1 
	ldc 2 
	isub 
	ifle L5 
	iconst_0 
	goto L6 
L5: 
	iconst_1 
L6: 
	ifeq L7 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "m<=two\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iload 1 
	ldc 2 
	isub 
	ifeq L9 
	iconst_0 
	goto L10 
L9: 
	iconst_1 
L10: 
	ifeq L11 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "m==two\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
L11: 
L7: 
	ldc 0 
	istore 1 
L13: 
	iload 1 
	ldc 10 
	isub 
	iflt L14 
	iconst_0 
	goto L15 
L14: 
	iconst_1 
L15: 
	ifeq L16 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 1 
	invokevirtual java/io/PrintStream/print(I)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iload 1 
	ldc 1 
	iadd 
	istore 1 
	ldc 0 
	putstatic test9/i I 
L17: 
	getstatic test9/i I 
	ldc 5 
	isub 
	iflt L18 
	iconst_0 
	goto L19 
L18: 
	iconst_1 
L19: 
	ifeq L20 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "a" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	getstatic test9/i I 
	ldc 1 
	iadd 
	putstatic test9/i I 
	goto L17 
L20: 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	goto L13 
L16: 
	ldc 1 
	istore 4 
L21: 
	iload 4 
	ldc 11 
	isub 
	iflt L22 
	iconst_0 
	goto L23 
L22: 
	iconst_1 
L23: 
	ifeq L24 
	ldc 0 
	putstatic test9/i I 
L25: 
	getstatic test9/i I 
	ldc 3 
	isub 
	ifne L26 
	iconst_0 
	goto L27 
L26: 
	iconst_1 
L27: 
	ifeq L28 
	iload 4 
	ldc 2 
	isub 
	ifeq L29 
	iconst_0 
	goto L30 
L29: 
	iconst_1 
L30: 
	ifeq L31 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "h" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	goto L32 
L31: 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
L32: 
	getstatic test9/i I 
	ldc 1 
	iadd 
	putstatic test9/i I 
	goto L25 
L28: 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	iload 4 
	ldc 1 
	iadd  
	istore 4 
	goto L21 
L24: 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 1 
	invokevirtual java/io/PrintStream/print(I)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc 1 
	ldc 2 
	imul 
	ldc 3 
	iload 1 
	ldc 10 
	isub 
	ifge L33 
	iconst_0 
	goto L34 
L33: 
	iconst_1 
L34: 
	iload 1 
	ineg 
	istore 5 
	istore 6 
	istore 7 
	i2f 
	iload 7 
	iload 6 
	iload 5 
	i2f 
	invokestatic test9/notFunAtAll(FIZF)F 
	fneg 
	invokevirtual java/io/PrintStream/print(F)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	invokestatic test9/ppp()V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc 1 
	ldc 3 
	iconst_0 
	iload 1 
	istore 5 
	istore 6 
	istore 7 
	i2f 
	iload 7 
	iload 6 
	iload 5 
	i2f 
	invokestatic test9/notFunAtAll(FIZF)F 
	invokevirtual java/io/PrintStream/print(F)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	ldc 5 
	ldc 5.000000 
	fstore 5 
	i2f 
	fload 5 
	invokestatic test9/cmp(FF)Z 
	istore 2 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	iload 2 
	invokevirtual java/io/PrintStream/print(Z)V 
	getstatic java/lang/System/out Ljava/io/PrintStream; 
	ldc "\n" 
	invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V 
	return 
.end method 
