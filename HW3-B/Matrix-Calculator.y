%{
    #include <stdio.h>

    int temp;
%}

%code requires {
    struct Matrix {
        int num1;
        int num2;
    };
}

%union{
    int integer;
    struct Matrix matrix;
}

%token<integer> INTEGER
%token<integer> ADD
%token<integer> SUB
%token<integer> MUL
%token<integer> LSB
%token<integer> RSB
%token<integer> LS
%token<integer> RS
%token<integer> COMMA
%token<integer> TRANSPOSE
%token<integer> EOI

%type<matrix> MATRIX

%left ADD SUB
%left MUL 
%left TRANSPOSE

%%

line
    :MATRIX EOI {
        printf("Accepted\n");
        return 0;
    }
    ;

MATRIX
    :LS MATRIX RS { // (MATRIX)
        $$.num1 = $2.num1;
        $$.num2 = $2.num2;
    }
    |MATRIX TRANSPOSE { // MATRIX^T
        $$.num1 = $1.num2;
        $$.num2 = $1.num1;
    }
    |MATRIX MUL MATRIX {    // MATRIX*MATRIX
        if($1.num2 == $3.num1) {
            $$.num1 = $1.num1;
            $$.num2 = $3.num2;
        }
        else {
            temp = $2;
            printf("Semantic error on col %d\n", temp - 1);
            return 0;
        }
    }
    |MATRIX ADD MATRIX {    // MATRIX+MATRIX
        if($1.num1 == $3.num1 && $1.num2 == $3.num2) {
            $$.num1 = $1.num1;
            $$.num2 = $1.num2;
        }
        else {
            temp = $2;
            printf("Semantic error on col %d\n", temp - 1);
            return 0;
        }
    }
    |MATRIX SUB MATRIX {    // MATRIX-MATRIX
        if($1.num1 == $3.num1 && $1.num2 == $3.num2) {
            $$.num1 = $1.num1;
            $$.num2 = $1.num2;
        }
        else {
            temp = $2;
            printf("Semantic error on col %d\n", temp - 1);
            return 0;
        }
    }
    |LSB INTEGER COMMA INTEGER RSB {    // [INTEGER,INTEGER]
        $$.num1 = $2;
        $$.num2 = $4;
    }
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