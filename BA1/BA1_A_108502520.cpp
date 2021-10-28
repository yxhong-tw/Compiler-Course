#include <iostream>

using namespace std;

int main() {
    string input = "";
    cin >> input;
    if(input.length() < 2) {
        cout << "NO";
    }
    else {
        if(input.at(0) == 'a') {
            if(input.at(1) == 'a') {
                for(int i = 1; i < input.length(); i++) {
                    if(input.at(i) == 'a' && i < input.length() - 2) {
                    }
                    else if(input.at(i) == 'b' && i == input.length() - 2) {
                        if(input.at(i + 1) == '$') {
                            cout << "YES s4";
                            break;
                        }
                        else {
                            cout << "NO";
                            break;
                        }
                    }
                    else {
                        cout << "NO";
                        break;
                    }
                }
            }
            else if(input.at(1) == 'b' && input.length() == 3) {
                if(input.at(2) == '$') {
                    cout << "YES s4";
                }
                else {
                    cout << "NO";
                }
            }
            else {
                cout << "NO";
            }
        }
        else if(input.at(0) == 'b') {
            if(input.at(1) == 'a') {
                for(int i = 1; i < input.length(); i++) {
                    if(input.at(i) == 'a' && i < input.length() - 2) {
                    }
                    else if(input.at(i) == 'a' && i == input.length() - 2) {
                        if(input.at(i + 1) == '$') {
                            cout << "YES s3";
                            break;
                        }
                        else {
                            cout << "NO";
                            break;
                        }
                    }
                    else if(input.at(i) == 'c' && i == input.length() - 2) {
                        if(input.at(i + 1) == '$') {
                            cout << "YES s4";
                            break;
                        }
                        else {
                            cout << "NO";
                            break;
                        }
                    }
                    else {
                        cout << "NO";
                        break;
                    }
                }
            }
            else if(input.at(1) == 'c' && input.length() == 3) {
                if(input.at(2) == '$') {
                    cout << "YES s4";
                }
                else {
                    cout << "NO";
                }
            }
            else if(input.at(1) == '$') {
                cout << "YES s3";
            }
            else {
                cout << "NO";
            }
        }
        else {
            cout << "NO";
        }
    }
}