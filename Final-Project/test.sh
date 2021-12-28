bison -d -o Mini-LISP-Interpreter.tab.c Mini-LISP-Interpreter.y
gcc -c -g -I.. Mini-LISP-Interpreter.tab.c
flex -o Mini-LISP-Interpreter.yy.c Mini-LISP-Interpreter.l
gcc -c -g -I.. Mini-LISP-Interpreter.yy.c
gcc -o Mini-LISP-Interpreter Mini-LISP-Interpreter.tab.o Mini-LISP-Interpreter.yy.o -ll