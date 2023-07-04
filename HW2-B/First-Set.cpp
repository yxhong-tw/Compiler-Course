#include <iostream>
#include <vector>


using namespace std;


typedef struct nonTerminalSymbol
{
    string name;
    vector<string> rightHand;
    string firstSet = "";
    bool hasLambda = false;
}nonTerminalSymbol;


int getInput(vector<string>*);
int splitData(vector<string>*, vector<nonTerminalSymbol>*);
int runAllNonTerminalSymbols(vector<nonTerminalSymbol>*);
int getFirstSet(vector<nonTerminalSymbol>*, string);
int findIndex(vector<nonTerminalSymbol>*, string);
int checkTerminalSymbol(vector<nonTerminalSymbol>* , string);
int checkSame(string, string);
int sortNonTerminalSymbols(vector<nonTerminalSymbol>*);
int sortFirstSets(vector<nonTerminalSymbol>*);
void catchError(string);


int main()
{
    vector<string> lines;

    if(getInput(&lines) != 1)
    {
        catchError("getInput error");
    }

    vector<nonTerminalSymbol> nonTerminalSymbols;

    if(splitData(&lines, &nonTerminalSymbols) != 1)
    {
        catchError("splitData error");
    }

    if(runAllNonTerminalSymbols(&nonTerminalSymbols) != 1)
    {
        catchError("runAllNonTerminalSymbols error");
    }

    if(sortNonTerminalSymbols(&nonTerminalSymbols) != 1)
    {
        catchError("sortNonTerminalSymbols error");
    }

    if(sortFirstSets(&nonTerminalSymbols) != 1)
    {
        catchError("sortFirstSets error");
    }

    /* test function */
    for(int i = 0; i < nonTerminalSymbols.size(); i++)
    {
        cout << nonTerminalSymbols.at(i).name << " " << nonTerminalSymbols.at(i).firstSet << endl;
    }

    cout << "END_OF_FIRST" << endl;

    return 0;
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


int splitData(vector<string>* lineStr, vector<nonTerminalSymbol>* nonTerminalSymbolsPtr)
{
    for(int i = 0; i < lineStr->size(); i++)
    {
        int j = 0;
        string tempStr = "";
        nonTerminalSymbol tempNTS;

        for(j; j < lineStr->at(i).length(); j++)
        {
            if(lineStr->at(i).at(j) != ' ')
            {
                tempStr += lineStr->at(i).at(j);
            }
            else
            {
                tempNTS.name = tempStr;
                tempStr = "";

                j += 1;

                break;
            }
        }


        for(j; j < lineStr->at(i).length(); j++)
        {            
            if(lineStr->at(i).at(j) == '|')
            {
                tempNTS.rightHand.push_back(tempStr);
                tempStr = "";
            }
            else if(j == lineStr->at(i).length() - 1)
            {
                tempStr += lineStr->at(i).at(j);
                tempNTS.rightHand.push_back(tempStr);
                tempStr = "";                
            }
            else
            {
                tempStr += lineStr->at(i).at(j);
            }
        }

        nonTerminalSymbolsPtr->push_back(tempNTS);
    }

    return 1;
}


int runAllNonTerminalSymbols(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        if(nonTerminalSymbolsPtr->at(i).firstSet == "")
        {
            if(getFirstSet(nonTerminalSymbolsPtr, nonTerminalSymbolsPtr->at(i).name) != 1)
            {
                catchError("getFirstSet error");
            }
        }
    }

    return 1;
}


