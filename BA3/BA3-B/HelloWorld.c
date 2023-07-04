bison -d -o BA3A.tab.c BA3A.y
gcc -c -g -I.. BA3A.tab.c
flex -o BA3A.yy.c BA3A.l
gcc -c -g -I.. BA3A.yy.c
gcc -o BA3A BA3A.tab.o BA3A.yy.o -ll

source ./test.sh