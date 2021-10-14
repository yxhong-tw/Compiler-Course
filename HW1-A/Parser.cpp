#include <iostream>
#include <vector>

using namespace std;

typedef struct command {
    int index = 0;
    vector<string> terminals, tokens;
}command;

void scanner(vector<command> *);
void error();
void program(command *, command *);
void stmts(command *, command *);
void stmt(command *, command *);
void primary(command *, command *);
void primary_tail(command *, command *);

int main() {
    vector<command> uncheck_commands, checked_commands;
    scanner(&uncheck_commands);

    // process all commands
    for(int i = 0; i < uncheck_commands.size(); i++) {
        command uncheck_command = uncheck_commands.at(i), checked_command;
        program(&uncheck_command, &checked_command);
        checked_commands.push_back(checked_command);
    }

    // print results
    for(int i = 0; i < checked_commands.size(); i++) {
        for(int j = 0; j < checked_commands.at(i).tokens.size(); j++) {
            cout << checked_commands.at(i).tokens.at(j) << " " << checked_commands.at(i).terminals.at(j) << "\n";
        }
    }

    return 0;
}

void scanner(vector<command> *uncheck_commands_ptr) {
    // read all lines without getline()
    char temp_char;
    string temp_str = "";
    vector<string> inputs;
    while(!cin.get(temp_char).eof()) {
        if(temp_char == '\n') {
            inputs.push_back(temp_str);
            temp_str = "";
        }
        else {
            temp_str += temp_char;
        }
    }

    // process tokens
    for(int i = 0; i < inputs.size(); i++) {
        command temp_command;
        for(int j = 0; j < inputs.at(i).size(); j++) {
            // handle STRLIT
            if(inputs.at(i).at(j) == '"' && j != inputs.at(i).size() - 1) {
                temp_str = "\"";
                for(int k = j + 1; k < inputs.at(i).size(); k++) {
                    if(inputs.at(i).at(k) == '"') {
                        temp_str += '"';
                        temp_command.terminals.push_back(temp_str);
                        temp_command.tokens.push_back("STRLIT");
                        j = k;
                        break;
                    }
                    else if(k == inputs.at(i).size() - 1) {
                        error();
                    }
                    else {
                        temp_str += inputs.at(i).at(k);
                    }
                }
            }
            // handle LBR
            else if(inputs.at(i).at(j) == '(') {
                temp_command.terminals.push_back("(");
                temp_command.tokens.push_back("LBR");
            }
            // handle RBR
            else if(inputs.at(i).at(j) == ')') {
                if(inputs.at(i).at(j - 1) == '(') {
                    temp_command.terminals.push_back("");
                    temp_command.tokens.push_back("LAMBDA");
                }
                temp_command.terminals.push_back(")");
                temp_command.tokens.push_back("RBR");
            }
            // handle DOT
            else if(inputs.at(i).at(j) == '.') {
                temp_command.terminals.push_back(".");
                temp_command.tokens.push_back("DOT");
            }
            // handle ID
            else if((inputs.at(i).at(j) >= 65 && inputs.at(i).at(j) <= 90) || (inputs.at(i).at(j) >= 97 && inputs.at(i).at(j) <= 122) || inputs.at(i).at(j) == '_') {
                temp_str = "";
                for(int k = j; k < inputs.at(i).size(); k++) {
                    if((inputs.at(i).at(k) >= 65 && inputs.at(i).at(k) <= 90) || (inputs.at(i).at(k) >= 97 && inputs.at(i).at(k) <= 122) || (inputs.at(i).at(k) >= 48 && inputs.at(i).at(k) <= 57) || inputs.at(i).at(k) == '_') {
                        temp_str += inputs.at(i).at(k);
                    }
                    else {
                        temp_command.terminals.push_back(temp_str);
                        temp_command.tokens.push_back("ID");
                        j = k - 1;
                        temp_str = "";
                        break;
                    }
                }
                if(temp_str != "") {
                    temp_command.terminals.push_back(temp_str);
                    temp_command.tokens.push_back("ID");
                    j = inputs.at(i).size() - 1;
                    temp_str = "";
                }
            }
            else {
                error();
            }
        }

        temp_command.terminals.push_back("");
        temp_command.tokens.push_back("LAMBDA");

        // special case
        if(temp_command.tokens.back() != "STRLIT") {
            temp_command.terminals.push_back("");
            temp_command.tokens.push_back("LAMBDA");
        }

        uncheck_commands_ptr->push_back(temp_command);
    }
}

