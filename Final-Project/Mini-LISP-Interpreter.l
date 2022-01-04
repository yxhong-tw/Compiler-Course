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

"and" {
	return AND;
}

"or" {
	return OR;
}

"not" {
	return NOT;
}

"#t" {
	return BOOL_TRUE;
}

"#f" {
	return BOOL_FALSE;
}

"print-num" {
	return PRINT_NUM;
}

"print-bool" {
	return PRINT_BOOL;
}

"if" {
	return IF_WORD;
}

<<EOF>> {
	return END;
}

%%