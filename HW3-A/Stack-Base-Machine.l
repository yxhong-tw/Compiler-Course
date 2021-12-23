%{
#include "Stack-Base-Machine.tab.h"
%}

instruction (load|add|sub|mod|inc|dec)
space [ ]
number [0-9]+
newLine [\n]

%%

{instruction} {return instruction;}
{space} {return space;}
{number} {return number;}
{newLine} {return newLine;}

%%