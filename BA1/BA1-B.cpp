#include <iostream>
#include <vector>

using namespace std;

int main() {
    string input = "";
    getline(cin, input);

    vector<string> tokens, values;
    int in_tag = 0;
    for(int i = 0; i < input.length(); ) {
        if(input.at(i) == '<') {
            if(i != input.length() - 1) {
                if(input.at(i + 1) == '/') {
                    tokens.push_back("TAG_OPEN_SLASH");
                    values.push_back("</");
                    i += 2;
                }
                else {
                    tokens.push_back("TAG_OPEN");
                    values.push_back("<");
                    i += 1;
                }
            }
            in_tag = 1;
        }
        else if(input.at(i) == '>') {
            tokens.push_back("TAG_CLOSE");
            values.push_back(">");
            i += 1;
            in_tag = 0;
        }
        else if(input.at(i) == '=') {
            tokens.push_back("TAG_EQUALS");
            values.push_back("=");
            i += 1;
        }
        else if(input.at(i) == '\'' && in_tag == 1) {
            string temp = "";
            while(true) {
                i++;
                if(i <= input.length()) {
                    if(input.at(i) == '\'') {
                        tokens.push_back("SINGLE_QUOTE_STRING");
                        values.push_back(temp);
                        i++;
                        break;
                    }
                    else {
                        temp += input.at(i);
                    }
                }
                else {
                    cout << "ERROR - 1" << endl;
                    return 0;
                }
            }
        }
        else if(input.at(i) == '\"' && in_tag == 1) {
            string temp = "";
            while(true) {
                i++;
                if(i <= input.length()) {
                    if(input.at(i) == '\"') {
                        tokens.push_back("DOUBLE_QUOTE_STRING");
                        values.push_back(temp);
                        i++;
                        break;
                    }
                    else {
                        temp += input.at(i);
                    }
                }
                else {
                    cout << "ERROR - 2" << endl;
                    return 0;
                }
            }
        }
        else if(((input.at(i) >= 'a' && input.at(i) <= 'z') || (input.at(i) >= 'A' && input.at(i) <= 'Z') || (input.at(i) >= '0' && input.at(i) <= '9')) && in_tag == 1) {
            string temp = "";
            while(true) {
                if(i <= input.length()) {
                    if(!((input.at(i) >= 'a' && input.at(i) <= 'z') || (input.at(i) >= 'A' && input.at(i) <= 'Z') || (input.at(i) >= '0' && input.at(i) <= '9'))) {
                        tokens.push_back("TAG_NAME");
                        values.push_back(temp);
                        break;
                    }
                    else {
                        temp += input.at(i);
                        i += 1;
                    }
                }
                else {
                    cout << "ERROR - 3" << endl;
                    return 0;
                }
            }
        }
        else if(in_tag == 0 && input.at(i) != ' ') {
            string temp = "";
            while(true) {
                if(i <= input.length()) {
                    if(input.at(i) == '<') {
                        tokens.push_back("HTML_TEXT");
                        values.push_back(temp);
                        break;
                    }
                    else {
                        temp += input.at(i);
                        i += 1;
                    }
                }
                else {
                    cout << "ERROR - 4" << endl;
                    return 0;
                }
            }
        }
        else {
            i += 1;
        }
    }

    for(int i = 0; i < tokens.size(); i++) {
        cout << tokens.at(i) << " " << values.at(i) << endl;
    }
    return 0;
}