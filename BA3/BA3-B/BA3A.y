%{
    #include <stdio.h>

    int temp;
%}

%code requires {
}

%union{
    int integer;
}

%token <integer> ITEM

%%

S
    :Sum
    ;

Sum
    :Term ADDITION Sum
    |Term

Term
    :List MULTIPLY MulDigit
    |MulDigit MULTIPLY List
    |MulDigit MULTIPLY List MULTIPLY MulDigit
    |List

MulDigit
    :MulDigit MULTIPLY DIGITS
    |DIGITS

List
    :LBRACKET ListItem RBRACKET

ListItem
    :DIGITS COMMA ListItem
    |DIGITS

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