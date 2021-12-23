%{
#include <stdio.h>

int pointer = 0;
int stack[100] = {0};

int temp1, temp2;
%}

%union{
    int integer;
    char *string;
}

%token<string> load
%token<string> add
%token<string> sub
%token<string> mul
%token<string> mod
%token<string> inc
%token<string> dec
%token<string> space
%token<integer> number
%token<string> newLine
%token<integer> EEOF

%%

commands :command

command :load space number newLine { temp1 = $3; stack[pointer] = temp1; pointer += 1; } command
    |add newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; pointer -= 1; temp2 = stack[pointer]; stack[pointer] = 0; temp1 += temp2; stack[pointer] = temp1; pointer += 1; } command
    |sub newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; pointer -= 1; temp2 = stack[pointer]; stack[pointer] = 0; temp1 -= temp2; stack[pointer] = temp1; pointer += 1; } command
    |mul newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; pointer -= 1; temp2 = stack[pointer]; stack[pointer] = 0; temp1 *= temp2; stack[pointer] = temp1; pointer += 1; } command
    |mod newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; pointer -= 1; temp2 = stack[pointer]; stack[pointer] = 0; temp1 %= temp2; stack[pointer] = temp1; pointer += 1; } command
    |inc newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; temp1 += 1; stack[pointer] = temp1; pointer += 1; } command
    |dec newLine { pointer -= 1; temp1 = stack[pointer]; stack[pointer] = 0; temp1 -= 1; stack[pointer] = temp1; pointer += 1; } command
    |EEOF { if(pointer == 1) { printf("%d\n", stack[pointer-1]); }else { printf("Invalid format\n"); } }
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