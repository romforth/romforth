all : ast.tab
	cat ../../rom.4th | ../../fpp -DTESTROM -c fpp.config | sed 's/\[.*//' | ./ast.raku
	echo -n '' | ./$<
	echo 'B1' | ./$<
	echo 'B1 2' | ./$<
	cat test | ./$<
ast.tab : ast.tab.c
ast.tab.c : ast.y
	bison ast.y
clean:
	rm -f ast.tab ast.tab.c
