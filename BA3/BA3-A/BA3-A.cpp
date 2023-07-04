#include <iostream>
#include <vector>

using namespace std;

int main() {
    string input, command, value;
    bool isCommand;
    vector<int> stack;

    int temp;

    while(true) {
        cin >> command;

        if(command == "$") {
            cout << stack.at(stack.size() - 1);
            break;
        }
        else {
            if(command == "push") {
                cin >> value;
                stack.push_back(stoi(value));
            }
            else if(command == "inverse") {
                temp = stack.at(stack.size() - 1);
                stack.at(stack.size() - 1) = stack.at(stack.size() - 2);
                stack.at(stack.size() - 2) = temp;
            }
            else if(command == "inc") {
                stack.at(stack.size() - 1) += 1;
            }
            else if(command == "dec") {
                stack.at(stack.size() - 1) -= 1;
            }
        }
    }
    return 0;
}