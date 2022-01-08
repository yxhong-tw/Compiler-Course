%{
    #include <stdio.h>
    #include <string.h>
    
    int i;  // loop counter
    int inFunction = 0; // 0 -> not in function, 1 -> in function
    int counter;

    struct DataTableType variableTable; // variables' table
    // variableTable.size = 0;

    struct FunctionTableType functionTable;
    // functionTable.pointer = -1;
    // functionTable.size = 0;
%}

%code requires {
    struct DataType {
        char *type; // "int", "bool"
        int intValue;
        char *boolValue;    // "#t", "#f"
        char *varValue; // variable's name
        int functionIndex;
    };

    struct DataTableType {
        int size;
        struct DataType table[1000];
    };

    struct FunctionType {
        char *name;
        int functionIndex;  // -2 -> value, -1 -> global variable
    };

    struct FunctionTableType {
        int pointer;
        int size;
        struct FunctionType table[1000];
    };
}

%union{
    int integer;
    char *string;
    struct DataType dataType;
    struct DataTableType dataTableType;
    struct FunctionType functionType;
    struct FunctionTableType functionTableType;
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
%token LAMBDA

%type PROGRAM
%type STMTS
%type STMT
%type DEF_STMT
%type PRINT_STMT
%type <dataType> EXP
%type <dataTableType> MULTI_EXP
%type <dataType> NUM_OP
%type <dataType> LOGICAL_OP
%type <dataType> IF_EXP
%type <dataType> FUN_EXP
%type <dataTableType> MULTI_VARIABLE
%type <functionType> FUN_PART
%type FUN_PARAM

%%

PROGRAM
    :STMTS
    ;

STMTS
    :STMT STMTS
    |END
    ;

STMT
    :EXP
    |DEF_STMT
    |PRINT_STMT
    ;

EXP
    :NUMBER {
        $$.type = "int";
        $$.intValue = $1;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;  // -2 for value
        }
        else {  // inFunction == 1
            $$.functionIndex = functionTable.pointer;
        }
    }
    |BOOL_TRUE {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "#t";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;  // -2 for value
        }
        else {  // inFunction == 1
            $$.functionIndex = functionTable.pointer;
        }
    }
    |BOOL_FALSE {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "#f";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;  // -2 for value
        }
        else {  // inFunction == 1
            $$.functionIndex = functionTable.pointer;
        }
    }
    |VARIABLE {
        if(inFunction == 0) {
            for(i = 0; i < variableTable.size; i++) {
                // 0 -> equal, -1 for global variable
                if(strcmp(variableTable.table[i].varValue, $1) == 0 && variableTable.table[i].functionIndex == -1) {
                    $$ = variableTable.table[i];
                    break;
                }
                else if(i == variableTable.size - 1) {
                    yyerror("The variable does not exist.");
                }
                else {
                    printf("Impossible part1\n");
                }
            }
        }
        else {  // inFunction == 1
            for(i = 0; i < variableTable.size; i++) {
                if(strcmp(variableTable.table[i].varValue, $1) == 0 && variableTable.table[i].functionIndex == functionTable.pointer) {
                    $$ = variableTable.table[i];
                    break;
                }
                else if(i == variableTable.size - 1) {
                    yyerror("The variable does not exist.");
                }
                else {
                    printf("Impossible part2\n");
                }
            }
        }
    }
    |NUM_OP
    |LOGICAL_OP
    |IF_EXP
    |FUN_EXP
    ;

MULTI_EXP
    :MULTI_EXP EXP {
        $$ = $1;
        $$.table[$$.size] = $2; // size also the beginning index of empty space
        $$.size += 1;
    }
    |EXP EXP {
        $$.table[0] = $1;
        $$.table[1] = $2;
        $$.size = 2;
    }
    ;

