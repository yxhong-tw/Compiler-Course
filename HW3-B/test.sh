bison -d -o Matrix-Calculator.tab.c Matrix-Calculator.y
gcc -c -g -I.. Matrix-Calculator.tab.c
flex -o Matrix-Calculator.yy.c Matrix-Calculator.l
gcc -c -g -I.. Matrix-Calculator.yy.c
gcc -o Matrix-Calculator Matrix-Calculator.tab.o Matrix-Calculator.yy.o -ll