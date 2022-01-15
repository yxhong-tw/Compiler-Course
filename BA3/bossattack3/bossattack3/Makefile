all: list.yy.c list.tab.c
	gcc list.tab.c list.yy.c
list.yy.c: list.l
	flex  -o list.yy.c list.l

list.tab.c: list.y
	bison -d -o list.tab.c list.y 

clean:
	rm a.out list.yy.c list.tab.c list.tab.h