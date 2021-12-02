%{
    #include <iostream>
    #include <string>
    using namespace std;
    int i = 0;
    int sharp_num = 0;
    int isList = 0;
    int isQuote = 0;
    int isStrong = 0;
    string content = "";
    string name = "";
    string hlink = "";
%}
title ^[#]+[a-zA-Z0-9 ]+
split ^[-][-][-]
image ^[!][\[][a-zA-Z0-9 ]+[\]][\(].+[\)]
multi ^[-][ ][\[][X]?[\]][ ][a-zA-Z0-9 ]+
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

    cout << "<h" << sharp_num << ">";

    for(i; i < yyleng; i++) {
        cout << yytext[i];
    }

    cout << "</h" << sharp_num << ">" << endl;
}
{split} {
    if(isList == 1) {
        cout << "</ul>" << endl;
        isList = 0;
    }
    else if(isQuote == 1) {
        cout << "</blockquote>" << endl;
        isQuote = 0;
    }
    cout << "<hr />" << endl;
}
{image} {
    content = "";
    name = "";
    hlink = "";
    content += "<img alt=\"";
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            i += 1;
            for(i; i < yyleng; i++) {
                if(yytext[i] != ']') {
                    name += yytext[i];
                }
                else {
                    break;
                }
            }
        }
        else if(yytext[i] == '(') {
            i += 1;
            for(i; i < yyleng; i++) {
                if(yytext[i] != ')') {
                    hlink += yytext[i];
                }
                else {
                    break;
                }
            }
        }
    }
    content += (name + "\" src=\"" + hlink + "\">");

    cout << content << endl;
}
{multi} {
    cout << "<p>" << endl;
    cout << "\t" << "<input ";
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            if(yytext[i+1] == 'X') {
                cout << "checked=\"checked\" type=\"checkbox\" /> ";
            }
            else {
                cout << "type=\"checkbox\" /> ";
            }
            i += 4;
            break;
        }
    }
    for(i; i < yyleng; i++) {
        cout << yytext[i];
    }
    cout << endl << "</p>" << endl;
}
{list} {
    if(isList == 0) {
        cout << "<ul>" << endl;
        isList = 1;
    }

    cout << "\t<li>";

    i = 2;
    for(i; i < yyleng; i++) {
        cout << yytext[i];
    }

    cout << "</li>" << endl;
}
{hyperlink} {
    name = "";
    hlink = "";
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '[') {
            i += 1;
            for(i; i < yyleng; i++) {
                if(yytext[i] != ']') {
                    name += yytext[i];
                }
                else {
                    break;
                }
            }
        }
        else if(yytext[i] == '(') {
            i += 1;
            for(i; i < yyleng; i++) {
                if(yytext[i] != ')') {
                    hlink += yytext[i];
                }
                else {
                    break;
                }
            }
        }
    }
    cout << "<a href=\"" << hlink << "\">" << endl;
    cout << "\t<span>" << name << "</span>" << endl;
    cout << "</a>" << endl;
}
{quote} {
    if(isQuote == 0) {
        cout << "<blockquote>" << endl;
        isQuote = 1;
    }
    
    for(i = 0; i < yyleng; i++) {
        if(yytext[i] == '*' && yytext[i+1] == '*') {
            if(isStrong == 0) {
                cout << "<strong>";
            }
            else {
                cout << "</strong>";
            }
            i += 1;
        }
        cout << yytext[i];
    }
    cout << endl;
}
%%
int yywrap() {
	return 1;
}

int main() {
	yylex();
	return 0;
}