#include <iostream>
#include <vector>

using namespace std;

int main(void) {
    string tempInput = "";
    vector<string> upInput, pInput;
    
    while(true) {
        cin >> tempInput;
        if(!cin.eof()) {
            upInput.push_back(tempInput);
        }
        else {
            break;
        }
    }

    string tempNum = "";
    for(int i = 0; i < upInput.size(); i++) {
        for(int j = 0; j < upInput.at(i).size(); j++) {
            switch(upInput.at(i).at(j)) {
                case '(':
                    pInput.push_back("LPR");
                    break;
                case ')':
                    pInput.push_back("RPR");
                    break;
                case '+':
                    pInput.push_back("PLUS");
                    break;
                case '-':
                    pInput.push_back("MINUS");
                    break;
                case '*':
                    pInput.push_back("MUL");
                    break;
                case '/':
                    pInput.push_back("DIV");
                    break;
                default:
                    tempNum += upInput.at(i).at(j);
                    if(j < upInput.at(i).size() - 1) {
                        if((upInput.at(i).at(j + 1) < 48) || (upInput.at(i).at(j + 1) > 57)) {
                            pInput.push_back("NUM " + tempNum);
                            tempNum = "";
                        }
                    }
                    else {
                        pInput.push_back("NUM " + tempNum);
                        tempNum = "";
                    }
                    break;
            }
        }
    }

    for(int i = 0; i < pInput.size(); i++) {
        cout << pInput.at(i);
        if(i != pInput.size() - 1) {
            cout << "\n";
        }
    }

    return 0;
}