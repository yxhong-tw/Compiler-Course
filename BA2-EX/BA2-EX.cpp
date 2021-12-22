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
    /* Process input */
    const int maxLineLength = 500;

    vector<Rule> rules;
    char input[maxLineLength];

    cin.getline(input, maxLineLength);

    while(strcmp(input, "END_OF_GRAMMAR")) {    // If input is same as string, strcmp will return 0
        char nonTerminal = input[0];
        string production;
        bool hasLambda = false;

        for(int i = 2; i < strlen(input); i++) {    // If input contain ';', set hasLambda as true
            if(input[i] == ';') {
                hasLambda = true;
            }
        }

        for(int i = 2; i < strlen(input); i++) {
            if(input[i] != '|') {
                production += input[i];
            }
            else {  // If input contain '|' means there are more than one line of grammar
                rules.push_back(Rule(nonTerminal, production, hasLambda));
                production = "";
            }
        }

        rules.push_back(Rule(nonTerminal, production, hasLambda));

        cin.getline(input, maxLineLength);
    }

    vector<FSet> firstSets, followSets, lastFollowSet;

    cin.getline(input, maxLineLength);

    while(strcmp(input, "END_OF_FIRST_SET")) { // If input is same as string, strcmp will return 0
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

    /* Process lambda */
    vector<Rule> lastRules = rules;

    while(true) {
        bool breakKey = false;

        for(int i = 0; i < rules.size(); i++) {
            if(rules.at(i).hasLambda == true) {
                continue;
            }

            for(int j = 0; j < rules.at(i).production.length(); j++) {
                int ruleIndex_j = getRuleIndex(&rules, rules.at(i).production.at(j));

                if(ruleIndex_j == -1) { // If rules.at(i).production.at(j) is terminal, ruleIndex_j = -1
                    break;
                }

                if(rules.at(ruleIndex_j).hasLambda == false) {
                    break;
                }
                else if(j == rules.at(i).production.length() - 1 && rules.at(ruleIndex_j).hasLambda == true) {
                    rules.at(i).hasLambda = true;
                }
            }
        }

        for(int i = 0; i < rules.size(); i++) {
            // If rules is not same as lastRules, do the same thing until they are same as each other
            if(rules.at(i).hasLambda != lastRules.at(i).hasLambda) {
                break;
            }
            else if(i == rules.size() - 1 && rules.at(i).hasLambda == lastRules.at(i).hasLambda) {
                breakKey = true;
            }
        }

        if(breakKey == true) {
            break;
        }
        else {
            lastRules = rules;
        }
    }

    /* Do follow set */
    followSets.at(0).set += "$";    // rule 1

    bool breakKey = false;
    while(true) {
        for(int i = 0; i < rules.size(); i++) { // All grammar
            for(int j = 0; j < rules.at(i).production.length(); j++) {  // All right hand side
                bool allLambda = false;

                int followSetIndex_j = getFSetIndex(&followSets, rules.at(i).production.at(j));

                if(followSetIndex_j == -1) {    // If rules.at(i).production.at(j) is terminal
                    continue;
                }

                for(int k = j + 1; k < rules.at(i).production.length(); k++) {
                    int firstSetIndex_k = getFSetIndex(&firstSets, rules.at(i).production.at(k));

                    if(firstSetIndex_k == -1) { // If rules.at(i).production.at(k) is terminal
                        followSets.at(followSetIndex_j).set += rules.at(i).production.at(k);
                        break;
                    }
                    else {
                        /* rule 2 */
                        followSets.at(followSetIndex_j).set += firstSets.at(firstSetIndex_k).set;

                        int ruleIndex_k = getRuleIndex(&rules, rules.at(i).production.at(k));

                        if(rules.at(ruleIndex_k).hasLambda != true) {
                            break;
                        }
                        else if(k == rules.at(i).production.length() - 1 && rules.at(ruleIndex_k).hasLambda == true) {
                            allLambda = true;
                        }
                        else if(rules.at(ruleIndex_k).hasLambda == true){
                            continue;
                        }
                        else {
                            cout << "This is impossible case." << endl;
                        }
                    }
                }

                if(j + 1 >= rules.at(i).production.length()) {  // To the end
                    allLambda = true;
                }

                if(allLambda == true) {
                    int followSetIndex_i = getFSetIndex(&followSets, rules.at(i).nonTerminal);

                    /* rule 3 */
                    followSets.at(followSetIndex_j).set += followSets.at(followSetIndex_i).set;
                }
            }
        }

        for(int i = 0; i < followSets.size(); i++) {
            /* Do bubble sort to sort the set from small to big of ascii code */
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
                    /* Delete repeat elements */
                    if(followSets.at(i).set.at(j) == followSets.at(i).set.at(j + 1)) {
                        followSets.at(i).set.erase(followSets.at(i).set.begin() + j);
                        done = false;
                        break;
                    }
                    /* Delete ';' */
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

        /* Do the same thing until followSets is same as lastFollowSet */
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
            FSet temp = FSet('\0', "");

            /* Do bubble sort to sort nonterminal from small to big of ascii code */
            for(int i = 0; i < followSets.size(); i++) {
                for(int j = 0; j < followSets.size() - 1; j++) {
                    if(followSets.at(j).nonTerminal > followSets.at(j + 1).nonTerminal) {
                        temp = followSets.at(j + 1);
                        followSets.at(j + 1) = followSets.at(j);
                        followSets.at(j) = temp;
                    }
                }
            }

            /* Print the result */
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