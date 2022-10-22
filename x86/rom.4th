	[ x < c	// x == some random value in the bx register
key	[ c
dup	[ c c
dup	[ c c c
2drop	[ c
dup	[ c c
dup	[ c c c
neg	[ c c -c
+	[ c 0
+	[ c
dup	[ c c
&	[ c:c&c
dup	[ c c
|	[ c:c|c
dup	[ c c
dup	[ c c c
^	[ c 0
|	[ c
dup	[ c c
dup	[ c c c
-	[ c 0
inc	[ c 1
swap	[ 1 c
+	[ c+1
dec	[ c
dup	[ c c
neg	[ c -c
neg	[ c c
inv	[ c ~c
inv	[ c c
nip	[ c
dip	[ c c
emit	[ c > c
'o'	[ c 'o'
emit	[ c > 'o'
drop	[
114	[ 114 // ascii 'r'
dup	[ 114 114
dup	[ 114 114 114
dup	[ 114 114 114 114
dup	[ 114 114 114 114 114
2 <<	[ 114 114 114 114 114*4
-	[ 114 114 114 -114*3
+	[ 114 114 -114*2
+	[ 114 -114
-	[ 114*2
1 >>	[ 114
emit	[ > 'r'
100	[ 100
@	[ 0x0CBF
0x0CBF	[ 0x0CBF 0x0CBF
dup	[ 0x0CBF 0x0CBF 0x0CBF
here	[ 0x0CBF 0x0CBF 0x0CBF here (here:mem)
@	[ 0x0CBF 0x0CBF 0x0CBF mem
swap	[ 0x0CBF 0x0CBF mem 0x0CBF
here	[ 0x0CBF 0x0CBF mem 0x0CBF here
!	[ 0x0CBF 0x0CBF mem (here:0x0CBF)
swap	[ 0x0CBF mem 0x0CBF
dup	[ 0x0CBF mem 0x0CBF 0x0CBF
here	[ 0x0CBF mem 0x0CBF 0x0CBF here
@	[ 0x0CBF mem 0x0CBF 0x0CBF 0x0CBF
-	[ 0x0CBF mem 0x0CBF 0
+	[ 0x0CBF mem 0x0CBF
swap	[ 0x0CBF 0x0CBF mem
here	[ 0x0CBF 0x0CBF mem here
!	[ 0x0CBF 0x0CBF (here:mem)
-	[ 0
inc	[ 1
state	[ 1 state
c!	[ (state:1)
state	[ state
c@	[ 1
dec	[ 0
't'	[ 0 't'
+	[ 't'
emit	[ > 't'
0x3f8	[ 0x3f8	// serial port #1
dup	[ 0x3f8 0x3f8
p@	[ 0x3f8 'h'
swap	[ 'h' 0x3f8
p!	[ > 'h'
bye
