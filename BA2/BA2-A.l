%{
	#include <stdio.h>
%}
science1 ^[0-9]+[Ee][+-]?[0-9]+[\n]
science2 ^[0-9]+[\.][0-9]+[Ee][+-]?[0-9]+[\n]
science3 ^[0-9]+[\.][Ee][+-]?[0-9]+[\n]
science4 ^[\.][0-9]+[Ee][+-]?[0-9]+[\n]
limited1 ^[0-9]+[\.][0-9]+[\n]
limited2 ^[0-9]+[\.][\n]
limited3 ^[\.][0-9]+[\n]
other .
%%
{science1}	{ ECHO; }
{science2}	{ ECHO; }
{science3}	{ ECHO; }
{science4}	{ ECHO; }
{limited1}  { ECHO; }
{limited2}  { ECHO; }
{limited3}	{ ECHO; }
{other} {}
%%
int yywrap() {
	return 1;
}

int main() {
	yylex();
	return 0;
}