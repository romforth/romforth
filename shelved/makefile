all : ast.tab
	./ast.raku
	echo -n '[]' | ./$<
ast.tab : ast.tab.c
ast.tab.c : ast.y
	bison ast.y
clean:
	rm -f ast.tab ast.tab.c
