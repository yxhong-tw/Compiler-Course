/* flex -o lex.yy.c Coding_Style.l
   gcc -o Coding_Style lex.yy.c */
%{
	#include <stdio.h>
	int tabCounter = 0;
	int i = 0;
%}
addTabLine [^\n{]*[{]
subTabLine [^\n}]*[}]
commonLine [^\n{}]*
%%
{addTabLine}    { for(i = 0; i < tabCounter; i++) { printf("\t"); } ECHO; tabCounter++; }
{subTabLine}    { tabCounter--; for(i = 0; i < tabCounter; i++) { printf("\t"); } ECHO; }
{commonLine}    { for(i = 0; i < tabCounter; i++) { printf("\t"); } ECHO; }
%%
int main() {
	yylex();
	return 0;
}