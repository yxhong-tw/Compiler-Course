%{
	#include "Matrix-Calculator.tab.h"
	int counter = 1;
%}

%%

[0-9]+ {
	counter += yyleng;
	yylval.integer = atoi(yytext);
	return INTEGER;
}
[\+] {
	counter += yyleng;
	yylval.integer = counter;
	return ADD;
}
[\-] {
	counter += yyleng;
	yylval.integer = counter;
	return SUB;
}
[\*] {
	counter += yyleng;
	yylval.integer = counter;
	return MUL;
}
[\[] {
	counter += yyleng;
	return LSB;
}
[\]] {
	counter += yyleng;
	return RSB;
}
[\(] {
	counter += yyleng;
	return LS;
}
[\)] {
	counter += yyleng;
	return RS;
}
, {
	counter += yyleng;
	return COMMA;
}
(\^T) {
	counter += yyleng;
	return TRANSPOSE;
}
[\n] {
	counter += yyleng;
	return EOI;
}
[ ] {
	counter += yyleng;
}

%%