int getFirstSet(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr, string currentStr)
{
    int index = findIndex(nonTerminalSymbolsPtr, currentStr);

    if(index == -1)
    {
        catchError("findIndex error");
    }

    for(int i = 0; i < nonTerminalSymbolsPtr->at(index).rightHand.size(); i++)
    {
        for(int j = 0; j < nonTerminalSymbolsPtr->at(index).rightHand.at(i).length(); j++)
        {
            // cout << nonTerminalSymbolsPtr->at(index).name << " " << nonTerminalSymbolsPtr->at(index).rightHand.at(i).size() << endl;
            string tempStr = "";
            tempStr += nonTerminalSymbolsPtr->at(index).rightHand.at(i).at(j);

            if(checkTerminalSymbol(nonTerminalSymbolsPtr, tempStr))
            {
                int index2 = findIndex(nonTerminalSymbolsPtr, tempStr);

                if(index2 == -1)
                {
                    catchError("findIndex error");
                }

                if(nonTerminalSymbolsPtr->at(index2).firstSet == "")
                {
                    if(getFirstSet(nonTerminalSymbolsPtr, tempStr) != 1)
                    {
                        catchError("getFirstSet error");
                    }
                }

                for(int k = 0; k < nonTerminalSymbolsPtr->at(index2).firstSet.length(); k++)
                {
                    if(nonTerminalSymbolsPtr->at(index2).firstSet.at(k) != ';')
                    {
                        string tempStr2 = "";
                        tempStr2 += nonTerminalSymbolsPtr->at(index2).firstSet.at(k);
                        if(checkSame(nonTerminalSymbolsPtr->at(index).firstSet, tempStr2) == 1)
                        {
                            nonTerminalSymbolsPtr->at(index).firstSet += nonTerminalSymbolsPtr->at(index2).firstSet.at(k);
                        }
                    }
                }

                if(nonTerminalSymbolsPtr->at(index2).hasLambda == false)
                {
                    break;
                }

                if(nonTerminalSymbolsPtr->at(index2).hasLambda == true && j == nonTerminalSymbolsPtr->at(index).rightHand.at(i).length() - 1)
                {
                    if(checkSame(nonTerminalSymbolsPtr->at(index).firstSet, ";") == 1)
                    {
                        nonTerminalSymbolsPtr->at(index).firstSet += ";";
                        nonTerminalSymbolsPtr->at(index).hasLambda = true;
                    }
                }
            }
            else
            {
                if(tempStr == ";")
                {
                    nonTerminalSymbolsPtr->at(index).hasLambda = true;
                }

                if(checkSame(nonTerminalSymbolsPtr->at(index).firstSet, tempStr) == 1)
                {
                    nonTerminalSymbolsPtr->at(index).firstSet += tempStr;
                }

                break;
            }
        }
    }

    return 1;
}


int findIndex(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr, string currentStr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        if(currentStr == nonTerminalSymbolsPtr->at(i).name)
        {
            return i;
        }
    }

    return -1;
}


int checkTerminalSymbol(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr, string currentStr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        if(currentStr == nonTerminalSymbolsPtr->at(i).name)
        {
            return 1;
        }
    }

    return 0;
}


int checkSame(string firstSetStr, string currentStr)
{
    for(int i = 0; i < firstSetStr.length(); i++)
    {
        string tempStr = "";
        tempStr += firstSetStr.at(i);
        if(currentStr == tempStr)
        {
            return 0;
        }
    }

    return 1;
}


int sortNonTerminalSymbols(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size() - 1; i++)
    {
        for(int j = 0; j < nonTerminalSymbolsPtr->size() - i - 1; j++) {
            if(nonTerminalSymbolsPtr->at(j).name > nonTerminalSymbolsPtr->at(j+1).name)
            {
                nonTerminalSymbol tempNTS = nonTerminalSymbolsPtr->at(j);
                nonTerminalSymbolsPtr->at(j) = nonTerminalSymbolsPtr->at(j + 1);
                nonTerminalSymbolsPtr->at(j + 1) = tempNTS;
            }
        }
    }

    return 1;
}


int sortFirstSets(vector<nonTerminalSymbol>* nonTerminalSymbolsPtr)
{
    for(int i = 0; i < nonTerminalSymbolsPtr->size(); i++)
    {
        for(int j = 0; j < nonTerminalSymbolsPtr->at(i).firstSet.length() - 1; j++)
        {
            for(int k = 0; k < nonTerminalSymbolsPtr->at(i).firstSet.length() - j - 1; k++)
            {
                if(nonTerminalSymbolsPtr->at(i).firstSet.at(k) > nonTerminalSymbolsPtr->at(i).firstSet.at(k + 1))
                {
                    char tempChar = nonTerminalSymbolsPtr->at(i).firstSet.at(k);
                    nonTerminalSymbolsPtr->at(i).firstSet.at(k) = nonTerminalSymbolsPtr->at(i).firstSet.at(k + 1);
                    nonTerminalSymbolsPtr->at(i).firstSet.at(k + 1) = tempChar;
                }
            }
        }
    }

    return 1;
}


void catchError(string errorType)
{
    cout << errorType << endl;
    exit(48763);
}