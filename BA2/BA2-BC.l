%{
    #include <stdio.h>
    int i = 0;
    int j = 0;
    int sharp_num = 0;
    int isList = 0;
    int isQuote = 0;
    int isStrong = 0;
    char content[200];
    char name[200];
    char hlink[200];
%}
title ^[#]+[a-zA-Z0-9 ]+
split ^[-][-][-]
image ^[!][\[][a-zA-Z0-9 ]+[\]][\(].+[\)]
multi ^[-][ ][\[][Xx ][\]][ ][a-zA-Z0-9 ]+
list ^[\*][ ].+
hyperlink ^[\[].+[\]][\(].+[\)]
quote ^[>][ ].+
%%
{title} {
    sharp_num = 0;
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '#') {
            sharp_num += 1;
        }
        else {
            i += 1;
            break;
        }
    }

    printf("<h%d>", sharp_num);

    for(i; i < yyleng; i++) {
        if(yytext[i] != '\0') {
            printf("%c", yytext[i]);
        }
        else {
            break;
        }
    }

    printf("</h%d>", sharp_num);
}
{split} {
    if(isList == 1) {
        printf("</ul>\n");
        isList = 0;
    }
    else if(isQuote == 1) {
        printf("</blockquote>\n");
        isQuote = 0;
    }
    printf("<hr />");
}
{image} {
    memset(content, 0, 200);
    memset(name, 0, 200);
    memset(hlink, 0, 200);
    printf("<img alt=\"");
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            i += 1;
            for(i, j = 0; i < yyleng; i++, j++) {
                if(yytext[i] != ']') {
                    name[j] = yytext[i];
                }
                else {
                    break;
                }
            }
        }
        else if(yytext[i] == '(') {
            i += 1;
            for(i, j = 0; i < yyleng; i++, j++) {
                if(yytext[i] != ')') {
                    hlink[j] = yytext[i];
                }
                else {
                    break;
                }
            }
        }
    }

    for(j = 0; j < 200; j++) {
        if(name[j] != '\0') {
            printf("%c", name[j]);
        }
        else {
            break;
        }
    }

    printf("\" src=\"");

    for(j = 0; j < 200; j++) {
        if(hlink[j] != '\0') {
            printf("%c", hlink[j]);
        }
        else {
            break;
        }
    }

    printf("\">");
}
{multi} {
    printf("<p>\n");
    printf("\t<input ");
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            if(yytext[i+1] == 'X' || yytext[i+1] == 'x') {
                printf("checked=\"checked\" type=\"checkbox\" /> ");
            }
            else {
                printf("type=\"checkbox\" /> ");
            }
            i += 4;
            break;
        }
    }
    for(i; i < yyleng; i++) {
        if(yytext[i] != '\0') {
            printf("%c", yytext[i]);
        }
        else {
            break;
        }
    }
    printf("\n</p>");
}
{list} {
    if(isList == 0) {
        printf("<ul>\n");
        isList = 1;
    }

    printf("\t<li>");

    i = 2;
    for(i; i < yyleng; i++) {
        if(yytext[i] != '\0') {
            printf("%c", yytext[i]);
        }
        else {
            break;
        }
    }

    printf("</li>");
}
{hyperlink} {
    memset(name, 0, 200);
    memset(hlink, 0, 200);
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            i += 1;
            for(i, j = 0; i < yyleng; i++, j++) {
                if(yytext[i] != ']') {
                    name[j] = yytext[i];
                }
                else {
                    break;
                }
            }
        }
        else if(yytext[i] == '(') {
            i += 1;
            for(i, j = 0; i < yyleng; i++, j++) {
                if(yytext[i] != ')') {
                    hlink[j] = yytext[i];
                }
                else {
                    break;
                }
            }
        }
    }
    printf("<a href=\"");

    for(j = 0; j < 200; j++) {
        if(hlink[j] != '\0') {
            printf("%c", hlink[j]);
        }
        else {
            break;
        }
    }
    printf("\">\n");
    printf("\t<span>");
    for(j = 0; j < 200; j++) {
        if(name[j] != '\0') {
            printf("%c", name[j]);
        }
        else {
            break;
        }
    }
    printf("</span>\n");
    printf("</a>");
}
{quote} {
    if(isQuote == 0) {
        printf("<blockquote>\n");
        isQuote = 1;
    }
    
    for(i = 2; i < yyleng; i++) {
        if(yytext[i] == '*' && yytext[i+1] == '*') {
            if(isStrong == 0) {
                printf("<strong>");
                isStrong = 1;
            }
            else {
                printf("</strong>");
                isStrong = 0;
            }
            i += 2;
        }
        if(yytext[i] != '\0') {
            printf("%c", yytext[i]);
        }
    }
}
%%
int yywrap() {
	return 1;
}

int main() {
	yylex();
	return 0;
}