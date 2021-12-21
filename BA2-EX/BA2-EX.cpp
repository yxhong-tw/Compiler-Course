#include <iostream>
#include <vector>
#include <string.h>

using namespace std;

struct Rule {
    // if has a rule like 「A -> BCD」
    // its nonTerminal would be A
    // its production would be BCD
    char nonTerminal;
    string production;
public:
    Rule(char nonTerminal, string production) {
        this->nonTerminal = nonTerminal;
        this->production = production;
    }
};

struct FirstSet {
    // if A's first set contains b, c, d three symbol
    // its nonTerminal would be A
    // its set would be bcd
    char nonTerminal;
    string set;
public:
    FirstSet(char nonTerminal, string set) {
        this->nonTerminal = nonTerminal;
        this->set = set;
    }
};

struct FollowSet {
    char nonTerminal;
    string set;
public:
    FollowSet(char nonTerminal, string set) {
        this->nonTerminal = nonTerminal;
        this->set = set;
    }
};

int getFollowSetIndex(vector<FollowSet> *, char);
int getFirstSetIndex(vector<FirstSet> *, char);

int main() {
    const int maxLineLength = 500;

    // the code to handle input
    vector<Rule> rules;
    char input[maxLineLength];

    // handle grammar part
    cin.getline(input, maxLineLength);

    while(strcmp(input, "END_OF_GRAMMAR")) { // if same, strcmp would return 0
        char nonTerminal = input[0];
        string production;

        for(int i = 2; i < strlen(input); i++) {
            if(input[i] != '|') {
                production += input[i];
            }
            else {
                rules.push_back(Rule(nonTerminal, production));
                production = "";
            }
        }

        rules.push_back(Rule(nonTerminal, production));
        cin.getline(input, maxLineLength);
    }

    vector<FirstSet> firstSets;
    vector<FollowSet> followSets;

    // handle first set part
    cin.getline(input, maxLineLength);

    while(strcmp(input, "END_OF_FIRST_SET")) { // if same, strcmp would return 0
        char nonTerminal = input[0];
        string production;

        for(int i = 2; i < strlen(input); i++) {
            production += input[i];
        }

        firstSets.push_back(FirstSet(nonTerminal, production));
        followSets.push_back(FollowSet(nonTerminal, ""));
        cin.getline(input, maxLineLength);
    }

    // sample code for observing the data, which constructed by input
    // for(int i = 0; i < rules.size(); i++) {
    //     cout << rules[i].nonTerminal << " -> " << rules[i].production << endl;
    // }

    // for(int i = 0; i < firstSets.size(); i++) {
    //     cout << firstSets[i].nonTerminal << "'s first set is " << firstSets[i].set << endl;
    // }

    vector<FollowSet> lastFollowSet;

    for(int i = 0; i < followSets.size(); i++) {
        followSets.at(i).set += "$";
    }

    bool breakKey = false;
    while(true) {
        for(int i = 0; i < rules.size(); i++) {
            for(int j = 0; j < rules.at(i).production.length(); j++) {
                int followSetIndex_j = getFollowSetIndex(&followSets, rules.at(i).production.at(j));
                bool hasLambda = false;

                for(int k = j + 1; k < rules.at(i).production.length(); k++) {
                    hasLambda = false;
                    int firstSetIndex_k = getFirstSetIndex(&firstSets, rules.at(i).production.at(k));

                    for(int l = 0; l < firstSets.at(firstSetIndex_k).set.length(); l++) {
                        if(firstSets.at(firstSetIndex_k).set.at(l) != ';') {
                            followSets.at(followSetIndex_j).set += firstSets.at(firstSetIndex_k).set.at(l);
                        }
                        else {
                            hasLambda = true;
                        }
                    }

                    if(!hasLambda) {
                        break;
                    }
                }

                if(hasLambda) {
                    int followSetIndex_i = getFollowSetIndex(&followSets, rules.at(i).nonTerminal);

                    followSets.at(followSetIndex_j).set += followSets.at(followSetIndex_i).set;
                }
            }
        }

        for(int i = 0; i < followSets.size(); i++) {
            if(followSets.at(i).set != lastFollowSet.at(i).set) {
                for(int j = 0; j < followSets.size(); j++) {
                    lastFollowSet.at(j).set = followSets.at(j).set;
                }
                break;
            }
            else if(i == followSets.size() - 1 && followSets.at(i).set == lastFollowSet.at(i).set) {
                breakKey = true;
            }
        }
    }

    return 0;
}

int getFollowSetIndex(vector<FollowSet> *followSetPointer, char element) {
    for(int i = 0; i < followSetPointer->size(); i++) {
        if(element == followSetPointer->at(i).nonTerminal) {
            return i;
        }
    }

    cout << "AAA " << element << endl;

    return -1;
}

int getFirstSetIndex(vector<FirstSet> *firstSetPointer, char element) {
    for(int i = 0; i < firstSetPointer->size(); i++) {
        if(element == firstSetPointer->at(i).nonTerminal) {
            return i;
        }
    }

    cout << "BBB " << element << endl;

    return -1;
}