// catch exceptions
void error() {
    cout << "invalid input\n";
    exit(0);
}

void program(command *uncheck_command, command *checked_command) {
    if(uncheck_command->tokens.front() == "ID" || uncheck_command->tokens.front() == "STRLIT" || uncheck_command->tokens.front() == "LAMBDA") {
        stmts(uncheck_command, checked_command);
    }
    else {
        error();
    }
}

void stmts(command *uncheck_command, command *checked_command) {
    if(uncheck_command->tokens.front() == "ID" || uncheck_command->tokens.front() == "STRLIT") {
        stmt(uncheck_command, checked_command);
        stmts(uncheck_command, checked_command);
    }
    else if(uncheck_command->tokens.front() == "LAMBDA") {
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
    }
    else {
        error();
    }
}

void stmt(command *uncheck_command, command *checked_command) {
    if(uncheck_command->tokens.front() == "ID") {
        primary(uncheck_command, checked_command);
    }
    else if(uncheck_command->tokens.front() == "STRLIT") {
        checked_command->tokens.push_back(uncheck_command->tokens.front());
        checked_command->terminals.push_back(uncheck_command->terminals.front());
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
    }
    else if(uncheck_command->tokens.front() == "LAMBDA") {
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
    }
    else {
        error();
    }
}

void primary(command *uncheck_command, command *checked_command) {
    if(uncheck_command->tokens.front() == "ID") {
        checked_command->tokens.push_back(uncheck_command->tokens.front());
        checked_command->terminals.push_back(uncheck_command->terminals.front());
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
        primary_tail(uncheck_command, checked_command);
    }
    else {
        error();
    }
}

void primary_tail(command *uncheck_command, command *checked_command) {
    if(uncheck_command->tokens.front() == "DOT") {
        checked_command->tokens.push_back(uncheck_command->tokens.front());
        checked_command->terminals.push_back(uncheck_command->terminals.front());
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
        
        if(uncheck_command->tokens.front() == "ID") {
            checked_command->tokens.push_back(uncheck_command->tokens.front());
            checked_command->terminals.push_back(uncheck_command->terminals.front());
            uncheck_command->tokens.erase(uncheck_command->tokens.begin());
            uncheck_command->terminals.erase(uncheck_command->terminals.begin());
            primary_tail(uncheck_command, checked_command);
        }
        else {
            error();
        }
    }
    else if(uncheck_command->tokens.front() == "LBR") {
        checked_command->tokens.push_back(uncheck_command->tokens.front());
        checked_command->terminals.push_back(uncheck_command->terminals.front());
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
        stmt(uncheck_command, checked_command);

        if(uncheck_command->tokens.front() == "RBR") {
            checked_command->tokens.push_back(uncheck_command->tokens.front());
            checked_command->terminals.push_back(uncheck_command->terminals.front());
            uncheck_command->tokens.erase(uncheck_command->tokens.begin());
            uncheck_command->terminals.erase(uncheck_command->terminals.begin());
            primary_tail(uncheck_command, checked_command);
        }
        else {
            error();
        }
    }
    else if(uncheck_command->tokens.front() == "LAMBDA") {
        uncheck_command->tokens.erase(uncheck_command->tokens.begin());
        uncheck_command->terminals.erase(uncheck_command->terminals.begin());
    }
    else {
        error();
    }
}