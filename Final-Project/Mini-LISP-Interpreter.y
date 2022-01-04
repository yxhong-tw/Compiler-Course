%{
    #include <stdio.h>
    #include <string.h>
    
    int i;
    int temp;
    int pointer = 0;
    int table_pointer = 0;
    char *temp_string;
    struct DataType element;
%}

%code requires {
    struct DataType {
        char *type;
        int intValue;
        char *boolValue;
        char *varValue;
    };

    struct StackType {
        int pointer;
        struct DataType stack[1000];
    };

    struct DataType variables_table[1000];
}

%union{
    int integer;
    char *string;
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
%token AND
%token OR
%token NOT
%token BOOL_TRUE
%token BOOL_FALSE
%token PRINT_NUM
%token PRINT_BOOL
%token <integer> NUMBER
%token END
%token IF_WORD
%token DEFINE_WORD
%token <string> VARIABLE

%type PROGRAM
%type STMTS
%type STMT
%type DEF_STMT
%type PRINT_STMT
%type <datatype> EXP
%type <stacktype> MULTI_EXP
%type <datatype> NUM_OP
%type <datatype> LOGICAL_OP
%type <datatype> IF_EXP

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
    |DEF_STMT
    |PRINT_STMT
    ;

EXP
    :NUMBER {
        $$.type = "int";
        $$.intValue = $1;
    }
    |BOOL_TRUE {
        $$.type = "bool";
        $$.boolValue = "#t";
    }
    |BOOL_FALSE {
        $$.type = "bool";
        $$.boolValue = "#f";
    }
    |VARIABLE {
        temp = 0;

        for(i = 0; i < table_pointer; i++) {
            if(strcmp(variables_table[i].varValue, $1) == 0) {
                $$ = variables_table[i];

                temp = 1;

                break;
            }
        }

        if(temp == 0) {
            yyerror("The variable does not exist.");
        }
    }
    |NUM_OP
    |LOGICAL_OP
    |IF_EXP
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

DEF_STMT
    :LS DEFINE_WORD VARIABLE EXP RS {
        variables_table[table_pointer].varValue = $3;
        // element.varValue = $3;

        if($4.type == "int") {
            // element.type = "int";
            // element.intValue = $4.intValue;
            variables_table[table_pointer].type = "int";
            variables_table[table_pointer].intValue = $4.intValue;
        }
        else {
            // element.type = "bool";
            // element.boolValue = $4.boolValue;
            variables_table[table_pointer].type = "bool";
            variables_table[table_pointer].boolValue = $4.boolValue;
        }

        // variables_table[table_pointer] = element;
        table_pointer += 1;
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

LOGICAL_OP
    :LS AND EXP EXP RS {
        if($3.type == "bool" && $4.type == "bool") {
            $$.type = "bool";

            if($3.boolValue == "#t" && $4.boolValue == "#t") {
                $$.boolValue = "#t";
            }
            else {
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not bool.");
        }
    }
    |LS AND MULTI_EXP RS {
        temp = 1;

        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].type != "bool") {
                yyerror("Type is not bool.");
            }
        }

        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].boolValue != "#t") {
                temp = 0;
                break;
            }
        }

        $3.pointer = 0;

        $$.type = "bool";

        if(temp == 1) {
            $$.boolValue = "#t";
        }
        else {
            $$.boolValue = "#f";
        }
    }
    |LS OR EXP EXP RS {
        if($3.type == "bool" && $4.type == "bool") {
            $$.type = "bool";

            if($3.boolValue == "#t" || $4.boolValue == "#t") {
                $$.boolValue = "#t";
            }
            else {
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not bool.");
        }
    }
    |LS OR MULTI_EXP RS {
        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].type != "bool") {
                yyerror("Type is not bool.");
            }
        }

        temp = 0;

        for(i = $3.pointer - 1; i >= 0; i--) {
            if($3.stack[i].boolValue == "#t") {
                temp = 1;
                break;
            }
        }

        $3.pointer = 0;

        $$.type = "bool";

        if(temp == 1) {
            $$.boolValue = "#t";
        }
        else {
            $$.boolValue = "#f";
        }
    }
    |LS NOT EXP RS {
        if($3.type != "bool") {
            yyerror("Type is not bool.");
        }

        $$.type = "bool";

        if($3.boolValue == "#t") {
            $$.boolValue = "#f";
        }
        else {
            $$.boolValue = "#t";
        }
    }
    ;

IF_EXP
    :LS IF_WORD EXP EXP EXP RS {
        if($3.type == "bool") {
            if($3.boolValue == "#t") {
                $$ = $4;
            }
            else {
                $$ = $5;
            }
        }
        else {
            yyerror("Type is not bool.");
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