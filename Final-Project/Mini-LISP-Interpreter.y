%{
    #include <stdio.h>
    
    int i;
    int temp;
    int pointer = 0;
%}

%code requires {
    struct DataType {
        char *type;
        int intValue;
        char *boolValue;
    };

    struct StackType {
        int pointer;
        struct DataType stack[1000];
    };
}

%union{
    int integer;
    struct DataType datatype;
    struct StackType stacktype;
}

%token LS
%token RS
%token PLUS
%token MINUS
%token MULTIPLY
%token DEVIDE
%token MODULUS
%token GREATER
%token SMALLER
%token EQUAL
%token PRINT_NUM
%token PRINT_BOOL
%token <integer> NUMBER
%token END

%type PROGRAM
%type STMTS
%type STMT
%type PRINT_STMT
%type<datatype> EXP
%type<stacktype> MULTI_EXP
%type<datatype> NUM_OP

%%

PROGRAM
    :STMTS
    ;

STMTS
    :STMT STMTS
    |END
    ;

STMT
    :EXP {
        // if($1.type == "int") {
        //     printf("%d", $1.intValue);
        // }
        // else {
        //     printf("%s", $1.boolValue);
        // }
    }
    |PRINT_STMT
    ;

EXP
    :NUMBER {
        $$.type = "int";
        $$.intValue = $1;
    }
    |NUM_OP
    ;

MULTI_EXP
    :MULTI_EXP EXP {
        $$ = $1;
        $$.stack[$$.pointer] = $2;
        $$.pointer += 1;
    }
    |EXP EXP {
        $$.stack[0] = $1;
        $$.stack[1] = $2;
        $$.pointer = 2;
    }
    ;

PRINT_STMT
    :LS PRINT_NUM EXP RS {
        if($3.type == "int") {
            printf("%d", $3.intValue);
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS PRINT_BOOL EXP RS {
        if($3.type == "bool") {
            printf("%s", $3.boolValue);
        }
        else {
            yyerror("Type is not bool.");
        }
    }

NUM_OP
    :LS PLUS EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            $$.type = "int";
            $$.intValue = $3.intValue + $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS PLUS MULTI_EXP RS {
        temp = 0;

        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].type == "int") {
                temp += $3.stack[i].intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }

        $3.pointer = 0;

        $$.type = "int";
        $$.intValue = temp;
    }
    |LS MINUS EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            $$.type = "int";
            $$.intValue = $3.intValue - $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS MULTIPLY EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            $$.type = "int";
            $$.intValue = $3.intValue * $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS MULTIPLY MULTI_EXP RS {
        temp = 1;

        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].type == "int") {
                temp *= $3.stack[i].intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
        
        $3.pointer = 0;

        $$.type = "int";
        $$.intValue = temp;
    }
    |LS DEVIDE EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            $$.type = "int";
            $$.intValue = $3.intValue / $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS MODULUS EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            $$.type = "int";
            $$.intValue = $3.intValue % $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS GREATER EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            if($3.intValue > $4.intValue) {
                $$.type = "bool";
                $$.boolValue = "#t";
            }
            else {
                $$.type = "bool";
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS SMALLER EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            if($3.intValue < $4.intValue) {
                $$.type = "bool";
                $$.boolValue = "#t";
            }
            else {
                $$.type = "bool";
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS EQUAL EXP EXP RS {
        if($3.type == "int" && $4.type == "int") {
            if($3.intValue == $4.intValue) {
                $$.type = "bool";
                $$.boolValue = "#t";
            }
            else {
                $$.type = "bool";
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
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