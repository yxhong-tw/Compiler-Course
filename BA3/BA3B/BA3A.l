%{
	#include "BA3A.tab.h"
%}

%%

0|[1-9][0-9]*|-[1-9][0-9]* {
	yylval.integer = atoi(yytext);
	return ITEM;
}

%%