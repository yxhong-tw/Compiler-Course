%{
#include "Stack-Base-Machine.tab.h"
int eof;
%}

load (load)
add (add)
sub (sub)
mul (mul)
mod (mod)
inc (inc)
dec (dec)
space [ ]
number [0-9]+
newLine (\n)

%%

{load} {yylval.string = strdup(yytext); return load;}
{add} {yylval.string = strdup(yytext); return add;}
{sub} {yylval.string = strdup(yytext); return sub;}
{mul} {yylval.string = strdup(yytext); return mul;}
{mod} {yylval.string = strdup(yytext); return mod;}
{inc} {yylval.string = strdup(yytext); return inc;}
{dec} {yylval.string = strdup(yytext); return dec;}
{space} {yylval.string = strdup(yytext); return space;}
{number} {yylval.integer = atoi(yytext); return number;}
{newLine} {yylval.string = strdup(yytext); return newLine;}
<<EOF>> { eof = 1; yylval.integer = eof; return EEOF; }

%%