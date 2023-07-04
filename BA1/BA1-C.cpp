#include <iostream>
#include <vector>

using namespace std;

int i = 0;
vector<string> tokens, values;

void htmlDocument();
void htmlElement();
void htmlContent();
void htmlAttributeList();
void htmlAttribute();
void htmlChardata();
void attribute();
void error();
int checksize();

int main()
{
    string input = "";
    getline(cin, input);

    int in_tag = 0;
    for (int k = 0; k < input.length();)
    {
        if (input.at(k) == '<')
        {
            if (k != input.length() - 1)
            {
                if (input.at(k + 1) == '/')
                {
                    tokens.push_back("TAG_OPEN_SLASH");
                    values.push_back("</");
                    k += 2;
                }
                else
                {
                    tokens.push_back("TAG_OPEN");
                    values.push_back("<");
                    k += 1;
                }
            }
            in_tag = 1;
        }
        else if (input.at(k) == '>')
        {
            tokens.push_back("TAG_CLOSE");
            values.push_back(">");
            k += 1;
            in_tag = 0;
        }
        else if (input.at(k) == '=')
        {
            tokens.push_back("TAG_EQUALS");
            values.push_back("=");
            k += 1;
        }
        else if (input.at(k) == '\'' && in_tag == 1)
        {
            string temp = "";
            while (true)
            {
                k++;
                if (k <= input.length())
                {
                    if (input.at(k) == '\'')
                    {
                        tokens.push_back("SINGLE_QUOTE_STRING");
                        values.push_back(temp);
                        k++;
                        break;
                    }
                    else
                    {
                        temp += input.at(k);
                    }
                }
                else
                {
                    cout << "ERROR - 1" << endl;
                    return 0;
                }
            }
        }
        else if (input.at(k) == '\"' && in_tag == 1)
        {
            string temp = "";
            while (true)
            {
                k++;
                if (k <= input.length())
                {
                    if (input.at(k) == '\"')
                    {
                        tokens.push_back("DOUBLE_QUOTE_STRING");
                        values.push_back(temp);
                        k++;
                        break;
                    }
                    else
                    {
                        temp += input.at(k);
                    }
                }
                else
                {
                    cout << "ERROR - 2" << endl;
                    return 0;
                }
            }
        }
        else if (((input.at(k) >= 'a' && input.at(k) <= 'z') || (input.at(k) >= 'A' && input.at(k) <= 'Z') || (input.at(k) >= '0' && input.at(k) <= '9')) && in_tag == 1)
        {
            string temp = "";
            while (true)
            {
                if (k <= input.length())
                {
                    if (!((input.at(k) >= 'a' && input.at(k) <= 'z') || (input.at(k) >= 'A' && input.at(k) <= 'Z') || (input.at(k) >= '0' && input.at(k) <= '9')))
                    {
                        tokens.push_back("TAG_NAME");
                        values.push_back(temp);
                        break;
                    }
                    else
                    {
                        temp += input.at(k);
                        k += 1;
                    }
                }
                else
                {
                    cout << "ERROR - 3" << endl;
                    return 0;
                }
            }
        }
        else if (in_tag == 0 && input.at(k) != ' ')
        {
            string temp = "";
            while (true)
            {
                if (k <= input.length())
                {
                    if (input.at(k) == '<')
                    {
                        tokens.push_back("HTML_TEXT");
                        values.push_back(temp);
                        break;
                    }
                    else
                    {
                        temp += input.at(k);
                        k += 1;
                    }
                }
                else
                {
                    cout << "ERROR - 4" << endl;
                    return 0;
                }
            }
        }
        else
        {
            k += 1;
        }
    }
    tokens.push_back("END");
    values.push_back("");

    htmlDocument();
    return 0;
}

void htmlDocument()
{
    // if (i > tokens.size() - 1 && tokens.size() != 0)
    if (tokens.size() > 1)
    {
        if(tokens.at(i) == "END") {
            cout << "htmlDocument" << endl;
            cout << "valid" << endl;
        }
        else if (tokens.at(i) == "TAG_OPEN")
        {
            htmlElement();
            cout << "htmlElement" << endl;

            if (tokens.at(i) == "END")
            {
                htmlDocument();
            }
            else if (tokens.at(i) == "TAG_OPEN")
            {
                htmlDocument();
                cout << "htmlDocument" << endl;
            }
            else
            {
                error();
            }
        }
        else
        {
            error();
        }
    }
    else {
        error();
    }
}

void htmlElement()
{
    if (checksize())
    {
        if (tokens.at(i) == "TAG_OPEN")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_NAME")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_NAME")
        {
            htmlAttributeList();
            cout << "htmlAttributeList" << endl;
        }
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_CLOSE")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "HTML_TEXT" || tokens.at(i) == "TAG_OPEN")
        {
            htmlContent();
            cout << "htmlContent" << endl;
        }
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_OPEN_SLASH")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_NAME")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_CLOSE")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }
}

void htmlContent()
{
    if (tokens.at(i) == "HTML_TEXT")
    {
        htmlChardata();
        cout << "htmlCharData" << endl;
    }
    else if (tokens.at(i) == "TAG_OPEN")
    {
        htmlElement();
        cout << "htmlElement" << endl;
    }

    if (tokens.at(i) == "HTML_TEXT" || tokens.at(i) == "TAG_OPEN")
    {
        htmlContent();
        cout << "htmlContent" << endl;
    }
}

void htmlAttributeList()
{
    if (tokens.at(i) == "TAG_NAME")
    {
        htmlAttribute();
        cout << "htmlAttribute" << endl;
    }
    if (tokens.at(i) == "TAG_NAME")
    {
        htmlAttributeList();
        cout << "htmlAttributeList" << endl;
    }
}

void htmlAttribute()
{
    if (checksize())
    {
        if (tokens.at(i) == "TAG_NAME")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (checksize())
    {
        if (tokens.at(i) == "TAG_EQUALS")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }

    if (tokens.at(i) == "SINGLE_QUOTE_STRING" || tokens.at(i) == "DOUBLE_QUOTE_STRING")
    {
        attribute();
        cout << "attribute" << endl;
    }
    else
    {
        error();
    }
}

void htmlChardata()
{
    if (checksize())
    {
        if (tokens.at(i) == "HTML_TEXT")
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }
}

void attribute()
{
    if (checksize())
    {
        if (tokens.at(i) == "SINGLE_QUOTE_STRING" && checksize())
        {
            i += 1;
        }
        else if (tokens.at(i) == "DOUBLE_QUOTE_STRING" && checksize())
        {
            i += 1;
        }
        else
        {
            error();
        }
    }
    else
    {
        error();
    }
}

void error()
{
    cout << "invalid" << endl;
    exit(0);
}

int checksize()
{
    if (i + 1 < tokens.size())
    {
        return 1;
    }
    else
    {
        return 0;
    }
}