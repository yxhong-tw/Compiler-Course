#include <iostream>
#include <vector>
#include <string.h>

using namespace std;


struct Rule {
    char nonTerminal;
    string production;
    bool hasLambda;
public:
    Rule(char nonTerminal, string production, bool hasLambda) {
        this->nonTerminal = nonTerminal;
        this->production = production;
        this->hasLambda = hasLambda;
    }
};

struct FSet {
    // if A's first set contains b, c, d three symbol
    // its nonTerminal would be A
    // its set would be bcd
    char nonTerminal;
    string set;
public:
    FSet(char nonTerminal, string set) {
        this->nonTerminal = nonTerminal;
        this->set = set;
    }
};

int getRuleIndex(vector<Rule> *, char);
int getFSetIndex(vector<FSet> *, char);

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
        bool hasLambda = false;

        for(int i = 2; i < strlen(input); i++) {
            if(input[i] == ';') {
                hasLambda = true;
            }
        }

        for(int i = 2; i < strlen(input); i++) {
            if(input[i] != '|') {
                production += input[i];
            }
            else {
                rules.push_back(Rule(nonTerminal, production, hasLambda));
                production = "";
            }
        }

        rules.push_back(Rule(nonTerminal, production, hasLambda));
        cin.getline(input, maxLineLength);
    }

    vector<FSet> firstSets, followSets, lastFollowSet;

    // handle first set part
    cin.getline(input, maxLineLength);

    while(strcmp(input, "END_OF_FIRST_SET")) { // if same, strcmp would return 0
        char nonTerminal = input[0];
        string production;

        for(int i = 2; i < strlen(input); i++) {
            production += input[i];
        }

        firstSets.push_back(FSet(nonTerminal, production));
        followSets.push_back(FSet(nonTerminal, ""));
        lastFollowSet.push_back(FSet(nonTerminal, ""));
        cin.getline(input, maxLineLength);
    }

    // sample code for observing the data, which constructed by input
    // for(int i = 0; i < rules.size(); i++) {
    //     cout << rules[i].nonTerminal << " -> " << rules[i].production << endl;
    // }

    // for(int i = 0; i < firstSets.size(); i++) {
    //     cout << firstSets[i].nonTerminal << "'s first set is " << firstSets[i].set << endl;
    // }

    // for(int i = 0; i < followSets.size(); i++) {
    //     followSets.at(i).set += "$";
    // }
    followSets.at(0).set += "$";

    bool breakKey = false;
    while(true) {
        for(int i = 0; i < rules.size(); i++) {
            for(int j = 0; j < rules.at(i).production.length(); j++) {
                int followSetIndex_j = getFSetIndex(&followSets, rules.at(i).production.at(j));

                if(followSetIndex_j == -1) {
                    continue;
                }

                for(int k = j + 1; k < rules.at(i).production.length(); k++) {
                    int firstSetIndex_k = getFSetIndex(&firstSets, rules.at(i).production.at(k));

                    if(firstSetIndex_k == -1) {
                        followSets.at(followSetIndex_j).set += rules.at(i).production.at(k);
                        break;
                    }
                    else {
                        followSets.at(followSetIndex_j).set += firstSets.at(firstSetIndex_k).set;

                        bool toEndAllLambda = true;
                        for(int l = k; l < rules.at(i).production.length(); l++) {
                            int followSetIndex_l = getFSetIndex(&followSets, rules.at(i).production.at(l));

                            if(followSetIndex_l == -1) {
                                followSets.at(followSetIndex_j).set += rules.at(i).production.at(l);
                            }
                            else {
                                int ruleIndex_l = getRuleIndex(&rules, rules.at(i).production.at(l));

                                if(rules.at(ruleIndex_l).hasLambda != true) {
                                    followSets.at(followSetIndex_j).set += followSets.at(followSetIndex_l).set;
                                    toEndAllLambda = false;
                                    break;
                                }
                            }
                        }

                        if(toEndAllLambda == true) {
                            followSets.at(followSetIndex_j).set += "$";
                        }
                        // if(rules.at(ruleIndex_k).hasLambda == true) {
                        //     int followSetIndex_k = getFSetIndex(&followSets, rules.at(i).production.at(k));
                        //     followSets.at(followSetIndex_j).set += followSets.at(followSetIndex_k).set;
                        // }
                        int ruleIndex_k = getRuleIndex(&rules, rules.at(i).production.at(k));

                        if(rules.at(ruleIndex_k).hasLambda != true) {
                            break;
                        }
                    }
                }

                if(j + 1 >= rules.at(i).production.length()) {
                    int followSetIndex_i = getFSetIndex(&followSets, rules.at(i).nonTerminal);
                    followSets.at(followSetIndex_j).set += followSets.at(followSetIndex_i).set;
                }
            }
        }

        for(int i = 0; i < followSets.size(); i++) {
            for(int j = 0; j < followSets.at(i).set.length(); j++) {
                for(int k = 0; k < followSets.at(i).set.length() - 1; k++) {
                    if(followSets.at(i).set.at(k) > followSets.at(i).set.at(k + 1)) {
                        char temp = followSets.at(i).set.at(k + 1);
                        followSets.at(i).set.at(k + 1) = followSets.at(i).set.at(k);
                        followSets.at(i).set.at(k) = temp;
                    }
                }
            }

            while(true) {
                bool done = true;
                for(int j = 0; j < followSets.at(i).set.length() - 1; j++) {
                    if(followSets.at(i).set.at(j) == followSets.at(i).set.at(j + 1)) {
                        followSets.at(i).set.erase(followSets.at(i).set.begin() + j);
                        done = false;
                        break;
                    }
                    else if(followSets.at(i).set.at(j) == ';') {
                        followSets.at(i).set.erase(followSets.at(i).set.begin() + j);
                        done = false;
                        break;
                    }
                }

                if(done == true) {
                    break;
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

        if(breakKey == true) {
            for(int i = 0; i < followSets.size(); i++) {
                cout << followSets.at(i).nonTerminal << " " << followSets.at(i).set << endl;
            }
            break;
        }
    }

    return 0;
}

int getRuleIndex(vector<Rule> *rulePointer, char element) {
    for(int i = 0; i < rulePointer->size(); i++) {
        if(element == rulePointer->at(i).nonTerminal) {
            return i;
        }
    }

    return -1;
}

int getFSetIndex(vector<FSet> *fSetPointer, char element) {
    for(int i = 0; i < fSetPointer->size(); i++) {
        if(element == fSetPointer->at(i).nonTerminal) {
            return i;
        }
    }

    return -1;
}