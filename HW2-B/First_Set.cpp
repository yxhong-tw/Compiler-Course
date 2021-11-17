#include <iostream>
#include <vector>


using namespace std;


int getInput(vector<string>*);
int splitData(vector<string>*, vector<string>*, vector<vector<string>>*);
int runAllNonTerminalSymbols(vector<string>*, vector<vector<string>>*, vector<vector<string>>*);
int getFirstSet(vector<string>*, vector<vector<string>>*, string, vector<string>*, bool*);
int findIndex(vector<string>*, string);
int checkSame(vector<string>*, string);
void catchError(string);


int main()
{
    vector<string> lines;

    if(getInput(&lines) != 1)
    {
        catchError("getInput error");
    }

    vector<string> nonTerminalSymbols;
    vector<vector<string>> rightHands;

    if(splitData(&lines, &nonTerminalSymbols, &rightHands) != 1)
    {
        catchError("splitData error");
    }

    vector<vector<string>> firstSets;

    if(runAllNonTerminalSymbols(&nonTerminalSymbols, &rightHands, &firstSets) != 1)
    {
        catchError("runAllNonTerminalSymbols error");
    }

    /* test function */
    // for(int i = 0; i < nonTerminalSymbols.size(); i++) {
    //     cout << nonTerminalSymbols.at(i) << endl;

    //     for(int j = 0; j < rightHands.at(i).size(); j++) {
    //         cout << rightHands.at(i).at(j) << " ";
    //     }
    //     cout << endl;
    // }
    for(int i = 0; i < firstSets.size(); i++)
    {
        cout << nonTerminalSymbols.at(i) << ": ";

        for(int j = 0; j < firstSets.at(i).size(); j++)
        {
            cout << firstSets.at(i).at(j) << " ";
        }

        cout << endl;
    }

    return 48763;
}


int getInput(vector<string>* linesPtr)
{
    string tempStr = "";

    while(true)
    {
        getline(cin, tempStr);

        if(tempStr == "END_OF_GRAMMAR") {
            break;
        }

        linesPtr->push_back(tempStr);
    }

    return 1;
}


int splitData(vector<string>* lineStr, vector<string>* nonTerminalSymbolsPtr, vector<vector<string>>* rightHandsPtr)
{
    for(int i = 0; i < lineStr->size(); i++)
    {
        int j = 0;
        string tempStr = "";

        for(j; j < lineStr->at(i).length(); j++)
        {
            if(lineStr->at(i).at(j) != ' ')
            {
                tempStr += lineStr->at(i).at(j);
            }
            else
            {
                nonTerminalSymbolsPtr->push_back(tempStr);

                tempStr = "";
                j += 1;

                break;
            }
        }

        for(j; j < lineStr->at(i).length(); j++)
        {
            tempStr += lineStr->at(i).at(j);

            if(j == lineStr->at(i).length() - 1)
            {
                vector<string> tempVec;
                string tempStr2 = "";

                for(int k = 0; k < tempStr.length(); k++)
                {
                    if(tempStr.at(k) != '|')
                    {
                        tempStr2 += tempStr.at(k);
                    }

                    if(tempStr.at(k) == '|' || (k == tempStr.length() - 1 && tempStr != ""))
                    {
                        tempVec.push_back(tempStr2);
                        tempStr2 = "";
                    }
                }

                rightHandsPtr->push_back(tempVec);
            }
        }
    }

    return 1;
}


int runAllNonTerminalSymbols(vector<string>* nonTerminalSymbolsPtr, vector<vector<string>>* rightHandsPtr, vector<vector<string>>* firstSetsPtr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        vector<string> firstSet;
        bool hasLambda = false;

        if(getFirstSet(nonTerminalSymbolsPtr, rightHandsPtr, nonTerminalSymbolsPtr->at(i), &firstSet, &hasLambda) != 1)
        {
            catchError("getFirstSet error");
        }

        firstSetsPtr->push_back(firstSet);
    }

    return 1;
}


int getFirstSet(vector<string>* nonTerminalSymbolsPtr, vector<vector<string>>* rightHandsPtr, string currentStr, vector<string>* firstSetPtr, bool* hasLambdaPtr)
{
    if(checkSame(nonTerminalSymbolsPtr, currentStr))
    {
        int index = findIndex(nonTerminalSymbolsPtr, currentStr);

        if(index == -1)
        {
            catchError("findIndex error");
        }

        for(int i = 0; i < rightHandsPtr->at(index).size(); i++)
        {
            bool hasLambda = false;

            for(int j = 0; j < rightHandsPtr->at(index).at(i).size(); j++)
            {
                string tempStr = "";
                tempStr += rightHandsPtr->at(index).at(i).at(j);
                if(getFirstSet(nonTerminalSymbolsPtr, rightHandsPtr, tempStr, firstSetPtr, &hasLambda) != 1)
                {
                    catchError("getFirstSet error");
                }

                if(hasLambda == false)
                {
                    break;
                }

                if(*hasLambdaPtr == false)
                {
                    *hasLambdaPtr = true;
                }
            }
        }
    }
    else if(currentStr == ";")
    {
        if(checkSame(firstSetPtr, currentStr) == 0)
        {
            firstSetPtr->push_back(currentStr);
        }
        
        *hasLambdaPtr = true;
    }
    else
    {
        if(checkSame(firstSetPtr, currentStr) == 0)
        {
            firstSetPtr->push_back(currentStr);
        }
    }

    return 1;
}


int findIndex(vector<string>* nonTerminalSymbolsPtr, string currentStr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        if(currentStr == nonTerminalSymbolsPtr->at(i))
        {
            return i;
        }
    }

    return -1;
}


int checkSame(vector<string>* vecStrPtr, string currentStr)
{
    for(int i = 0; i < vecStrPtr->size(); i++)
    {
        if(currentStr == vecStrPtr->at(i))
        {
            return 1;
        }
    }

    return 0;
}


void catchError(string errorType)
{
    cout << errorType << endl;
    exit(48763);
}