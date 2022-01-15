%code requires {
}

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    typedef struct DataType {
        char *type; // "int", "bool", "func"

        int intValue;
        char *boolValue;    // "#t", "#f"
        char *varValue; // variable's or function's name

        int functionIndex;

        char *operator; // "+", "-", "*", "/", "mod", ">", "<", "=", "and", "or", "not"
        int elementPointer;
        struct DataType *element[1000];
    } dt;

    typedef struct DataTableType {
        int size;
        struct DataType *table[1000];
    } dtt;

    int i;  // loop counter
    int variableCounter;
    int currentFunctionIndex;
    int functionIndexStackPointer = 0;
    int functionIndexStack[1000];

    dtt *variableTable; // variables' table
    dtt *functionTable; // functions' table

    dt *travel(dt *data, int functionIndex) {
        dtt *variables = malloc(sizeof(dtt));
        variables->size = 0;

        for(int j = 0; j < variableTable->size; j++) {
            if(variableTable->table[j]->functionIndex == functionIndex) {
                variables->table[variables->size] = variableTable->table[j];
                variables->size += 1;
            }
        }

        for(int j = 0; j < data->elementPointer; j++) {
            if(strlen(data->element[j]->operator) != 0) {
                data->element[j] = travel(data->element[j], functionIndex);
            }
            else {
                for(int k = 0; k < variables->size; k++) {
                    if(strcmp(data->element[j]->varValue, variables->table[k]->varValue) == 0) {
                        data->element[j] = variables->table[k];
                    }
                }
            }
        }

        dt *ret_data = malloc(sizeof(dt));

        if(data->operator == "+") {
            ret_data->type = "int";
            ret_data->intValue = 0;

            for(int j = 0; j < data->elementPointer; j++) {
                if(strcmp(data->element[j]->type, "int") == 0) {
                    ret_data->intValue += data->element[j]->intValue;
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
            }
        }
        else if(data->operator == "-") {
            ret_data->type = "int";

            if(strcmp(data->element[0]->type, "int") == 0 && strcmp(data->element[1]->type, "int") == 0) {
                ret_data->intValue = data->element[0]->intValue - data->element[1]->intValue;
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else if(data.operator == "*") {
            ret_data.type = "int";
            ret_data.intValue = 1;

            for(int j = 0; j < data.elementPointer; j++) {
                if(strcmp(data.element[j]->type, "int") == 0) {
                    ret_data.intValue *= data.element[j]->intValue;
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
            }
        }
        else if(data.operator == "/") {
                ret_data.type = "int";

                if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                    ret_data.intValue = data.element[0]->intValue / data.element[1]->intValue;
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
        }
        else if(data.operator == "mod") {
            ret_data.type = "int";

            if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                ret_data.intValue = data.element[0]->intValue % data.element[1]->intValue;
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else if(data.operator == ">") {
            ret_data.type = "bool";

            if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                if(data.element[0]->intValue > data.element[1]->intValue) {
                    ret_data.boolValue = "#t";
                }
                else {
                    ret_data.boolValue = "#f";
                }
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else if(data.operator == "<") {
            ret_data.type = "bool";

            if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                if(data.element[0]->intValue < data.element[1]->intValue) {
                    ret_data.boolValue = "#t";
                }
                else {
                    ret_data.boolValue = "#f";
                }
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else if(data.operator == "=") {
            ret_data.type = "bool";

            if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                if(data.element[0]->intValue == data.element[1]->intValue) {
                    ret_data.boolValue = "#t";
                }
                else {
                    ret_data.boolValue = "#f";
                }
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else if(data.operator == "and") {
            ret_data.type = "bool";

            for(int j = 0; j < data.elementPointer; j++) {
                if(strcmp(data.element[j]->type, "bool") == 0) {
                    if(data.element[j]->boolValue != "#t") {
                        ret_data.boolValue = "#f";

                        break;
                    }
                    else {
                        ret_data.boolValue = "#t";
                    }
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
            }
        }
        else if(data.operator == "or") {
            ret_data.type = "bool";

            for(int j = 0; j < data.elementPointer; j++) {
                if(strcmp(data.element[j]->type, "bool") == 0) {
                    if(data.element[j]->boolValue == "#t") {
                        ret_data.boolValue = "#t";

                        break;
                    }
                    else {
                        ret_data.boolValue = "#f";
                    }
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
            }
        }
        else if(data.operator == "not") {
            ret_data.type = "bool";

            if(strcmp(data.element[0]->type, "bool") == 0) {
                if(data.element[0]->boolValue == "#t") {
                    ret_data.boolValue = "#f";
                }
                else {
                    ret_data.boolValue = "#t";
                }
            }
            else {
                printf("Type error\n");
                exit(0);
            }
        }
        else {
            printf("This is impossible case.\n");
        }

        return ret_data;
    }
%}

%union{
    int integer;
    char *string;
    struct DataType dataType;
    struct DataTableType dataTableType;
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
%token <integer> NUMBER
%token BOOL_TRUE
%token BOOL_FALSE
%token PRINT_NUM
%token PRINT_BOOL
%token DEFINE_WORD
%token IF_WORD
%token <string> VARIABLE
%token LAMBDA
%token END

%type PROGRAM
%type STMTS
%type STMT
%type <dataType> EXP
%type <dataTableType> MULTI_EXP
%type DEF_STMT
%type PRINT_STMT
%type <dataType> NUM_OP
%type <dataType> LOGICAL_OP
%type <dataType> IF_EXP
%type <dataType> FUN_EXP_PART
%type <dataType> FUN_EXP
%type FUN_PARAM
%type <dataType> FUN_CALL

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
        for(i = 0; i < variableTable.size; i++) {
            // strcmp: 0 -> equal, functionIndex: -1 -> not any function
            if(strcmp(variableTable.table[i].varValue, $1) == 0 && variableTable.table[i].functionIndex == currentFunctionIndex) {
                $$ = variableTable.table[i];
                break;
            }
            else if(i == variableTable.size - 1) {
                yyerror("The variable does not exist.");
            }
            else {
                printf("Impossible part\n");
            }
        }
    }
    |NUM_OP
    |LOGICAL_OP
    |IF_EXP
    |FUN_CALL
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
        for(i = 0; i < variableTable.size; i++) {
            // strcmp: 0 -> equal
            if(strcmp(variableTable.table[i].varValue, $3) == 0 && variableTable.table[i].functionIndex == currentFunctionIndex) {
                yyerror("This variable name has already been used.");
                // replace old one to new one (document say that there does not allow redefine)
                // variableTable.table[i] = $4;
                // variableTable.table[i].varValue = $3;
            }
            else if(i == variableTable.size - 1) {  // not find
                variableTable.table[variableTable.size] = $4;   // save a new variable into table
                variableTable.table[variableTable.size].varValue = $3;
                variableTable.table[variableTable.size].functionIndex = currentFunctionIndex;
                variableTable.size += 1;
            }
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

        if(currentFunctionIndex != -1) {
            $$.operator = "+";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "+";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            for(i = 0; i < $3.size; i++) {
                *$$.element[$$.elementPointer] = $3.table[i];
                $$.elementPointer += 1;
                // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = itoa($3.table[i].intValue);
                // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            }
        }
        else {
            $$.intValue = 0;

            for(i = 0; i < $3.size; i++) {
                if($3.table[i].type == "int") {
                    $$.intValue += $3.table[i].intValue;
                }
                else {
                    yyerror("Type is not integer.");
                }
            }
        }
    }
    |LS MINUS EXP EXP RS {
        $$.type = "int";

        if(currentFunctionIndex != -1) {
            $$.operator = "-";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "-";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.intValue = 0;

            if($3.type == "int" && $4.type == "int") {
                $$.intValue = $3.intValue - $4.intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
    }
    |LS MULTIPLY MULTI_EXP RS {
        $$.type = "int";

        if(currentFunctionIndex != -1) {
            $$.operator = "*";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "*";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            for(i = 0; i < $3.size; i++) {
                *$$.element[$$.elementPointer] = $3.table[i];
                $$.elementPointer += 1;
                // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.table[i].intValue);
                // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            }
        }
        else {
            $$.intValue = 1;    // mul need 1

            for(i = 0; i < $3.size; i++) {
                if($3.table[i].type == "int") {
                    $$.intValue *= $3.table[i].intValue;
                }
                else {
                    yyerror("Type is not integer.");
                }
            }
        }
    }
    |LS DEVIDE EXP EXP RS {
        $$.type = "int";

        if(currentFunctionIndex != -1) {
            $$.operator = "/";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "/";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.intValue = 0;

            if($3.type == "int" && $4.type == "int") {
                $$.intValue = $3.intValue / $4.intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
    }
    |LS MODULUS EXP EXP RS {
        $$.type = "int";

        if(currentFunctionIndex != -1) {
            $$.operator = "%";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "%";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.intValue = 0;

            if($3.type == "int" && $4.type == "int") {
                $$.intValue = $3.intValue % $4.intValue;
            }
            else {
                yyerror("Type is not integer.");
            }
        }
    }
    |LS GREATER EXP EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = ">";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = ">";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.boolValue = "";

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
    }
    |LS SMALLER EXP EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = "<";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "<";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.boolValue = "";

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
    }
    |LS EQUAL EXP EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = "=";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "=";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($3.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.boolValue = "";

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
    }
    ;

LOGICAL_OP
    :LS AND MULTI_EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = "and";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "and";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            for(i = 0; i < $3.size; i++) {
                *$$.element[$$.elementPointer] = $3.table[i];
                $$.elementPointer += 1;
                // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $3.table[i].boolValue;
                // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            }
        }
        else {
            $$.boolValue = "";

            for(i = 0; i < $3.size; i++) {
                if($3.table[i].type == "bool") {
                    if($3.table[i].boolValue != "#t") {
                        $$.boolValue = "#f";
                        break;
                    }
                    else {
                        $$.boolValue = "#t";
                    }
                }
                else {
                    yyerror("Type is not bool.");
                }
            }
        }
    }
    |LS OR MULTI_EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = "or";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "or";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            for(i = 0; i < $3.size; i++) {
                *$$.element[$$.elementPointer] = $3.table[i];
                $$.elementPointer += 1;
                // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $3.table[i].boolValue;
                // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            }
        }
        else {
            $$.boolValue = "";

            for(i = 0; i < $3.size; i++) {
                if($3.table[i].type == "bool") {
                    if($3.table[i].boolValue != "#f") {
                        $$.boolValue = "#t";
                        break;
                    }
                    else {
                        $$.boolValue = "#f";
                    }
                }
                else {
                    yyerror("Type is not bool.");
                }
            }
        }
    }
    |LS NOT EXP RS {
        $$.type = "bool";

        if(currentFunctionIndex != -1) {
            $$.operator = "not";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "not";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $3.boolValue;
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
        }
        else {
            $$.boolValue = "";

            if($3.type == "bool") {
                if($3.boolValue == "#t") {
                    $$.boolValue = "#f";
                }
                else {
                    $$.boolValue = "#t";
                }
            }
            else {
                yyerror("Type is not bool.");
            }
        }
    }
    ;

IF_EXP
    :LS IF_WORD EXP EXP EXP RS {
        if(currentFunctionIndex != -1) {
            $$.operator = "if";
            $$.elementPointer = 0;
            // functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = "if";
            // functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            *$$.element[$$.elementPointer] = $3;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $4;
            $$.elementPointer += 1;
            *$$.element[$$.elementPointer] = $5;
            $$.elementPointer += 1;
            // if($3.type == "bool") {
            //     functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $3.boolValue;
            //     functionTable.table[currentFunctionIndex].formulaStackPointer += 1;

            //     if($4.type == "bool" && $5.type == "bool") {
            //         $$.type = "bool";
            //         $$.boolValue = "";

            //         functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $4.boolValue;
            //         functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            //         functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = $5.boolValue;
            //         functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            //     }
            //     else {
            //         $$.type = "int";
            //         $$.intValue = 0;

            //         functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($4.intValue);
            //         functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            //         functionTable.table[currentFunctionIndex].formulaStack[functionTable.table[currentFunctionIndex].formulaStackPointer] = atoi($5.intValue);
            //         functionTable.table[currentFunctionIndex].formulaStackPointer += 1;
            //     }
            // }
            // else {
            //     yyerror("Type is not bool.");
            // }
        }
        else {
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
    }
    ;

FUN_EXP_PART
    :LAMBDA LS VARIABLE RS {
        $$.functionIndex = functionTable.size;

        functionIndexStack[functionIndexStackPointer] = currentFunctionIndex;
        functionIndexStackPointer += 1;

        currentFunctionIndex = $$.functionIndex;
        functionTable.size += 1;

        if(variableTable.size == 0) {
            variableTable.table[variableTable.size].type = "";
            variableTable.table[variableTable.size].varValue = $3;
            variableTable.table[variableTable.size].functionIndex = $$.functionIndex;

            variableTable.size += 1;
        }
        else {
            for(i = 0; i < variableTable.size; i++) {
                // strcmp: 0 -> equal
                if(strcmp(variableTable.table[i].varValue, $3) == 0 && variableTable.table[i].functionIndex == $$.functionIndex) {
                    yyerror("There are same name parameters.");
                }
                else if(i == variableTable.size - 1) {  // not find
                    variableTable.table[variableTable.size].type = "";
                    variableTable.table[variableTable.size].varValue = $3;
                    variableTable.table[variableTable.size].functionIndex = $$.functionIndex;

                    variableTable.size += 1;
                }
            }
        }
    }
    ;

FUN_EXP
    :LS FUN_EXP_PART EXP RS {
        $$ = $3;
        $$.functionIndex = $2.functionIndex;
        functionTable.table[$$.functionIndex] = $$;

        functionIndexStackPointer -= 1;
        currentFunctionIndex = functionIndexStack[functionIndexStackPointer];
    }
    ;

FUN_PARAM
    :EXP {
        variableCounter = 0;

        for(i = 0; i < variableTable.size; i++) {
            if(variableTable.table[i].functionIndex == currentFunctionIndex) {
                variableCounter += 1;

                if(variableCounter > 1) {
                    yyerror("The number of parameter and value does not match.");
                }
                else {
                    if($1.type == "int") {
                        variableTable.table[i].intValue = $1.intValue;
                    }
                    else {
                        variableTable.table[i].boolValue = $1.boolValue;
                    }
                }
            }
            else if(i == variableTable.size - 1 && variableCounter == 0) {
                yyerror("The number of parameter and value does not match.");
            }
        }
    }
    ;

FUN_CALL
    :LS FUN_EXP FUN_PARAM RS {
        $$ = travel($2, $2.functionIndex);
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