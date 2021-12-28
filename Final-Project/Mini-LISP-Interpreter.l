%{
	#include "Mini-LISP-Interpreter.tab.h"
%}

%%

0|[1-9][0-9]*|-[1-9][0-9]* {
	yylval.integer = atoi(yytext);
	return NUMBER;
}

"(" {
	return LS;
}

")" {
	return RS;
}

" "

"+" {
	return PLUS;
}

"-" {
	return MINUS;
}

"*" {
	return MULTIPLY;
}

"/" {
	return DEVIDE;
}

"mod" {
	return MODULUS;
}

">" {
	return GREATER;
}

"<" {
	return SMALLER;
}

"=" {
	return EQUAL;
}

"print-num" {
	return PRINT_NUM;
}

"print-bool" {
	return PRINT_BOOL;
}

<<EOF>> {
	return END;
}

%%