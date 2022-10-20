	[ x < c	// x == some random value in the bx register
key	[ c
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
+	[ c+1
dec	[ c
dup	[ c c
neg	[ c -c
neg	[ c c
inv	[ c ~c
inv	[ c c
nip	[ c
dip	[ c c
emit	[ c c > c
drop	[ c
bye
