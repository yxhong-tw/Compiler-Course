/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_MINI_LISP_INTERPRETER_TAB_H_INCLUDED
# define YY_YY_MINI_LISP_INTERPRETER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 1 "Mini-LISP-Interpreter.y"

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
        struct DataType table[1000];
    } dtt;

    int i;  // loop counter
    int variableCounter;
    int currentFunctionIndex;
    int functionIndexStackPointer = 0;
    int functionIndexStack[1000];

    struct DataTableType variableTable; // variables' table
    struct DataTableType functionTable; // functions' table

    dt travel(dt data, int functionIndex) {
        struct DataTableType variables;
        variables.size = 0;

        for(int j = 0; j < variableTable.size; j++) {
            if(variableTable.table[j].functionIndex == functionIndex) {
                variables.table[variables.size] = variableTable.table[j];
                variables.size += 1;
            }
        }

        for(int j = 0; j < data.elementPointer; j++) {
            if(strlen(data.element[j]->operator) != 0) {
                *data.element[j] = travel(*data.element[j], functionIndex);
            }
            else {
                for(int k = 0; k < variables.size; k++) {
                    if(strcmp(data.element[j]->varValue, variables.table[k].varValue) == 0) {
                        *data.element[j] = variables.table[k];
                    }
                }
            }
        }

        dt ret_data;

        if(data.operator == "+") {
            ret_data.type = "int";
            ret_data.intValue = 0;

            for(int j = 0; j < data.elementPointer; j++) {
                if(strcmp(data.element[j]->type, "int") == 0) {
                    ret_data.intValue += data.element[j]->intValue;
                }
                else {
                    printf("Type error\n");
                    exit(0);
                }
            }
        }
        else if(data.operator == "-") {
            ret_data.type = "int";

            if(strcmp(data.element[0]->type, "int") == 0 && strcmp(data.element[1]->type, "int") == 0) {
                ret_data.intValue = data.element[0]->intValue - data.element[1]->intValue;
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

#line 280 "Mini-LISP-Interpreter.tab.h"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LS = 258,
    RS = 259,
    PLUS = 260,
    MINUS = 261,
    MULTIPLY = 262,
    DEVIDE = 263,
    MODULUS = 264,
    GREATER = 265,
    SMALLER = 266,
    EQUAL = 267,
    AND = 268,
    OR = 269,
    NOT = 270,
    NUMBER = 271,
    BOOL_TRUE = 272,
    BOOL_FALSE = 273,
    PRINT_NUM = 274,
    PRINT_BOOL = 275,
    DEFINE_WORD = 276,
    IF_WORD = 277,
    VARIABLE = 278,
    LAMBDA = 279,
    END = 280
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 236 "Mini-LISP-Interpreter.y"

    int integer;
    char *string;
    struct DataType dataType;
    struct DataTableType dataTableType;

#line 324 "Mini-LISP-Interpreter.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_MINI_LISP_INTERPRETER_TAB_H_INCLUDED  */
