/*
	flex -o lex.yy.c Coding-Style.l
	gcc -o Coding-Style lex.yy.c
*/

/*
	. -> 除了 \n 之外的任意字符
	- -> 指定範圍(A-Z)
	[] -> 字元集合([ABC]代表有A或B或C就匹配)、(第一個字元是 ^ 代表否定)
	* -> >= 0
	+ -> >= 1
	? -> 0 or 1
	$ -> 結束符
	{} -> 可能出現的次數({1,3}代表可能是1次或3次)
	\ -> 跳脫
	| -> or
	() -> 一般的括號
*/

/*
	follow set
	- add $ into Follow(start symbol)
	- A → BC, First(C) will in Follow(B)
	- A → BC, add Follow(A) into Follow(C)
	- A → BC, if C →  λ, add Follow(A) into Follow(B)
*/

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