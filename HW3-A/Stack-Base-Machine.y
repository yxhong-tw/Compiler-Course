%{
#include <stdio.h>
#include <stack>

stack<int> fuckStack;
%}

%token instruction space number newLine

%%

commands :command
command :instruction newLine {printf("command without number\n");} command
    |instruction space number newLine {printf("command with number\n");} command
    | {return 0;}
    ;

%%
void yyerror(const char *message) {
    fprintf(stderr, "error: %s\n", message);
}

int yywrap() {
    return 1;
}

int main() {
    yyparse();
    return 0;
}