DEF_STMT
    :LS DEFINE_WORD VARIABLE EXP RS {
        if(inFunction == 0) {   // define in global
            for(i = 0; i < variableTable.size; i++) {
                // find
                if(strcmp(variableTable.table[i].varValue, $3) == 0 && variableTable.table[i].functionIndex == -1) {
                    variableTable.table[i] = $4;    // replace old one to new one
                    variableTable.table[i].varValue = $3;
                }
                else if(i == variableTable.size - 1) {  // not find
                    variableTable.table[variableTable.size] = $4;   // save a new variable into table
                    variableTable.table[variableTable.size].varValue = $3;
                    variableTable.table[variableTable.size].functionIndex = -1;
                    variableTable.size += 1;
                }
            }
        }
        else {  // inFunction == 1
            // TODO: but not do will not affect result in public data
        }
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
    :LS PLUS MULTI_EXP RS {
        $$.type = "int";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].type == "int") {
                $$.intValue += $3.table[i].intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
    }
    |LS MINUS EXP EXP RS {
        $$.type = "int";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            $$.intValue = $3.intValue - $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS MULTIPLY MULTI_EXP RS {
        $$.type = "int";
        $$.intValue = 1;    // mul need 1
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].type == "int") {
                $$.intValue *= $3.table[i].intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
    }
    |LS DEVIDE EXP EXP RS {
        $$.type = "int";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            $$.intValue = $3.intValue / $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS MODULUS EXP EXP RS {
        $$.type = "int";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            $$.intValue = $3.intValue % $4.intValue;
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS GREATER EXP EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            if($3.intValue > $4.intValue) {
                $$.boolValue = "#t";
            }
            else {
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS SMALLER EXP EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            if($3.intValue < $4.intValue) {
                $$.boolValue = "#t";
            }
            else {
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    |LS EQUAL EXP EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type == "int" && $4.type == "int") {
            if($3.intValue == $4.intValue) {
                $$.boolValue = "#t";
            }
            else {
                $$.boolValue = "#f";
            }
        }
        else {
            yyerror("Type is not integer.");
        }
    }
    ;

LOGICAL_OP
    :LS AND MULTI_EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].type != "bool") {
                yyerror("Type is not bool.");
            }
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].boolValue != "#t") {
                $$.boolValue = "#f";
                break;
            }
            else if(i == $3.size - 1) {
                $$.boolValue = "#t";
            }
        }
    }
    |LS OR MULTI_EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].type != "bool") {
                yyerror("Type is not bool.");
            }
        }

        for(i = 0; i < $3.size; i++) {
            if($3.table[i].boolValue != "#f") {
                $$.boolValue = "#t";
                break;
            }
            else if(i == $3.size - 1) {
                $$.boolValue = "#f";
            }
        }
    }
    |LS NOT EXP RS {
        $$.type = "bool";
        $$.intValue = 0;
        $$.boolValue = "";
        $$.varValue = "";

        if(inFunction == 0) {
            $$.functionIndex = -2;
        }
        else {
            $$.functionIndex = functionTable.pointer;
        }

        if($3.type != "bool") {
            yyerror("Type is not bool.");
        }

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

FUN_PART
    :LAMBDA LS VARIABLE RS {

        inFunction = 1;

        $$.name = "";
        $$.functionIndex = functionTable.size;

        functionTable.pointer = $$.functionIndex;
        functionTable.size += 1;
        functionTable.table[$$.functionIndex] = $$;

        for(i = 0; i < variableTable.size; i++) {
            // find
            if(strcmp(variableTable.table[i].varValue, $3) == 0 && variableTable.table[i].functionIndex == $$.functionIndex) {
                yyerror("There are same name parameters.");
            }
            else if(i == variableTable.size - 1) {  // not find
                variableTable.table[variableTable.size].type = "";
                variableTable.table[variableTable.size].intValue = 0;
                variableTable.table[variableTable.size].boolValue = "";
                variableTable.table[variableTable.size].varValue = $3;
                variableTable.table[variableTable.size].functionIndex = $$.functionIndex;
                variableTable.size += 1;
            }
        }

        printf("a\n");
    }
    ;

FUN_PARAM
    :EXP {
        printf("b\n");
        counter = 0;

        for(i = 0; i < variableTable.size; i++) {
            if(variableTable.table[i].functionIndex == $1.functionIndex) {
                counter += 1;
            }
        }

        if(counter != 1) {
            yyerror("The number of parameter(s) and value(s) can not be match.");
        }
        else {
            for(i = 0; i < variableTable.size; i++) {
                if(variableTable.table[i].functionIndex == $1.functionIndex) {
                    $1.varValue = variableTable.table[i].varValue;
                    variableTable.table[i] = $1;
                    break;
                }
            }
        }
    }
    |MULTI_EXP {
        counter = 0;

        for(i = 0; i < variableTable.size; i++) {
            if(variableTable.table[i].functionIndex == $1.table[0].functionIndex) {
                counter += 1;
            }
        }

        if(counter != $1.size) {
            yyerror("The number of parameter(s) and value(s) can not be match.");
        }
        else {
            counter = 0;

            for(i = 0; i < variableTable.size; i++) {
                if(variableTable.table[i].functionIndex == $1.table[counter].functionIndex) {
                    $1.table[counter].varValue = variableTable.table[i].varValue;
                    variableTable.table[i] = $1.table[counter];
                    counter += 1;

                    if(counter >= $1.size) {
                        break;
                    }
                }
            }
        }
    }
    ;

FUN_EXP
    :LS LS FUN_PART EXP RS FUN_PARAM RS{
        printf("HELLO\n");
        $$ = $4;
    }
    ;

MULTI_VARIABLE
    :MULTI_VARIABLE VARIABLE {
        $$ = $1;    // TODO: un optimize
        $$.stack[$$.pointer].varValue = $2;
        $$.stack[$$.pointer].type = "";
        $$.stack[$$.pointer].intValue = 0;
        $$.stack[$$.pointer].boolValue = "";
        $$.stack[$$.pointer].inFunction = 1;

        $$.pointer += 1;
    }
    |VARIABLE VARIABLE {
        $$.stack[0].varValue = $1;
        $$.stack[0].type = "";
        $$.stack[0].intValue = 0;
        $$.stack[0].boolValue = "";
        $$.stack[0].inFunction = 1;
        $$.stack[1].varValue = $2;
        $$.stack[1].type = "";
        $$.stack[1].intValue = 0;
        $$.stack[1].boolValue = "";
        $$.stack[1].inFunction = 1;

        $$.pointer = 2;
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